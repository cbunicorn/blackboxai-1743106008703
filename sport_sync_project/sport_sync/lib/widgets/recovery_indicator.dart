import 'package:flutter/material.dart';
import '../models/performance_data.dart';

class RecoveryIndicator extends StatelessWidget {
  final double recoveryTime;
  final double recoveryNeed;

  const RecoveryIndicator({
    super.key,
    required this.recoveryTime,
    required this.recoveryNeed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Recovery Status',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${recoveryTime.toStringAsFixed(1)} hrs',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Recommended'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${recoveryNeed.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getRecoveryColor(recoveryNeed),
                    ),
                  ),
                  const Text('Your Need'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: recoveryNeed / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getRecoveryColor(recoveryNeed),
          ),
          minHeight: 12,
        ),
      ],
    );
  }

  Color _getRecoveryColor(double value) {
    if (value < 30) return Colors.green;
    if (value < 70) return Colors.orange;
    return Colors.red;
  }
}