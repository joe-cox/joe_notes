import 'package:flutter/material.dart';
import 'package:joe_notes/track_practice_page.dart';
import 'package:joe_notes/view_practices_page.dart';
import 'package:joe_notes/timer_service.dart';

void main() {
  final timerService = TimerService();
  runApp(
    TimerServiceProvider(
      service:timerService,
      child: JoeNotes(),
    )
  );
}

class JoeNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Joe Notes',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ActivityHomePage(title: 'Select An Activity'),
    );
  }
}

class ActivityHomePage extends StatefulWidget {
  ActivityHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ActivityHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _buildGrid());
  }

  Widget _buildGrid() {
    return GridView.extent(
        maxCrossAxisExtent: 150.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: [
          new GridTile(
            child: new InkResponse(
                enableFeedback: true,
                child: Image.asset('images/accordionIcon.jpg',
                    height: 100, fit: BoxFit.cover),
                onTap: () => _onAccordionClicked()),
          )
        ]);
  }

  void _onAccordionClicked() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new Scaffold(
              appBar: new AppBar(title: const Text('Accordion Activities')),
              body: new ListView(children: [
                new ListTile(
                    title: new Text('Track Practice',
                        style: new TextStyle(fontSize: 18.0)),
                    onTap: _onStartTrackingPractice),
                new ListTile(
                    title: new Text('View Practices',
                        style: new TextStyle(fontSize: 18)),
                    onTap: _onViewPractices)
              ]));
        },
      ),
    );
  }

  void _onStartTrackingPractice() {
    Navigator.of(context)
        .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
      return new TrackPracticePage();
    }));
  }

  void _onViewPractices() {
    Navigator.of(context)
        .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
      return new ViewPracticesPage();
    }));
  }
}
