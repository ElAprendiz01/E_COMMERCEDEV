import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  Image,
  RefreshControl,
  Platform,
} from 'react-native';
import { useDashboardMetrics } from '../hooks/useDashboardMetrics';
import { SalesChartPointDto } from '../../Domain/entities/DashboardMetricsDto';
import { formatCurrency } from './constants';

interface DashboardScreenProps {
  onLogout: () => void;
}

export const DashboardScreen = ({ onLogout }: DashboardScreenProps) => {
  const { isLoading, isError, errorMessage, data, refresh } = useDashboardMetrics();
  const [selectedChartPoint, setSelectedChartPoint] = useState<SalesChartPointDto | null>(null);

  // Handle pull-to-refresh state
  const [refreshing, setRefreshing] = useState(false);
  const handleRefresh = async () => {
    setRefreshing(true);
    await refresh();
    setRefreshing(false);
    setSelectedChartPoint(null);
  };

  // Loading View
  if (isLoading && !refreshing) {
    return (
      <View style={styles.centerContainer}>
        <ActivityIndicator size="large" color="#4F46E5" />
        <Text style={styles.loadingText}>Cargando métricas del servidor...</Text>
      </View>
    );
  }

  // Error View
  if (isError || !data) {
    return (
      <View style={styles.centerContainer}>
        <Text style={styles.errorEmoji}>⚠️</Text>
        <Text style={styles.errorTitle}>Error de Conexión</Text>
        <Text style={styles.errorText}>
          {errorMessage || 'No se pudo conectar con la API de C# en Clean Architecture.'}
        </Text>
        <TouchableOpacity style={styles.retryBtn} onPress={refresh}>
          <Text style={styles.retryBtnText}>Reintentar Conexión</Text>
        </TouchableOpacity>
      </View>
    );
  }

  // Find max value in chart data to scale the bar chart heights
  const chartData = data.salesChartData;
  const maxSalesAmount = Math.max(...chartData.map((d) => d.amount), 1000);

  // If no point is selected, default to the last one (e.g. today's metrics)
  const activeDetailPoint = selectedChartPoint || chartData[chartData.length - 1];

  return (
    <ScrollView
      style={styles.container}
      contentContainerStyle={styles.scrollPadding}
      showsVerticalScrollIndicator={false}
      refreshControl={
        <RefreshControl refreshing={refreshing} onRefresh={handleRefresh} colors={["#4F46E5"]} />
      }
    >
      {/* Metrics Header */}
      <View style={styles.header}>
        <View>
          <Text style={styles.subtitleText}>PANEL DE CONTROL</Text>
          <Text style={styles.titleText}>Resumen Ejecutivo</Text>
        </View>
        <View style={styles.liveIndicatorContainer}>
          <View style={styles.liveIndicatorDot} />
          <Text style={styles.liveIndicatorText}>En vivo</Text>
        </View>
      </View>

      {/* KPI Cards Row */}
      <View style={styles.kpisContainer}>
        {/* Sales KPI */}
        <View style={styles.kpiCard}>
          <View style={styles.kpiHeader}>
            <Text style={styles.kpiEmoji}>💰</Text>
            <View style={[
              styles.growthBadge, 
              data.salesGrowthPercentage >= 0 ? styles.growthBadgePos : styles.growthBadgeNeg
            ]}>
              <Text style={[
                styles.growthText, 
                data.salesGrowthPercentage >= 0 ? styles.growthTextPos : styles.growthTextNeg
              ]}>
                {data.salesGrowthPercentage >= 0 ? '+' : ''}{data.salesGrowthPercentage}%
              </Text>
            </View>
          </View>
          <Text style={styles.kpiValue}>{formatCurrency(data.todaySales)}</Text>
          <Text style={styles.kpiLabel}>Ventas de Hoy</Text>
        </View>

        {/* Active Orders KPI */}
        <View style={styles.kpiCard}>
          <View style={styles.kpiHeader}>
            <Text style={styles.kpiEmoji}>🛒</Text>
            <View style={[
              styles.growthBadge, 
              data.ordersGrowthPercentage >= 0 ? styles.growthBadgePos : styles.growthBadgeNeg
            ]}>
              <Text style={[
                styles.growthText, 
                data.ordersGrowthPercentage >= 0 ? styles.growthTextPos : styles.growthTextNeg
              ]}>
                {data.ordersGrowthPercentage >= 0 ? '+' : ''}{data.ordersGrowthPercentage}%
              </Text>
            </View>
          </View>
          <Text style={styles.kpiValue}>{data.activeOrdersCount}</Text>
          <Text style={styles.kpiLabel}>Pedidos Activos</Text>
        </View>
      </View>

      {/* SALES CHART SECTION */}
      <View style={styles.sectionContainer}>
        <Text style={styles.sectionTitle}>Tendencia de Ventas (Semanal)</Text>
        <Text style={styles.sectionSubtitle}>Toca una barra para ver detalles del día</Text>

        <View style={styles.chartWrapper}>
          {/* Custom Y-Axis Labels */}
          <View style={styles.yAxisLabels}>
            <Text style={styles.yAxisText}>{formatCurrency(maxSalesAmount)}</Text>
            <Text style={styles.yAxisText}>{formatCurrency(maxSalesAmount * 0.67)}</Text>
            <Text style={styles.yAxisText}>{formatCurrency(maxSalesAmount * 0.33)}</Text>
            <Text style={styles.yAxisText}>C$0</Text>
          </View>

          {/* Bar Chart Columns */}
          <View style={styles.chartArea}>
            {/* Horizontal Grid lines */}
            <View style={styles.gridLinesContainer}>
              <View style={styles.gridLine} />
              <View style={styles.gridLine} />
              <View style={styles.gridLine} />
              <View style={styles.gridLine} />
            </View>

            {/* Bars */}
            <View style={styles.barsContainer}>
              {chartData.map((item, index) => {
                const heightPercentage = `${(item.amount / maxSalesAmount) * 100}%`;
                const isSelected = activeDetailPoint.label === item.label;

                return (
                  <TouchableOpacity
                    key={index}
                    activeOpacity={0.8}
                    style={styles.barColumn}
                    onPress={() => setSelectedChartPoint(item)}
                  >
                    <View style={styles.barTrack}>
                      <View
                        style={[
                          styles.barFill,
                          { height: heightPercentage as any },
                          isSelected && styles.barFillActive,
                        ]}
                      />
                    </View>
                    <Text style={[styles.barLabel, isSelected && styles.barLabelActive]}>
                      {item.label}
                    </Text>
                  </TouchableOpacity>
                );
              })}
            </View>
          </View>
        </View>

        {/* Selected Chart Point Details */}
        {activeDetailPoint && (
          <View style={styles.chartDetailsCard}>
            <Text style={styles.detailsDayText}>Detalles del Día: {activeDetailPoint.label}</Text>
            <View style={styles.detailsRow}>
              <View style={styles.detailsCol}>
                <Text style={styles.detailsLabel}>Ventas</Text>
                <Text style={styles.detailsValue}>{formatCurrency(activeDetailPoint.amount)}</Text>
              </View>
              <View style={[styles.detailsCol, styles.detailsColBorder]}>
                <Text style={styles.detailsLabel}>Pedidos</Text>
                <Text style={styles.detailsValue}>{activeDetailPoint.orderCount} ordenes</Text>
              </View>
            </View>
          </View>
        )}
      </View>

      {/* LOW STOCK ALERTS SECTION */}
      <View style={styles.sectionContainer}>
        <View style={styles.sectionHeaderRow}>
          <Text style={styles.sectionTitle}>Alertas de Inventario</Text>
          <View style={styles.warningCountBadge}>
            <Text style={styles.warningCountText}>{data.lowStockCount} alertas</Text>
          </View>
        </View>

        <View style={styles.alertsList}>
          {data.lowStockAlerts.map((alert) => {
            const stockRatio = alert.currentStock / alert.minRequiredStock;
            const isOutofStock = alert.currentStock === 0;

            // Determine status color
            const statusColor = isOutofStock ? '#EF4444' : '#F59E0B'; // red vs amber
            const progressBg = isOutofStock ? '#FEF2F2' : '#FFFBEB';

            return (
              <View key={alert.productId} style={styles.alertCard}>
                <Image
                  source={{ uri: alert.imageUrl || 'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=300&auto=format&fit=crop' }}
                  style={styles.alertImage}
                />
                
                <View style={styles.alertContent}>
                  <View style={styles.alertHeaderLine}>
                    <Text style={styles.alertProductName} numberOfLines={1}>
                      {alert.productName}
                    </Text>
                    <View style={[
                      styles.stockStatusBadge, 
                      { backgroundColor: isOutofStock ? '#FEE2E2' : '#FEF3C7' }
                    ]}>
                      <Text style={[
                        styles.stockStatusText, 
                        { color: statusColor }
                      ]}>
                        {isOutofStock ? 'AGOTADO' : `Quedan ${alert.currentStock}`}
                      </Text>
                    </View>
                  </View>

                  <View style={styles.alertDetailsRow}>
                    <Text style={styles.alertBrandText}>{alert.brandName || 'Generico'}</Text>
                    <Text style={styles.alertSkuText}>SKU: {alert.sku || `PROD-${alert.productId}`}</Text>
                  </View>

                  {/* Stock Level Progress Bar */}
                  <View style={styles.progressContainer}>
                    <View style={styles.progressBarBg}>
                      <View
                        style={[
                          styles.progressBarFill,
                          {
                            width: `${Math.min(stockRatio * 100, 100)}%`,
                            backgroundColor: statusColor,
                          },
                        ]}
                      />
                    </View>
                    <Text style={styles.stockFractionText}>
                      Stock: <Text style={{ fontWeight: '700', color: statusColor }}>{alert.currentStock}</Text> / {alert.minRequiredStock} (Min)
                    </Text>
                  </View>
                </View>
              </View>
            );
          })}
        </View>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8FAFC',
  },
  scrollPadding: {
    padding: 20,
    paddingBottom: 40,
  },
  centerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 30,
    backgroundColor: '#F8FAFC',
  },
  loadingText: {
    marginTop: 14,
    fontSize: 14,
    color: '#64748B',
    fontWeight: '600',
  },
  errorEmoji: {
    fontSize: 48,
    marginBottom: 12,
  },
  errorTitle: {
    fontSize: 18,
    fontWeight: '800',
    color: '#0F172A',
    marginBottom: 6,
  },
  errorText: {
    fontSize: 14,
    color: '#64748B',
    textAlign: 'center',
    lineHeight: 20,
    marginBottom: 24,
  },
  retryBtn: {
    backgroundColor: '#4F46E5',
    paddingHorizontal: 20,
    paddingVertical: 12,
    borderRadius: 12,
    shadowColor: '#4F46E5',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 3,
  },
  retryBtnText: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: '700',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24,
  },
  subtitleText: {
    fontSize: 11,
    fontWeight: '800',
    color: '#4F46E5',
    letterSpacing: 1.2,
    textTransform: 'uppercase',
  },
  titleText: {
    fontSize: 22,
    fontWeight: '900',
    color: '#0F172A',
    marginTop: 2,
  },
  liveIndicatorContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ECFDF5',
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: '#A7F3D0',
  },
  liveIndicatorDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: '#10B981',
    marginRight: 6,
  },
  liveIndicatorText: {
    color: '#065F46',
    fontSize: 11,
    fontWeight: '700',
  },
  kpisContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 24,
  },
  kpiCard: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    borderRadius: 20,
    padding: 16,
    marginHorizontal: 5,
    borderWidth: 1,
    borderColor: '#E2E8F0',
    shadowColor: '#0F172A',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.03,
    shadowRadius: 8,
    elevation: 2,
  },
  kpiHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  kpiEmoji: {
    fontSize: 22,
  },
  growthBadge: {
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 6,
  },
  growthBadgePos: {
    backgroundColor: '#ECFDF5',
  },
  growthBadgeNeg: {
    backgroundColor: '#FEF2F2',
  },
  growthText: {
    fontSize: 11,
    fontWeight: '700',
  },
  growthTextPos: {
    color: '#10B981',
  },
  growthTextNeg: {
    color: '#EF4444',
  },
  kpiValue: {
    fontSize: 18,
    fontWeight: '900',
    color: '#0F172A',
  },
  kpiLabel: {
    fontSize: 12,
    color: '#64748B',
    fontWeight: '600',
    marginTop: 4,
  },
  sectionContainer: {
    backgroundColor: '#FFFFFF',
    borderRadius: 24,
    padding: 20,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#E2E8F0',
    shadowColor: '#0F172A',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.03,
    shadowRadius: 8,
    elevation: 2,
  },
  sectionHeaderRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 16,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '800',
    color: '#0F172A',
  },
  sectionSubtitle: {
    fontSize: 12,
    color: '#94A3B8',
    fontWeight: '500',
    marginTop: 2,
    marginBottom: 16,
  },
  warningCountBadge: {
    backgroundColor: '#FFFBEB',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#FDE68A',
  },
  warningCountText: {
    fontSize: 11,
    fontWeight: '700',
    color: '#B45309',
  },
  chartWrapper: {
    flexDirection: 'row',
    height: 180,
    alignItems: 'flex-end',
    marginBottom: 16,
  },
  yAxisLabels: {
    height: 150,
    justifyContent: 'space-between',
    paddingRight: 10,
    width: 65,
    marginBottom: 20, // aligns with the labels row at the bottom
  },
  yAxisText: {
    fontSize: 9,
    color: '#94A3B8',
    fontWeight: '600',
    textAlign: 'right',
  },
  chartArea: {
    flex: 1,
    height: 170,
    position: 'relative',
    justifyContent: 'flex-end',
  },
  gridLinesContainer: {
    position: 'absolute',
    left: 0,
    right: 0,
    top: 0,
    height: 150,
    justifyContent: 'space-between',
    zIndex: 1,
  },
  gridLine: {
    height: 1,
    backgroundColor: '#F1F5F9',
  },
  barsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-end',
    height: 150,
    zIndex: 2,
    paddingHorizontal: 4,
  },
  barColumn: {
    alignItems: 'center',
    flex: 1,
    height: 170, // includes bar + space + label
    justifyContent: 'flex-end',
  },
  barTrack: {
    height: 140,
    width: 14,
    backgroundColor: '#F8FAFC',
    borderRadius: 7,
    justifyContent: 'flex-end',
    overflow: 'hidden',
  },
  barFill: {
    width: '100%',
    backgroundColor: '#C7D2FE', // light indigo
    borderRadius: 7,
  },
  barFillActive: {
    backgroundColor: '#4F46E5', // deep active indigo
  },
  barLabel: {
    fontSize: 10,
    color: '#94A3B8',
    fontWeight: '700',
    marginTop: 8,
  },
  barLabelActive: {
    color: '#4F46E5',
    fontWeight: '800',
  },
  chartDetailsCard: {
    backgroundColor: '#F8FAFC',
    borderRadius: 16,
    padding: 12,
    borderWidth: 1,
    borderColor: '#F1F5F9',
  },
  detailsDayText: {
    fontSize: 12,
    fontWeight: '700',
    color: '#475569',
    marginBottom: 8,
  },
  detailsRow: {
    flexDirection: 'row',
  },
  detailsCol: {
    flex: 1,
  },
  detailsColBorder: {
    borderLeftWidth: 1,
    borderColor: '#E2E8F0',
    paddingLeft: 12,
  },
  detailsLabel: {
    fontSize: 10,
    color: '#94A3B8',
    fontWeight: '600',
    textTransform: 'uppercase',
  },
  detailsValue: {
    fontSize: 14,
    fontWeight: '800',
    color: '#0F172A',
    marginTop: 2,
  },
  alertsList: {
    marginTop: 4,
  },
  alertCard: {
    flexDirection: 'row',
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#F1F5F9',
    alignItems: 'center',
  },
  alertImage: {
    width: 48,
    height: 48,
    borderRadius: 10,
    backgroundColor: '#F1F5F9',
    borderWidth: 1,
    borderColor: '#E2E8F0',
  },
  alertContent: {
    flex: 1,
    marginLeft: 12,
  },
  alertHeaderLine: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  alertProductName: {
    fontSize: 13,
    fontWeight: '700',
    color: '#0F172A',
    flex: 1,
    marginRight: 8,
  },
  stockStatusBadge: {
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
  stockStatusText: {
    fontSize: 9,
    fontWeight: '800',
  },
  alertDetailsRow: {
    flexDirection: 'row',
    marginTop: 2,
    marginBottom: 6,
  },
  alertBrandText: {
    fontSize: 10,
    color: '#64748B',
    fontWeight: '600',
    marginRight: 8,
  },
  alertSkuText: {
    fontSize: 10,
    color: '#94A3B8',
    fontWeight: '500',
  },
  progressContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  progressBarBg: {
    flex: 1,
    height: 6,
    backgroundColor: '#F1F5F9',
    borderRadius: 3,
    marginRight: 10,
    overflow: 'hidden',
  },
  progressBarFill: {
    height: '100%',
    borderRadius: 3,
  },
  stockFractionText: {
    fontSize: 10,
    color: '#64748B',
    fontWeight: '500',
  },
});
