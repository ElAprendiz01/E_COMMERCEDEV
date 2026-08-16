import { DashboardRepository } from '../../Domain/repositories/DashboardRepository';
import { DashboardMetricsDto } from '../../Domain/entities/DashboardMetricsDto';

export class DashboardRepositoryImpl implements DashboardRepository {
  /**
   * Simulates fetching data from a C# Web API with a network delay.
   */
  async getMetrics(): Promise<DashboardMetricsDto> {
    return new Promise((resolve, reject) => {
      // Simulate network latency (e.g. 1.5 seconds)
      setTimeout(() => {
        // Toggle this to test error handling if needed
        const simulateError = false;
        
        if (simulateError) {
          reject(new Error("Error al conectar con el servidor de la API en C#."));
          return;
        }

        const mockData: DashboardMetricsDto = {
          todaySales: 24580.50,
          salesGrowthPercentage: 15.8,
          activeOrdersCount: 18,
          ordersGrowthPercentage: 8.3,
          lowStockCount: 4,
          salesChartData: [
            { label: 'Lun', amount: 12300.00, orderCount: 8 },
            { label: 'Mar', amount: 15400.00, orderCount: 10 },
            { label: 'Mié', amount: 18900.00, orderCount: 12 },
            { label: 'Jue', amount: 14200.00, orderCount: 9 },
            { label: 'Vie', amount: 22100.00, orderCount: 15 },
            { label: 'Sáb', amount: 28500.00, orderCount: 20 },
            { label: 'Dom', amount: 24580.50, orderCount: 18 }
          ],
          lowStockAlerts: [
            {
              productId: 101,
              productName: 'Memoria RAM Corsair Vengeance RGB Pro 32GB',
              sku: 'RAM-COR-032G',
              currentStock: 2,
              minRequiredStock: 5,
              categoryName: 'Hardware',
              brandName: 'Corsair',
              imageUrl: 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=300&auto=format&fit=crop'
            },
            {
              productId: 102,
              productName: 'Procesador Intel Core i9-14900K',
              sku: 'CPU-INT-i914',
              currentStock: 1,
              minRequiredStock: 3,
              categoryName: 'Hardware',
              brandName: 'Intel',
              imageUrl: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=300&auto=format&fit=crop'
            },
            {
              productId: 103,
              productName: 'SSD Kingston NV2 1TB NVMe PCIe 4.0',
              sku: 'SSD-KIN-001T',
              currentStock: 0,
              minRequiredStock: 8,
              categoryName: 'Almacenamiento',
              brandName: 'Kingston',
              imageUrl: 'https://images.unsplash.com/photo-1597852074816-d933c4d2b988?q=80&w=300&auto=format&fit=crop'
            },
            {
              productId: 104,
              productName: 'Mouse Gaming Logitech G502 Hero Light-speed',
              sku: 'MOU-LOG-G502',
              currentStock: 3,
              minRequiredStock: 10,
              categoryName: 'Accesorios',
              brandName: 'Logitech',
              imageUrl: 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=300&auto=format&fit=crop'
            }
          ]
        };

        resolve(mockData);
      }, 1500);
    });
  }
}
