import { ChatbotConversationResponse, ChatMessagePayload } from "../../Data/dataSources/ChatbotRemoteDataSource";
import { ChatbotRepository } from "../repositories/ChatbotRepository";


export class SendChatMessageUseCase {


    constructor(
        private repository:ChatbotRepository
    ){}


    async execute(
        message:string,
        conversationId?: string,
        userId?: string,
    ){

        return await this.repository.sendMessage(message, conversationId, userId);

    }

    async getConversations(userId?: string): Promise<ChatbotConversationResponse[]> {
        return this.repository.getConversations(userId);
    }

    async createConversation(userId: string, title?: string): Promise<ChatbotConversationResponse> {
        return this.repository.createConversation(userId, title);
    }

    async saveMessage(conversationId: string, payload: ChatMessagePayload): Promise<any> {
        return this.repository.saveMessage(conversationId, payload);
    }

    async getConversation(conversationId: string): Promise<ChatbotConversationResponse | null> {
        return this.repository.getConversation(conversationId);
    }

}