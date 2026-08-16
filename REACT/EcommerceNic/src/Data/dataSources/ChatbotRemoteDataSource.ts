import { API_CONFIG, safeFetch } from './apiConfig';

export interface ChatbotResponse {
  texto: string;
  regla_id: number;
  tipo?: string;
  productos?: any[];
  metadata?: { productos?: any[] } | null;
}

export interface ChatMessagePayload {
  role: string;
  content: string;
  timestamp: string;
  user_id: string;
  isBot?: boolean;
  tipo?: string;
  productos?: any[];
  metadata?: { productos?: any[] } | null;
}

export interface ChatbotConversationResponse {
  id?: string;
  conversation_id?: string;
  userId?: string;
  title?: string;
  startDate?: string;
  updatedAt?: string;
  isActive?: boolean;
  messages?: any[];
}

class ChatbotRemoteDataSource {
  async sendMessage(message: string, conversationId?: string, userId?: string): Promise<ChatbotResponse> {
    return await safeFetch<ChatbotResponse>(`${API_CONFIG.CHATBOT_URL}/api/chatbot/chat`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        mensaje: message,
        conversation_id: conversationId ?? null,
        user_id: userId ?? 'demo-user',
      }),
    });
  }

  async getConversations(userId?: string): Promise<ChatbotConversationResponse[]> {
    try {
      const url = userId
        ? `${API_CONFIG.CHATBOT_URL}/api/chatbot/users/${encodeURIComponent(userId)}/conversations`
        : `${API_CONFIG.CHATBOT_URL}/api/chatbot/conversations`;
      const data = await safeFetch<ChatbotConversationResponse[]>(url, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      });
      return Array.isArray(data) ? data : [];
    } catch (error) {
      console.log('Error al cargar conversaciones:', error);
      return [];
    }
  }

  async createConversation(userId: string, title = 'Nueva conversación'): Promise<ChatbotConversationResponse> {
    return await safeFetch<ChatbotConversationResponse>(`${API_CONFIG.CHATBOT_URL}/api/chatbot/conversations`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        userId,
        title,
      }),
    });
  }

  async saveMessage(conversationId: string, payload: ChatMessagePayload): Promise<any> {
    return await safeFetch<any>(`${API_CONFIG.CHATBOT_URL}/api/chatbot/conversations/${encodeURIComponent(conversationId)}/messages`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    });
  }

  async getConversation(conversationId: string): Promise<ChatbotConversationResponse | null> {
    try {
      return await safeFetch<ChatbotConversationResponse>(`${API_CONFIG.CHATBOT_URL}/api/chatbot/conversations/${encodeURIComponent(conversationId)}/history`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      });
    } catch (error) {
      console.log('Error fetching conversation:', error);
      return null;
    }
  }
}

export const chatbotRemoteDataSource = new ChatbotRemoteDataSource();
