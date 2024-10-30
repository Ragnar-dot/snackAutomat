import 'package:flutter/material.dart';

class OutputSlotWidget extends StatelessWidget {
  final List<String> outputItems;

  const OutputSlotWidget({super.key, required this.outputItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.grey[300],
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: outputItems.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(9.0),
            
            child: Chip(
              label: Text(outputItems[index]),
            ),
          );
        },
      ),
    );
  }
}