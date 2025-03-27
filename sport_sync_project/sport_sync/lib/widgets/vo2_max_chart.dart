import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/performance_data.dart';

class VO2MaxChart extends StatelessWidget {
  final List<PerformanceData> historicalData;

  const VO2MaxChart({super.key, required this.historicalData});

  @override
  Widget build(BuildContext context) {
    final series = [
      charts.Series<PerformanceData, DateTime>(
        id: 'VO2Max',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (data, _) => data.timestamp,
        measureFn: (data, _) => data.metrics[PerformanceData.VO2_MAX],
        data: historicalData,
      )..setAttribute(charts.measureAxisIdKey, 'primary'),
    ];

    return charts.TimeSeriesChart(
      series,
      animate: true,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredMinTickCount: 5,
          desiredMaxTickCount: 10,
        ),
      ),
      domainAxis: const charts.DateTimeAxisSpec(
        tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
      ),
      behaviors: [
        charts.SeriesLegend(),
        charts.ChartTitle('VO2 Max Trend',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('Date',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('ml/kg/min',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
      ],
    );
  }
}