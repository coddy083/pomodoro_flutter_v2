import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List timeList = [1, 300, 600, 900, 1200, 1500, 1800, 2100, 2400];
  bool isPlay = false;
  bool isRest = false;
  int clickedTime = 1500;
  final int restTime = 3;

  int time = 1;
  Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  Timer restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  int currentRound = 0;
  int finalRound = 4;
  int currentGoal = 0;
  int finalGoal = 12;
  int rest = 3;

  void onTick() {
    if (time < 1) {
      setState(() {
        onRest();
        isPlay = false;
        time = clickedTime;
        if (currentRound < finalRound) {
          currentRound++;
        } else {
          currentRound = 0;
          currentGoal++;
        }
        timer.cancel();
      });
    } else {
      setState(() {
        time--;
      });
    }
  }

  onRestTick() {
    if (rest < 1) {
      setState(() {
        isRest = false;
        rest = restTime;
        // onPlay();
        restTimer.cancel();
      });
    } else {
      setState(() {
        rest--;
      });
    }
  }

  void onPlay() {
    if (isRest) return;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      onTick();
    });
    setState(() {
      isPlay = true;
    });
  }

  void onPause() {
    timer.cancel();
    setState(() {
      isPlay = false;
    });
  }

  void onReset() {
    timer.cancel();
    restTimer.cancel();
    setState(() {
      isPlay = false;
      isRest = false;
      time = clickedTime;
      rest = restTime;
      currentRound = 0;
      currentGoal = 0;
    });
  }

  void onRest() {
    restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      onRestTick();
    });
    setState(() {
      isRest = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String timeFormatToMinute(int seconds) {
    final int minutes =
        seconds ~/ 60; // Divide seconds by 60 to get the minutes
    return '$minutes';
  }

  int timeFormatToSecond(int seconds) {
    //초를 분과 초로 변환
    final sec = seconds % 60;
    return sec;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Colors.deepOrangeAccent.shade400;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: accentColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          elevation: 0,
          title: const Text('POMOTIMER'),
          centerTitle: false,
          titleTextStyle: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      width: 140,
                      height: 190,
                      child: Text(
                        timeFormatToMinute(time),
                        style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.w700,
                            color: accentColor),
                      ),
                    ),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: 70,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      width: 140,
                      height: 190,
                      child: Text(
                        timeFormatToSecond(time) >= 10
                            ? timeFormatToSecond(time).toString()
                            : '0${timeFormatToSecond(time)}',
                        style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.w700,
                            color: accentColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Text(
                    isRest ? 'REST' : 'WORK',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    isRest ? '$rest' : 'GOGOGO!!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var timeButton in timeList)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              clickedTime = timeButton;
                              time = clickedTime;
                            });
                          },
                          child: MinuteSelect(
                            accentColor: accentColor,
                            timeButton: timeButton,
                            clickedTime: clickedTime,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 180,
                  child: IconButton(
                    onPressed: isPlay ? onPause : onPlay,
                    icon: Icon(
                      isPlay
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_filled_rounded,
                      size: 170,
                    ),
                    color: Colors.black54,
                    // style: ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.all(Colors.white),
                    //   shape: MaterialStateProperty.all(
                    //       const CircleBorder(side: BorderSide.none)),
                    // ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(100, 50),
                ),
                onPressed: onReset,
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$currentRound/$finalRound',
                            style: TextStyle(
                              color: Colors.white.withOpacity(
                                0.7,
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'ROUND',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '$currentGoal/$finalGoal',
                            style: TextStyle(
                              color: Colors.white.withOpacity(
                                0.7,
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'GOAL',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class MinuteSelect extends StatelessWidget {
  const MinuteSelect({
    super.key,
    required this.accentColor,
    required this.timeButton,
    required this.clickedTime,
  });

  final Color accentColor;
  final int timeButton;
  final int clickedTime;

  @override
  Widget build(BuildContext context) {
    print(timeButton);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: timeButton == clickedTime ? Colors.white : Colors.transparent,
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 70,
      height: 40,
      child: Text(
        (timeButton / 60).toStringAsFixed(0).replaceFirst('.0', ''),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: timeButton == clickedTime
              ? accentColor
              : Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}
