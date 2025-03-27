import 'package:flutter/material.dart';
import '../models/performance_data.dart';

class MuscleLoadAnalysis extends StatelessWidget {
  final List<PerformanceData> historicalData;

  const MuscleLoadAnalysis({super.key, required this.historicalData});

  @override
  Widget build(BuildContext context) {
    final muscleLoadData = historicalData
        .where((data) => data.metrics[PerformanceData.MUSCLE_LOAD] != null)
        .toList();

    if (muscleLoadData.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentLoad = muscleLoadData.last.metrics[PerformanceData.MUSCLE_LOAD]!;
    final maxLoad = muscleLoadData
        .map((data) => data.metrics[PerformanceData.MUSCLE_LOAD]!)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Text(
          'Muscle Load Analysis',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${currentLoad.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getLoadColor(currentLoad),
                    ),
                  ),
                  const Text('Current Load'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${maxLoad.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Peak Load'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: currentLoad / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getLoadColor(currentLoad),
          ),
          minHeight: 12,
        ),
        const SizedBox(height: 8),
        Text(
          _getLoadDescription(currentLoad),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Color _getLoadColor(double value) {
    if (value < 40) return Colors.green;
    if (value < 70) return Colors.orange;
    return Colors.red;
  }

  String _getLoadDescription(double value) {
    if (value < 30) return 'Light load - recovery likely not needed';
    if (value < 50) return 'Moderate load - consider light recovery';
    if (value < 70) return 'Heavy load - recovery recommended';
    return 'Very heavy load - recovery required';
  }
}