import 'dart:async';
import 'package:flutter/material.dart';

class TimerService extends ChangeNotifier{
  Stopwatch _stopwatch;
  Timer _timer;

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;

  bool get isRunning => _stopwatch != null && _stopwatch.isRunning;

  TimerService() {
    _stopwatch = Stopwatch();
  }

  void start(){
    if(_timer != null) return;
    _timer = Timer.periodic(Duration(seconds:1),_onTick);
    _stopwatch.start();

    notifyListeners();
  }

  void stop(){
    _timer?.cancel();
    _timer = null;
    _stopwatch.stop();
    _currentDuration = _stopwatch.elapsed;

    notifyListeners();
  }

  void reset(){
    stop();
    _stopwatch.reset();
    _currentDuration = Duration.zero;

    notifyListeners();
  }

  void _onTick(Timer timer){
    _currentDuration = _stopwatch.elapsed;
    notifyListeners();
  }

  static TimerService of(BuildContext context){
    var provider = context.inheritFromWidgetOfExactType(TimerServiceProvider) as TimerServiceProvider;
    return provider.service;
  }
}

class TimerServiceProvider extends InheritedWidget {
  const TimerServiceProvider({Key key, this.service, Widget child}) :super(key:key, child:child);

  final TimerService service;

  @override
  bool updateShouldNotify(TimerServiceProvider old) => service != old.service;
}