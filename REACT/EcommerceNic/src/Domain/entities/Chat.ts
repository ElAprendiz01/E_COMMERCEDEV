export interface Message {
  id: number;
  conversationId: string;
  role: 'user' | 'assistant' | 'system';
  isBot: boolean;
  content: string;
  timestamp: string;
  user_id: string;   // 👈 nuevo campo obligatorio
  appliedRuleId?: number;
  intent?: string;
  metadata?: { productos?: any[] } | null; // 👈 corregido

  tipo?: string;
  productos?: any[];
}

export interface Conversation {
  id: string;
  userId?: string;
  title?: string;
  language?: string;
  lastIntent?: string;
  cartId?: string;
  orderId?: string;
  startDate: string; // ISO string mapping to FechaInicio
  endDate?: string;  // ISO string mapping to FechaFin
  isActive: boolean;
  updatedAt?: string;
  messages?: Message[];
}
