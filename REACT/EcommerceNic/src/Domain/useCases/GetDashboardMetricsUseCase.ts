import { DashboardRepository } from '../repositories/DashboardRepository';
import { DashboardMetricsDto } from '../entities/DashboardMetricsDto';

export class GetDashboardMetricsUseCase {
  private repository: DashboardRepository;

  constructor(repository: DashboardRepository) {
    this.repository = repository;
  }

  /**
   * Executes the use case to fetch dashboard metrics.
   * @returns A promise that resolves to DashboardMetricsDto
   */
  async execute(): Promise<DashboardMetricsDto> {
    return this.repository.getMetrics();
  }
}
