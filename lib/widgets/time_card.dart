import 'package:flutter/material.dart';

enum TimeUnits { hours, minutes, seconds }

class TimeCard extends StatefulWidget {
  final String time;
  final String header;
  final bool showButtons;
  final VoidCallback onTapCallback;
  final Function(int, TimeUnits) onTimeChange;

  const TimeCard({
    super.key,
    required this.time,
    required this.header,
    required this.showButtons,
    required this.onTapCallback,
    required this.onTimeChange,
  });

  @override
  TimeCardState createState() => TimeCardState();
}

class TimeCardState extends State<TimeCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onTapCallback();
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 223, 213, 240),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 72,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(widget.header, style: const TextStyle(color: Colors.white),),
          const SizedBox(height: 10),
          if (widget.showButtons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    switch (widget.header) {
                      case 'HOURS':
                        widget.onTimeChange(1, TimeUnits.hours);
                        break;
                      case 'MINUTES':
                        widget.onTimeChange(1, TimeUnits.minutes);
                        break;
                      case 'SECONDS':
                        widget.onTimeChange(1, TimeUnits.seconds);
                        break;
                      default:
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (int.parse(widget.time) == 0) {
                      return;
                    }
                    switch (widget.header) {
                      case 'HOURS':
                        widget.onTimeChange(-1, TimeUnits.hours);
                        break;
                      case 'MINUTES':
                        widget.onTimeChange(-1, TimeUnits.minutes);
                        break;
                      case 'SECONDS':
                        widget.onTimeChange(-1, TimeUnits.seconds);
                        break;
                      default:
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
