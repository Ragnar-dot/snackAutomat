import 'package:flutter/material.dart';

class OutputSlotWidget extends StatelessWidget {
  final List<String> outputItems;

  const OutputSlotWidget({super.key, required this.outputItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey[300],
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: outputItems.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            child: Chip(
              label: Text(outputItems[index]),
            ),
          );
        },
      ),
    );
  }
}