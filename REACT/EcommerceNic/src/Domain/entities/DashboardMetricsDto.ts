/**
 * DTO (Data Transfer Object) representing low stock warning items.
 * Maps directly to low-stock product entities from a C# Backend.
 */
export interface LowStockAlertDto {
  productId: number;
  productName: string;
  sku?: string;
  currentStock: number;
  minRequiredStock: number;
  categoryName: string;
  brandName?: string;
  imageUrl?: string;
}

/**
 * DTO representing a single data point in the sales history chart.
 */
export interface SalesChartPointDto {
  label: string; // e.g. "Lun", "Mar", "Mié" or "Semana 1", "Semana 2"
  amount: number; // Decimal sales amount
  orderCount: number; // Number of orders in this interval
}

/**
 * Main DTO representing the response from the Dashboard Metrics API.
 * Structured to integrate cleanly with a C# controller endpoint.
 */
export interface DashboardMetricsDto {
  todaySales: number;
  salesGrowthPercentage: number; // e.g., 14.5 (represents +14.5%)
  activeOrdersCount: number;
  ordersGrowthPercentage: number; // e.g., -5.2 (represents -5.2%)
  lowStockCount: number;
  salesChartData: SalesChartPointDto[];
  lowStockAlerts: LowStockAlertDto[];
}
