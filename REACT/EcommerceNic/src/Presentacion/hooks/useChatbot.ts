import { useState, useEffect } from 'react';
import { Alert } from 'react-native';
import { Conversation, Message } from '../../Domain/entities/Chat';
import { User } from '../../Domain/entities/User';
import { sendChatMessageUseCase } from '../../di/DI';
import { normalizeMetadata } from './normalizeMetadata';

export const useChatbot = (
  usuario: User,
  alAgregarProductoAlCarrito: (producto: any) => void
) => {
  const [conversaciones, setConversaciones] = useState<Conversation[]>([]);
  const [idConversacionActiva, setIdConversacionActiva] = useState<string | null>(null);
  const [estaEscribiendo, setEstaEscribiendo] = useState<boolean>(false);
  const [haCargadoHistorial, setHaCargadoHistorial] = useState<boolean>(false);

  const correoUsuario = usuario?.email ?? 'demo-user';
  const idBruto = parseInt(usuario?.id || '1', 10);
  const idUsuarioNumerico = (isNaN(idBruto) || idBruto <= 0 || idBruto > 2147483647) ? 1 : idBruto;

  const [mensajes, setMensajes] = useState<Message[]>([
    {
      id: 1,
      conversationId: 'default',
      role: 'assistant',
      isBot: true,
      content: '¿Y entonces chele qué andás buscando hoy? ¡Preguntame sobre celulares, consolas, hardware, audio o monitores!',
      timestamp: new Date().toISOString(),
      user_id: 'chatbot',
    },
  ]);

  // Cargar lista de conversaciones del usuario
  const cargarConversaciones = async (idUsuario?: string) => {
    try {
      const resultado = await sendChatMessageUseCase.getConversations(idUsuario);
      const mapeadas: Conversation[] = resultado.map((conversacion: any) => ({
        id: conversacion.id.toString(),
        userId: conversacion.userId,
        title: conversacion.title ?? 'Nueva conversación',
        startDate: conversacion.startDate ?? new Date().toISOString(),
        updatedAt: conversacion.updatedAt ?? new Date().toISOString(),
        isActive: conversacion.isActive ?? true,
        messages: Array.isArray(conversacion.messages)
          ? conversacion.messages.map((msg: any) => ({
              id: msg.id ?? Date.now(),
              conversationId: conversacion.id.toString(),
              role: msg.role ?? 'assistant',
              isBot: msg.isBot ?? msg.role !== 'user',
              content: msg.content ?? '',
              timestamp: msg.timestamp ?? new Date().toISOString(),
              tipo: msg.tipo,
              productos: msg.productos ?? [],
              metadata: normalizeMetadata(msg.metadata),
            }))
          : [],
      }));

      setConversaciones(mapeadas);
    } catch (error) {
      console.error('Error al cargar las conversaciones del chatbot:', error);
    }
  };

  useEffect(() => {
    if (idUsuarioNumerico) {
      cargarConversaciones(String(idUsuarioNumerico));
    }
  }, [idUsuarioNumerico]);

  // Crear una nueva conversación en blanco
  const crearNuevaConversacion = () => {
    setIdConversacionActiva(null);
    setMensajes([
      {
        id: Date.now(),
        conversationId: 'default',
        role: 'assistant',
        isBot: true,
        content: '¿Y entonces chele qué andás buscando hoy? ¡Preguntame sobre celulares, consolas, hardware, audio o monitores!',
        timestamp: new Date().toISOString(),
        user_id: 'chatbot',
      },
    ]);
  };

  // Guardar mensaje individual en la BD
  const persistirMensaje = async (idConversacion: string, mensaje: Message) => {
    try {
      await sendChatMessageUseCase.saveMessage(idConversacion, {
        role: mensaje.role,
        content: mensaje.content,
        timestamp: mensaje.timestamp,
        user_id: correoUsuario,
        isBot: mensaje.isBot,
        tipo: mensaje.tipo,
        productos: mensaje.productos ?? [],
        metadata: normalizeMetadata(mensaje.metadata),
      });
    } catch (error) {
      console.error('Error al persistir mensaje en el backend:', error);
    }
  };

  // Flujo principal de envío de mensajes al Chatbot
  const enviarMensaje = async (texto: string) => {
    const textoLimpio = texto.replace(/📱 |🎮 |💻 |🎧 |🔥 /g, '').trim();
    if (!textoLimpio) return;

    let idConvActual = idConversacionActiva;

    if (!idConvActual || idConvActual === 'default') {
      try {
        const tituloRecortado = textoLimpio.length > 25 ? `${textoLimpio.slice(0, 25)}...` : textoLimpio;
        const nuevaConv = await sendChatMessageUseCase.createConversation(
          String(idUsuarioNumerico),
          tituloRecortado
        );

        idConvActual = (nuevaConv.conversation_id ?? nuevaConv.id ?? Date.now()).toString();
        setIdConversacionActiva(idConvActual);

        const objetoNuevaConv: Conversation = {
          id: idConvActual,
          userId: correoUsuario,
          title: tituloRecortado,
          startDate: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
          isActive: true,
          messages: [],
        };
        setConversaciones(prev => [objetoNuevaConv, ...prev]);
        setHaCargadoHistorial(true);
      } catch (error) {
        console.error('Error al inicializar sesión de chat:', error);
        Alert.alert('Error', 'No se pudo establecer conexión para iniciar la conversación.');
        return;
      }
    }

    const mensajeUsuario: Message = {
      id: Date.now(),
      conversationId: idConvActual,
      role: 'user',
      isBot: false,
      content: textoLimpio,
      timestamp: new Date().toISOString(),
      user_id: correoUsuario,
    };

    setMensajes(prev => [...prev, mensajeUsuario]);
    setEstaEscribiendo(true);
    setHaCargadoHistorial(true);
    await persistirMensaje(idConvActual, mensajeUsuario);

    try {
      const respuesta = await sendChatMessageUseCase.execute(
        textoLimpio,
        idConvActual,
        String(idUsuarioNumerico)
      );

      const mensajeBot: Message = {
        id: Date.now() + 1,
        conversationId: idConvActual,
        role: 'assistant',
        isBot: true,
        content: respuesta.texto,
        timestamp: new Date().toISOString(),
        tipo: respuesta.tipo,
        productos: respuesta.productos ?? [],
        metadata: normalizeMetadata(respuesta.metadata),
        user_id: 'chatbot',
      };

      setMensajes(prev => [...prev, mensajeBot]);
      await persistirMensaje(idConvActual, mensajeBot);
      setHaCargadoHistorial(true);

      setConversaciones(prev =>
        prev.map(item =>
          item.id === idConvActual
            ? {
                ...item,
                updatedAt: new Date().toISOString(),
                title: item.title && item.title !== 'Nueva conversación' ? item.title : textoLimpio.slice(0, 25),
              }
            : item
        )
      );
    } catch (error: any) {
      console.error('Error en la respuesta del chatbot:', error);

      const mensajeFallback: Message = {
        id: Date.now() + 1,
        conversationId: idConvActual,
        role: 'assistant',
        isBot: true,
        content: '❌ Error al comunicarse con el servidor.',
        timestamp: new Date().toISOString(),
        user_id: 'chatbot',
      };
      setMensajes(prev => [...prev, mensajeFallback]);
      await persistirMensaje(idConvActual, mensajeFallback);
    } finally {
      setEstaEscribiendo(false);
    }
  };

  const seleccionarConversacion = (id: string) => {
    const seleccionada = conversaciones.find(c => c.id === id);
    if (seleccionada) {
      setIdConversacionActiva(id);
      const mensajesNormalizados = (seleccionada.messages ?? []).map(m => ({
        ...m,
        metadata: normalizeMetadata(m.metadata),
      }));
      setMensajes(mensajesNormalizados);
      setHaCargadoHistorial(true);
    }
  };

  return {
    conversaciones,
    idConversacionActiva,
    mensajes,
    estaEscribiendo,
    haCargadoHistorial,
    crearNuevaConversacion,
    enviarMensaje,
    seleccionarConversacion,
    cargarConversaciones,
  };
};
