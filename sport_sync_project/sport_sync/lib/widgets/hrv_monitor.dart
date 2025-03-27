import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../models/performance_data.dart';

class HRVMonitor extends StatelessWidget {
  final List<PerformanceData> historicalData;
  final double? currentHRV;

  const HRVMonitor({
    super.key,
    required this.historicalData,
    this.currentHRV,
  });

  @override
  Widget build(BuildContext context) {
    final hrvData = historicalData
        .where((data) => data.metrics[PerformanceData.HRV] != null)
        .toList();

    if (hrvData.isEmpty && currentHRV == null) {
      return const SizedBox.shrink();
    }

    final latestHRV = currentHRV ?? hrvData.last.metrics[PerformanceData.HRV]!;
    final avgHRV = hrvData.isEmpty 
        ? latestHRV 
        : hrvData.map((d) => d.metrics[PerformanceData.HRV]!).reduce((a,b) => a+b) / hrvData.length;

    return Column(
      children: [
        Text(
          'HRV (Heart Rate Variability)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 200,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: 50,
                    color: Colors.red[300],
                    label: 'High Stress',
                  ),
                  GaugeRange(
                    startValue: 50,
                    endValue: 100,
                    color: Colors.orange[300],
                    label: 'Moderate Stress',
                  ),
                  GaugeRange(
                    startValue: 100,
                    endValue: 150,
                    color: Colors.lightGreen[300],
                    label: 'Balanced',
                  ),
                  GaugeRange(
                    startValue: 150,
                    endValue: 200,
                    color: Colors.green[300],
                    label: 'Optimal Recovery',
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: latestHRV,
                    enableAnimation: true,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          latestHRV.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ms',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    angle: 90,
                    positionFactor: 0.5,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Current',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  latestHRV.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '7-day Avg',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  avgHRV.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _getHRVInterpretation(latestHRV),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getHRVInterpretation(double hrv) {
    if (hrv < 50) return 'High stress - consider rest and recovery';
    if (hrv < 100) return 'Elevated stress - light activity recommended';
    if (hrv < 150) return 'Balanced state - good for training';
    return 'Optimal recovery - ready for intense training';
  }
}