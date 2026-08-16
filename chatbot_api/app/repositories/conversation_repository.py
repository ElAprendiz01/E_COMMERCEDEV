import logging
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional
from app.database.connection import get_connection
from app.core.models.conversation import ConversationRequest
import json

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def _parse_timestamp(value) -> datetime:
    if value is None:
        return datetime.now(timezone.utc).replace(tzinfo=None)
    if isinstance(value, datetime):
        dt = value
    elif isinstance(value, str):
        s = value.strip()
        if s.endswith("Z"):
            s = s[:-1] + "+00:00"
        try:
            dt = datetime.fromisoformat(s)
        except Exception:
            try:
                if "." in s:
                    base, _ = s.split(".", 1)
                    dt = datetime.fromisoformat(base)
                else:
                    dt = datetime.fromisoformat(s)
            except Exception:
                dt = datetime.now(timezone.utc)
    else:
        dt = datetime.now(timezone.utc)
    if dt.tzinfo is not None:
        dt = dt.astimezone(timezone.utc).replace(tzinfo=None)
    return dt.replace(tzinfo=None)


class ConversationRepository:
    def _detect_table_name(self, cursor) -> str:
        """Determina si la base de datos utiliza 'HistorialConversaciones' o 'Conversaciones'."""
        try:
            cursor.execute("SELECT TOP 1 1 FROM dbo.HistorialConversaciones")
            cursor.fetchone()
            return "HistorialConversaciones"
        except Exception:
            return "Conversaciones"

    def guardar_conversacion(self, conversation: Dict[str, Any]) -> Dict[str, Any]:
        user_id = str(conversation.get("userId") or conversation.get("user_id") or "demo-user")
        messages = conversation.get("messages") or []
        provided_conv_id = conversation.get("conversation_id") or conversation.get("conversationId")

        logger.info("guardar_conversacion called; user_id=%s messages_count=%d provided_conv_id=%s",
                    user_id, len(messages), provided_conv_id)

        conn = get_connection()
        cursor = conn.cursor()
        try:
            table_name = self._detect_table_name(cursor)
            msg_table_name = "HistorialMensajes" if table_name == "HistorialConversaciones" else "Mensajes"
            conversation_id: Optional[int] = None

            if provided_conv_id is not None:
                cursor.execute(f"SELECT ConversacionID FROM dbo.{table_name} WHERE ConversacionID = ?", provided_conv_id)
                row = cursor.fetchone()
                if row:
                    conversation_id = int(row.ConversacionID)
                    cursor.execute(
                        f"UPDATE dbo.{table_name} SET UsuarioID = ?, Activo = 1 WHERE ConversacionID = ?",
                        user_id,
                        conversation_id
                    )
                else:
                    cursor.execute(
                        f"INSERT INTO dbo.{table_name} (UsuarioID, FechaInicio, Activo) OUTPUT INSERTED.ConversacionID VALUES (?, GETDATE(), 1)",
                        user_id
                    )
                    conversation_id = int(cursor.fetchone()[0])
            else:
                cursor.execute(
                    f"INSERT INTO dbo.{table_name} (UsuarioID, FechaInicio, Activo) OUTPUT INSERTED.ConversacionID VALUES (?, GETDATE(), 1)",
                    user_id
                )
                conversation_id = int(cursor.fetchone()[0])

            if not conversation_id:
                raise RuntimeError("No se pudo obtener el ConversacionID generado por la base de datos.")

            # Insertar mensajes asociados
            for msg in messages:
                role = (msg.get("role") or "").lower()
                is_bot_flag = msg.get("isBot")
                is_bot = 1 if (is_bot_flag is True or role in ("assistant", "bot", "chatbot")) else 0
                rol_str = "assistant" if is_bot else "user"

                texto = msg.get("content") or msg.get("texto") or ""
                if texto is None:
                    texto = ""

                timestamp = _parse_timestamp(msg.get("timestamp"))
                rule_id = msg.get("appliedRuleId") or msg.get("ReglaActivadaID")

                metadata = msg.get("metadata") or msg.get("Metadata") or msg.get("productos")
                metadata_json = None
                if metadata is not None:
                    try:
                        if isinstance(metadata, str):
                            try:
                                json.loads(metadata)
                                metadata_json = metadata
                            except Exception:
                                metadata_json = json.dumps(metadata, default=str)
                        else:
                            metadata_json = json.dumps(metadata, default=str)
                    except Exception:
                        metadata_json = json.dumps(str(metadata))

                if msg_table_name == "HistorialMensajes":
                    cursor.execute(
                        """INSERT INTO dbo.HistorialMensajes
                           (ConversacionID, ChatBot, Texto, FechaHora, ReglaActivadaID, MetadataJson)
                           VALUES (?, ?, ?, ?, ?, ?)""",
                        conversation_id, is_bot, texto, timestamp, rule_id, metadata_json
                    )
                else:
                    cursor.execute(
                        """INSERT INTO dbo.Mensajes
                           (ConversacionID, Rol, ChatBot, Contenido, FechaHora, ReglaActivadaID)
                           VALUES (?, ?, ?, ?, ?, ?)""",
                        conversation_id, rol_str, is_bot, texto, timestamp, rule_id
                    )

            conn.commit()
            return {"status": "ok", "conversation_id": conversation_id}
        except Exception as ex:
            conn.rollback()
            logger.exception("Error al guardar conversación")
            raise RuntimeError(f"Error al guardar conversación: {ex}")
        finally:
            cursor.close()
            conn.close()

    def guardar_mensaje(self, conversation_id, message):
        if not conversation_id:
            raise RuntimeError("conversation_id es requerido para guardar un mensaje.")

        conn = get_connection()
        cursor = conn.cursor()
        try:
            table_name = self._detect_table_name(cursor)
            msg_table_name = "HistorialMensajes" if table_name == "HistorialConversaciones" else "Mensajes"

            cursor.execute(f"SELECT ConversacionID FROM dbo.{table_name} WHERE ConversacionID = ?", conversation_id)
            if not cursor.fetchone():
                raise RuntimeError(f"La conversación {conversation_id} no existe en la base de datos.")

            role = (message.get("role") or "").lower()
            is_bot_flag = message.get("isBot")
            is_bot = 1 if (is_bot_flag is True or role in ("assistant", "bot", "chatbot")) else 0
            rol_str = "assistant" if is_bot else "user"

            texto = message.get("content") or message.get("texto") or ""
            if texto is None:
                texto = ""

            timestamp = _parse_timestamp(message.get("timestamp"))
            rule_id = message.get("appliedRuleId") or message.get("ReglaActivadaID")

            metadata = message.get("metadata") or message.get("Metadata") or message.get("productos")
            metadata_json = None
            if metadata is not None:
                try:
                    if isinstance(metadata, str):
                        try:
                            json.loads(metadata)
                            metadata_json = metadata
                        except Exception:
                            metadata_json = json.dumps(metadata, default=str)
                    else:
                        metadata_json = json.dumps(metadata, default=str)
                except Exception:
                    metadata_json = json.dumps(str(metadata))

            if msg_table_name == "HistorialMensajes":
                cursor.execute(
                    """INSERT INTO dbo.HistorialMensajes
                       (ConversacionID, ChatBot, Texto, FechaHora, ReglaActivadaID, MetadataJson)
                       VALUES (?, ?, ?, ?, ?, ?)""",
                    conversation_id, is_bot, texto, timestamp, rule_id, metadata_json
                )
            else:
                cursor.execute(
                    """INSERT INTO dbo.Mensajes
                       (ConversacionID, Rol, ChatBot, Contenido, FechaHora, ReglaActivadaID)
                       VALUES (?, ?, ?, ?, ?, ?)""",
                    conversation_id, rol_str, is_bot, texto, timestamp, rule_id
                )

            conn.commit()
            return {"status": "ok", "conversation_id": conversation_id}
        except Exception as ex:
            conn.rollback()
            logger.exception("Error al guardar mensaje")
            raise RuntimeError(f"Error al guardar mensaje: {ex}")
        finally:
            cursor.close()
            conn.close()

    def obtener_historial(self, conversation_request: ConversationRequest) -> List[Dict[str, Any]]:
        conversation_id = conversation_request.conversation_id
        conn = get_connection()
        cursor = conn.cursor()
        try:
            table_name = self._detect_table_name(cursor)
            msg_table_name = "HistorialMensajes" if table_name == "HistorialConversaciones" else "Mensajes"

            if msg_table_name == "HistorialMensajes":
                cursor.execute(
                    """SELECT MensajeID, ConversacionID, ChatBot, Texto AS Contenido, FechaHora, ReglaActivadaID, MetadataJson
                       FROM dbo.HistorialMensajes
                       WHERE ConversacionID = ?
                       ORDER BY FechaHora ASC""",
                    conversation_id
                )
            else:
                cursor.execute(
                    """SELECT MensajeID, ConversacionID, ChatBot, Contenido, FechaHora, ReglaActivadaID, NULL AS MetadataJson
                       FROM dbo.Mensajes
                       WHERE ConversacionID = ?
                       ORDER BY FechaHora ASC""",
                    conversation_id
                )

            historial: List[Dict[str, Any]] = []
            for row in cursor.fetchall():
                metadata_val = None
                productos = []
                if hasattr(row, 'MetadataJson') and row.MetadataJson:
                    try:
                        metadata_val = json.loads(row.MetadataJson)
                        if isinstance(metadata_val, dict) and "productos" in metadata_val:
                            productos = metadata_val.get("productos") or []
                        elif isinstance(metadata_val, list):
                            productos = metadata_val
                    except Exception:
                        metadata_val = row.MetadataJson

                historial.append({
                    "id": row.MensajeID,
                    "conversationId": row.ConversacionID,
                    "role": "assistant" if bool(row.ChatBot) else "user",
                    "content": row.Contenido or "",
                    "timestamp": row.FechaHora.isoformat() if row.FechaHora else None,
                    "isBot": bool(row.ChatBot),
                    "user_id": None,
                    "appliedRuleId": row.ReglaActivadaID,
                    "tipo": None,
                    "productos": productos,
                    "metadata": metadata_val,
                })
            return historial
        finally:
            cursor.close()
            conn.close()

    def listar_conversaciones(self, user_id: str, email: str = None) -> List[Dict[str, Any]]:
        conn = get_connection()
        cursor = conn.cursor()
        try:
            table_name = self._detect_table_name(cursor)
            msg_table_name = "HistorialMensajes" if table_name == "HistorialConversaciones" else "Mensajes"

            target_user = str(user_id) if user_id else ""
            target_email = str(email) if email else target_user

            cursor.execute(
                f"SELECT ConversacionID, UsuarioID, FechaInicio, Activo FROM dbo.{table_name} WHERE UsuarioID = ? OR UsuarioID = ? ORDER BY FechaInicio DESC",
                target_user,
                target_email
            )
            conversaciones: List[Dict[str, Any]] = []
            for row in cursor.fetchall():
                conv_id = row.ConversacionID

                if msg_table_name == "HistorialMensajes":
                    cursor.execute(
                        """SELECT MensajeID, ConversacionID, ChatBot, Texto AS Contenido, FechaHora, ReglaActivadaID, MetadataJson
                           FROM dbo.HistorialMensajes
                           WHERE ConversacionID = ?
                           ORDER BY FechaHora ASC""",
                        conv_id
                    )
                else:
                    cursor.execute(
                        """SELECT MensajeID, ConversacionID, ChatBot, Contenido, FechaHora, ReglaActivadaID, NULL AS MetadataJson
                           FROM dbo.Mensajes
                           WHERE ConversacionID = ?
                           ORDER BY FechaHora ASC""",
                        conv_id
                    )

                mensajes = []
                for m in cursor.fetchall():
                    metadata_val = None
                    productos = []
                    if hasattr(m, 'MetadataJson') and m.MetadataJson:
                        try:
                            metadata_val = json.loads(m.MetadataJson)
                            if isinstance(metadata_val, dict) and "productos" in metadata_val:
                                productos = metadata_val.get("productos") or []
                            elif isinstance(metadata_val, list):
                                productos = metadata_val
                        except Exception:
                            metadata_val = m.MetadataJson

                    mensajes.append({
                        "id": m.MensajeID,
                        "conversationId": m.ConversacionID,
                        "role": "assistant" if bool(m.ChatBot) else "user",
                        "content": m.Contenido or "",
                        "timestamp": m.FechaHora.isoformat() if m.FechaHora else None,
                        "isBot": bool(m.ChatBot),
                        "user_id": user_id,
                        "appliedRuleId": m.ReglaActivadaID,
                        "productos": productos,
                        "metadata": metadata_val
                    })

                conversaciones.append({
                    "id": conv_id,
                    "conversation_id": conv_id,
                    "user_id": user_id,
                    "title": mensajes[0]["content"][:30] if mensajes else "Nueva conversación",
                    "language": "es",
                    "lastIntent": None,
                    "createdAt": row.FechaInicio.isoformat() if row.FechaInicio else None,
                    "updatedAt": None,
                    "isActive": bool(row.Activo),
                    "messages": mensajes,
                    "context": {"language": "es", "session_variables": {}}
                })

            return conversaciones
        finally:
            cursor.close()
            conn.close()
