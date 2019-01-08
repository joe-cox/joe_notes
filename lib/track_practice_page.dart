import 'package:flutter/material.dart';
import 'dart:async';
import 'package:joe_notes/models/practice_session.dart';
import 'package:joe_notes/database_helper.dart';
import 'package:joe_notes/timer_service.dart';

class TrackPracticePage extends StatefulWidget {
  TrackPracticePage({Key key}) : super(key: key);

  TrackPracticePageState createState() => TrackPracticePageState();
}

class TrackPracticePageState extends State<TrackPracticePage> {
  final Stopwatch stopwatch = new Stopwatch();
  Timer timer;
  String minutesStr = '00';
  String secondsStr = '00';
  TimerService _timerService;
  String stopwatchState = "Start";
  final DateTime startTime = new DateTime.now();
  var db = new DatabaseHelper();

  final TextStyle timerTextStyle = new TextStyle(
      color: Colors.white, fontSize: 72, fontWeight: FontWeight.bold);

  final notesTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  @override
  void initState() {
    timer =
        new Timer.periodic(new Duration(milliseconds: 30), _updateTimeDisplay);

    var allPracticeSessions = db.getPracticeSessionCount();
    allPracticeSessions.then((int count) => debugPrint(count.toString()));
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    notesTextController.dispose();
    timer = null;
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    var timerService = TimerService.of(context);
    return Container(
      color: Colors.deepPurple,
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
            new Text('$minutesStr:$secondsStr', style: timerTextStyle),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  new RaisedButton(
                      child: Text(stopwatchState),
                      onPressed: _updateStopwatchState),
                  new RaisedButton(
                      child: Text('Reset'), onPressed: _resetStopwatch)
                ]),
            new Container(
                padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                child: new TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Practice Notes'),
                  controller: notesTextController,
                  maxLines: 4,
                )),
            new RaisedButton(
                child: Text("Complete Practice"),
                onPressed: () {
                  _completePractice(context);
                })
          ])));}

  void _updateStopwatchState() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      stopwatchState = "Start";
    } else {
      stopwatch.start();
      stopwatchState = "Stop";
    }
  }

  void _resetStopwatch() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      stopwatchState = "Start";
    }
    stopwatch.reset();
  }

  void _completePractice(BuildContext context) {
    if (stopwatch.isRunning) {
      stopwatch.stop();
    }
    var ps = new PracticeSession(
        startTime,
        (stopwatch.elapsedMilliseconds / 1000).truncate(),
        notesTextController.text);
    db.savePracticeSession(ps);
    Navigator.pop(context);
  }

  void _updateTimeDisplay(Timer timer) {
    setState(() {
      final int milliseconds = stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      minutesStr = (minutes % 60).toString().padLeft(2, '0');
      secondsStr = (seconds % 60).toString().padLeft(2, '0');
    });
  }
}
