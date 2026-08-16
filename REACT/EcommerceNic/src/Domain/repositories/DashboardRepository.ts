import { DashboardMetricsDto } from '../entities/DashboardMetricsDto';

export interface DashboardRepository {
  /**
   * Fetches the current dashboard metrics.
   * In the future, this will hit the C# ASP.NET Core Web API controller.
   */
  getMetrics(): Promise<DashboardMetricsDto>;
}
