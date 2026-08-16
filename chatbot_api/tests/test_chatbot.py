from app.services.chatbot_service import procesar_mensaje

while True:

    mensaje = input("Tú: ")

    respuesta = procesar_mensaje(mensaje)

    print("Bot:", respuesta["respuesta"])