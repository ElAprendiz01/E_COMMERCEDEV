import { ChatbotConversationResponse, ChatMessagePayload, ChatbotResponse } from "../../Data/dataSources/ChatbotRemoteDataSource";

export interface ChatbotRepository {

    sendMessage(
        message:string,
        conversationId?: string,
        userId?: string,
    ): Promise<ChatbotResponse>;

    getConversations(userId?: string): Promise<ChatbotConversationResponse[]>;

    createConversation(userId: string, title?: string): Promise<ChatbotConversationResponse>;

    saveMessage(conversationId: string, payload: ChatMessagePayload): Promise<any>;

    getConversation(conversationId: string): Promise<ChatbotConversationResponse | null>;

}