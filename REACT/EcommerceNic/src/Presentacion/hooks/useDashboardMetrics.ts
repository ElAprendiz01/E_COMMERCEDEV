import { useState, useEffect, useCallback } from 'react';
import { DashboardMetricsDto } from '../../Domain/entities/DashboardMetricsDto';
import { getDashboardMetricsUseCase } from '../../di/DI';

/**
 * Custom Hook to retrieve dashboard metrics.
 * Exposes loading, error states, and a refresh function for pull-to-refresh action.
 * Separates presentation components from data execution details.
 */
export const useDashboardMetrics = () => {
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [isError, setIsError] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [data, setData] = useState<DashboardMetricsDto | null>(null);

  const fetchMetrics = useCallback(async () => {
    setIsLoading(true);
    setIsError(false);
    setErrorMessage(null);
    try {
      const result = await getDashboardMetricsUseCase.execute();
      setData(result);
    } catch (error: any) {
      setIsError(true);
      setErrorMessage(error.message || 'No se pudieron recuperar las métricas del servidor.');
      setData(null);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchMetrics();
  }, [fetchMetrics]);

  return {
    isLoading,
    isError,
    errorMessage,
    data,
    refresh: fetchMetrics,
  };
};
