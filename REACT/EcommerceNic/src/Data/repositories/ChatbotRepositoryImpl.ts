import { ChatbotRepository } from "../../Domain/repositories/ChatbotRepository";
import { chatbotRemoteDataSource } from "../dataSources/ChatbotRemoteDataSource";
import { ChatbotConversationResponse, ChatMessagePayload, ChatbotResponse } from "../dataSources/ChatbotRemoteDataSource";


export class ChatbotRepositoryImpl implements ChatbotRepository {


    async sendMessage(
        message:string,
        conversationId?: string,
        userId?: string,
    ):Promise<ChatbotResponse>{

        return chatbotRemoteDataSource.sendMessage(message, conversationId, userId);

    }

    async getConversations(userId?: string): Promise<ChatbotConversationResponse[]> {
        return chatbotRemoteDataSource.getConversations(userId);
    }

    async createConversation(userId: string, title?: string): Promise<ChatbotConversationResponse> {
        return chatbotRemoteDataSource.createConversation(userId, title);
    }

    async saveMessage(conversationId: string, payload: ChatMessagePayload): Promise<any> {
        return chatbotRemoteDataSource.saveMessage(conversationId, payload);
    }

    async getConversation(conversationId: string): Promise<ChatbotConversationResponse | null> {
        return chatbotRemoteDataSource.getConversation(conversationId);
    }

}