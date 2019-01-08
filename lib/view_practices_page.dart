import 'package:flutter/material.dart';
import 'package:joe_notes/models/practice_session.dart';
import 'package:joe_notes/database_helper.dart';
import 'package:intl/intl.dart';

class ViewPracticesPage extends StatefulWidget {
  @override
  _ViewPracticesState createState() => _ViewPracticesState();
}

class _ViewPracticesState extends State<ViewPracticesPage> {
  var db = new DatabaseHelper();
  DateFormat dateDisplay = new DateFormat.yMMMMd("en_US");
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Past Practices")),
        body: new Container(
            padding: new EdgeInsets.all(16.0),
            child: new FutureBuilder<List<PracticeSession>>(
                future: db.getPracticeSessions(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return new ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                    dateDisplay.format(snapshot.data[index].startTime),
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),
                                new Text(
                                    formatDurationString(snapshot.data[index].duration),
                                    style: new TextStyle(fontSize: 18.0))
                              ]);
                        });
                  } else if (snapshot.data != null && snapshot.data.length == 0) {
                    return new Text("No Practice Data Found");
                  }
                  return new Container(
                      alignment: AlignmentDirectional.center,
                      child: new CircularProgressIndicator());
                })));
  }

  String formatDurationString(int durationInSeconds){

    final int minutes = (durationInSeconds / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (durationInSeconds % 60).toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}
