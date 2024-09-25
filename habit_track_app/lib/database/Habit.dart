
// ignore_for_file: file_names

class Habit {
  final int id;
  final String name;
  final bool complete;

  const Habit ({
    this.id = -1,
    required this.name,
    required this.complete
  });

  factory Habit.fromMap(Map<String, dynamic> map) {
    bool compBool = false;
    if (map['complete'] == 0) {
      compBool = false;
    } else {
      compBool = true;
    }

    return Habit(
      id: map['id'],
      name: map['name'], 
      complete: compBool
    );
  }  

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'complete': (complete ? 1 : 0)
  };

  static int negComplete(Map<String, dynamic> map) {
    if (map['complete'] == 0) {
      return 1;
    } else {
      return 0;
    }
  }

  static Habit updName(Habit hb, String name) {
    Map<String, dynamic> map = hb.toMap();
    map['name'] = name;
    Habit newhb = Habit.fromMap(map);

    return newhb;
  }
}