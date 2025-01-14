import 'package:flutter/material.dart';

// enum TimeType { hour, minute }

class TimePickerWidget extends StatefulWidget {
  final String label;
  final String timeType;

  const TimePickerWidget(
      {super.key, required this.label, required this.timeType});

  @override
  TimePickerWidgetState createState() => TimePickerWidgetState();
}

class TimePickerWidgetState extends State<TimePickerWidget> {
  int selectedTime = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 20),
        ),
        // const SizedBox(height: 10),
        SizedBox(
          height: 150,
          width: 80,
          child: ListWheelScrollView(
            itemExtent: 50,
            diameterRatio: .8,
            // offAxisFraction: -.2,
            useMagnifier: true,
            magnification: 1.4,
            physics: const FixedExtentScrollPhysics(),
            children: _buildTimeItems(),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedTime = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
          selectedTime.toString(),
          style: const TextStyle(fontSize: 30),
        ),
      ],
    );
  }

  List<Widget> _buildTimeItems() {
    List<Widget> items = [];
    int itemCount = widget.timeType == "hour" ? 24 : 60;

    for (int i = 0; i < itemCount; i++) {
      items.add(
        Center(
          child: Text(
            i.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return items;
  }
}
