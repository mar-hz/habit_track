
// ignore_for_file: file_names

class HabitDay {
  final int id;
  final DateTime dt;
  int totalComp ;

  HabitDay({
    this.id = -1,
    required this.dt,
    required this.totalComp
  });

  factory HabitDay.fromMap(Map<String, dynamic> map) {
    // wont let me access methods in factory...
    var spl = map['date'].split('/');
    DateTime dat = DateTime(int.parse(spl[0]), int.parse(spl[1]), int.parse(spl[2]));

    return HabitDay(
      id: map['id'],
      dt: dat,
      totalComp: map['totalComp']
    );
  }  

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': dtToString(dt),
    'totalComp': totalComp
  };

  static String dtToString(DateTime dt) {
    return "${dt.year}/${dt.month}/${dt.day}";
  }

  static DateTime strToDT(String s) {
    var spl = s.split('/');
    return DateTime(int.parse(spl[0]), int.parse(spl[1]), int.parse(spl[2]));
  }
}