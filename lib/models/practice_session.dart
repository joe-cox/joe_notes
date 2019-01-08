class PracticeSession {
  int _id;
  DateTime _startTime;
  int _duration;
  String _notes;

  PracticeSession(this._startTime,this._duration, this._notes);

  PracticeSession.map(dynamic obj) {
    this._id = obj['id'];
    this._startTime = DateTime.parse(obj['start_time']);
    this._duration = obj['duration'];
    this._notes = obj['notes'];
  }

  int get id => _id;
  int get duration => _duration;
  String get notes => _notes;
  DateTime get startTime => _startTime;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    if(_startTime != null){
      map['start_time'] = _startTime.toIso8601String();
    }
    if (_duration != null) {
      map['duration'] = _duration;
    }
    if (_notes != null) {
      map['notes'] = _notes;
    }

    return map;
  }

  PracticeSession.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._startTime = DateTime.parse(map['start_time']);
    this._duration = map['duration'];
    this._notes = map['notes'];
  }
}