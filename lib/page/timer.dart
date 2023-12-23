import 'dart:async';

import 'package:eye_timer/service/notify_service.dart';
import 'package:eye_timer/widgets/button_widget.dart';
import 'package:eye_timer/widgets/time_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum TimeUnits { hours, minutes, seconds }

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Duration duration = const Duration(minutes: 1);
  Duration originalDuration = const Duration(minutes: 1);
  Timer? timer;
  bool showHoursButtons = false;
  bool showMinutesButtons = false;
  bool showSecondsButtons = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    setState(() {
      duration = originalDuration;
    });
  }

  void addTime() {
    const addSeconds = -1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        NotificationService().showNotification(
            title: 'Eye timer', body: 'It\'s time to make eye exercise!');
        timer?.cancel();
        reset();
        startTimer();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    setState(() {
      timer?.cancel();
    });
  }

  void updateTimer(int change, TimeUnits unit) {
    setState(() {
      switch (unit) {
        case TimeUnits.hours:
          duration = duration + Duration(hours: change);
          break;
        case TimeUnits.minutes:
          duration = duration + Duration(minutes: change);
          break;
        case TimeUnits.seconds:
          duration = duration + Duration(seconds: change);
          break;
      }

      originalDuration = duration;

      if (duration.inSeconds < 0) {
        stopTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showHoursButtons = false;
          showMinutesButtons = false;
          showSecondsButtons = false;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade500,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTime(),
            const SizedBox(height: 70),
            buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildTime() {
    final isRunning = timer == null ? false : timer!.isActive;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimeCard(
            time: hours,
            header: 'HOURS',
            showButtons: showHoursButtons,
            onTapCallback: () {
              if (isRunning) {
                return;
              }
              setState(() {
                showHoursButtons = !showHoursButtons;
                showMinutesButtons = false;
                showSecondsButtons = false;
              });
            },
            onTimeChange: (int change, unit) {
              updateTimer(change, TimeUnits.hours);
            }),
        const SizedBox(width: 10),
        TimeCard(
          time: minutes,
          header: 'MINUTES',
          showButtons: showMinutesButtons,
          onTapCallback: () {
            if (isRunning) {
              return;
            }
            setState(() {
              showMinutesButtons = !showMinutesButtons;
              showHoursButtons = false;
              showSecondsButtons = false;
            });
          },
          onTimeChange: (int change, unit) {
            updateTimer(change, TimeUnits.minutes);
          },
        ),
        const SizedBox(width: 10),
        TimeCard(
          time: seconds,
          header: 'SECONDS',
          showButtons: showSecondsButtons,
          onTapCallback: () {
            setState(() {
              if (isRunning) {
                return;
              }
              showSecondsButtons = !showSecondsButtons;
              showHoursButtons = false;
              showMinutesButtons = false;
            });
          },
          onTimeChange: (int change, unit) {
            updateTimer(change, TimeUnits.seconds);
          },
        ),
      ],
    );
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning
        ? ButtonWidget(
            text: 'Cancel',
            onClicked: () {
              timer?.cancel();
              setState(() => duration = originalDuration);
            },
            color: Colors.white,
            backgroundColor: Colors.black,
          )
        : ButtonWidget(
            text: 'Start Timer!',
            onClicked: () {
              setState(() {
                showMinutesButtons = false;
                showHoursButtons = false;
                showSecondsButtons = false;
              });
              if (duration.inSeconds == 0) {
                return;
              }
              startTimer();
            },
            color: Colors.black,
            backgroundColor: const Color.fromARGB(255, 237, 231, 246),
          );
  }
}
