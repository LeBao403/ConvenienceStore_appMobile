import 'package:flutter/material.dart';

class OrderStatusTimeline extends StatelessWidget {
  final List<String> steps;
  final String? currentStatus;

  const OrderStatusTimeline({super.key, required this.steps, required this.currentStatus});

  int getCurrentStepIndex() {
    return steps.indexWhere((step) => step == currentStatus);
  }

  @override
  Widget build(BuildContext context) {
    final isCancelled = currentStatus == 'Đã hủy' || currentStatus == 'Đã huỷ';
    final currentIndex = getCurrentStepIndex();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;

          final isFirst = index == 0;

          final isActive = !isCancelled && index <= currentIndex;
          final isCompleted = !isCancelled && index < currentIndex;

          return Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: isCancelled && isFirst
                        ? Colors.red
                        : (isActive ? Colors.lightBlue : Colors.grey),
                    child: isCancelled && isFirst
                        ? const Icon(Icons.cancel, color: Colors.white, size: 16)
                        : const Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 60,
                    child: Text(
                      isCancelled && isFirst ? 'Đã hủy' : title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: isCancelled && isFirst
                            ? Colors.red
                            : (isActive ? Colors.black : Colors.grey),
                        fontWeight: isCancelled && isFirst
                            ? FontWeight.bold
                            : (isActive ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
              if (index != steps.length - 1)
                Container(
                  width: 30,
                  height: 1.5,
                  color: isCancelled
                      ? Colors.grey
                      : (isCompleted ? Colors.lightBlue : Colors.grey),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
