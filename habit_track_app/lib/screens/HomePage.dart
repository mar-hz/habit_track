// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names, unused_local_variable


import 'package:flutter/material.dart';
import 'package:habit_track_app/components/HabitHeatMap.dart';
import 'package:habit_track_app/database/Habit.dart';
import 'package:habit_track_app/components/HabitListTile.dart';
import 'package:habit_track_app/components/AlertBoxAdd.dart';
import 'package:habit_track_app/components/FloatingButtonAdd.dart';
import 'package:habit_track_app/database/DatabaseHelper.dart';
import 'package:habit_track_app/database/HabitDay.dart';
import 'package:habit_track_app/components/MyDrawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {  
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Habit> habits = [];
  List<HabitDay> days = [];
  bool loaded = false;
  int todayDone = 0;

  // why is this method list so saturated. we need more thorough full-project sqflite docus please
  // babys first database

  // General management methods
  void prevPage() {
    Navigator.of(context).pop();
  }

  void showSnackBar(String txt) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt), duration: const Duration(seconds: 1, milliseconds: 30),));
  }

  // State management methods
  void refreshState () async {
    _loadHabitState(await databaseHelper.getHabitList());
  }

  void firstLoad() async {
    String today = HabitDay.dtToString(DateTime.now());
    int a = await databaseHelper.insertDay(today, 0);
    if (a == 0) {
      int b = await databaseHelper.resetComp();
    }

    firstLoadDone(a, await databaseHelper.getDayList());
  }

  void _loadHabitState(List<Habit> newhabits) {
    setState(() {
      habits = newhabits;
    });
  }

  void firstLoadDone(int a, List<HabitDay> newdays) {
    setState(() {
      loaded = true;
      todayDone = a;
      days = newdays;
    });
  }

  void refreshDays () async {
    _loadDayState(await databaseHelper.getDayList(), todayDone);
  }

  void _loadDayState(List<HabitDay> newdays, int done) {
    setState(() {
      days = newdays;
      todayDone = done;
    });
  }

  refreshFullState(int done) async {
    List<Habit> newhabits = await databaseHelper.getHabitList();
    _loadFullState(newhabits, await databaseHelper.getDayList(), done);

  }

  _loadFullState(List<Habit> newhabits, List<HabitDay> newdays, int done) {
    setState(() {
      habits = newhabits;
      days = newdays;
      todayDone = done;
    });
  }

  // void updateCheckbox(bool? value, int index) async {
  //   Map<String, dynamic> hbMap = habits[index].toMap();
  //   hbMap['complete'] = Habit.negComplete(hbMap);
  //   Habit updt = Habit.fromMap(hbMap);

  //   await databaseHelper.update(updt);
  // }

  // Widget action methods
  void checkboxTap(bool? value, int index) async { // HabitTile
    //updateCheckbox(value, index);

    Map<String, dynamic> hbMap = habits[index].toMap();
    hbMap['complete'] = Habit.negComplete(hbMap);
    Habit updt = Habit.fromMap(hbMap);

    int done = todayDone;
    if (value == false) {
      done--;
    } else {
      done++;
    }

    int a = await databaseHelper.update(updt);
    a = await databaseHelper.updateDay(HabitDay.dtToString(DateTime.now()), done);
    refreshFullState(done);
  }

  void onSettings(String name, int index) { // Slidable (left)
    final _updNameController = TextEditingController(text: name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertBoxAdd(
          controller: _updNameController,
          hintText: 'Enter habit name',
          onSave: () => {updateHabit(_updNameController, index)},
          onCancel: () => {onCancel()},
        );
      },
    );
  }

  void onDelete(int index) async {
    int done = todayDone;
    if (habits[index].complete == true) {
      done--;
      int a = await databaseHelper.updateDay(HabitDay.dtToString(DateTime.now()), done);
    }

    await databaseHelper.delete(habits[index].id);
    //_loadHabitState(await databaseHelper.getHabitList());

    refreshFullState(done);
    
    showSnackBar("Habit deleted");
  }

  final _newNameController = TextEditingController(); // Alert Box
  void createNewHabit() { // FAB
    showDialog(
      context: context,
      builder: (context) {
        return AlertBoxAdd(
          controller: _newNameController,
          hintText: 'Enter habit name',
          onSave: () => {makeNewHabit()},
          onCancel: () => {onCancel()},
        );
      },
    );
  }

  void onCancel() { // Action Box
    _newNameController.clear();
    prevPage();
  }

  void makeNewHabit() async { // Action Box
    await databaseHelper.insert(_newNameController.text, 0);
    refreshState();

    _newNameController.clear();
    prevPage();
  }

  void updateHabit(TextEditingController txec, int index) async {
    await databaseHelper.update(Habit.updName(habits[index], txec.text));
    _loadHabitState(await databaseHelper.getHabitList());

    txec.clear();
    prevPage();
  }

  @override
  void initState() {
    super.initState();
    //databaseHelper.resetDay();
    firstLoad();
    refreshState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    //databaseHelper.deleteDB();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: cs.background,

      appBar: AppBar(
        backgroundColor: cs.primary,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, size: 30, color: cs.onPrimary,),
          onPressed: () => {
            _scaffoldKey.currentState?.openDrawer(),
          }
        ),
        title: Text(widget.title, style: TextStyle(fontSize: 22, color: cs.onPrimary)),
        toolbarHeight: 72
      ),

      drawer: const MyDrawer(),

      body: ListView(
        padding:const EdgeInsets.all(15.0),
        children: [ 
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: HabitHeatMap(datamap: days)
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            itemCount: habits.length,
            itemBuilder: (context, index) {
              return HabitListTile(
              title: habits[index].name,
              value: habits[index].complete,
              onChanged: (value) => checkboxTap(value, index),
              onSettings: (context) => {onSettings(habits[index].name, index)},
              onDelete: (context) => {onDelete(index)},
              );
            }
          )
        ],
      ),

      floatingActionButton: FloatingButtonAdd(onPressed: () => {createNewHabit()})
    );
  }
}