class Task {
  int? uid;
  String title;
  String remarks;
  bool isDone;
  int? notificationId;
  bool notificationEnabled;
  String notificationDate;
  String notificationTime;

  Task({
    this.uid, required this.title, required this.remarks,
    this.isDone = false, required this.notificationId,
    required this.notificationEnabled, required this.notificationDate,
    required this.notificationTime
  });

  factory Task.fromMap(Map<String, dynamic> json) =>
    Task(
      uid: json['uid'],
      title: json['title'],
      remarks: json['remarks'],
      isDone: json['isDone'] == 1 ? true : false,
      notificationId: json['notificationId'],
      notificationEnabled: json['notificationEnabled'] == 1 ? true : false,
      notificationDate: json['notificationDate'],
      notificationTime: json['notificationTime']
    );

  Map<String, dynamic> toMap() {
    return{
      'uid': uid,
      'title': title,
      'remarks': remarks,
      'isDone': isDone,
      'notificationId': notificationId,
      'notificationEnabled': notificationEnabled,
      'notificationDate': notificationDate,
      'notificationTime': notificationTime
    };
  }
}