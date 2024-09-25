// ignore_for_file: file_names, unused_local_variable

import 'package:habit_track_app/database/HabitDay.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'Habit.dart';

class DatabaseHelper {

	static DatabaseHelper? _databaseHelper;    // Singleton DatabaseHelper
	static Database? _database;                // Singleton Database

	String habitTable = 'habits';
	String colId = 'id';
	String colName = 'name';
	String colComplete = 'complete';

  String dayTable = 'dates';
  String colDate = 'date';
  String colTotHb = 'totalComp';

	DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

	factory DatabaseHelper() {
		_databaseHelper ??= DatabaseHelper._createInstance();
		return _databaseHelper!;
	}

	Future<Database> get database async {
		_database ??= await initializeDatabase();
		return _database!;
	}

	Future<Database> initializeDatabase() async {
		var habitDatabase = await openDatabase(join(await getDatabasesPath(), 'habit_data.db'), version: 1, onCreate: _createDb);
		return habitDatabase;
	}

	void _createDb(Database db, int newVersion) async {

		await db.execute('CREATE TABLE $habitTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
				'$colComplete INTEGER)');
    await db.execute('CREATE TABLE $dayTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDate TEXT, '
				'$colTotHb INTEGER)');
	}

	// Fetch Operation: Get all objects from database
	Future<List<Map<String, dynamic>>> getAllHabits() async {
		Database db = await database;

		var result = await db.rawQuery('SELECT * FROM $habitTable ORDER BY $colId');
		return result;
	}

  Future<List<Map<String, dynamic>>> getAllDates() async {
		Database db = await database;

		var result = await db.rawQuery('SELECT * FROM $dayTable ORDER BY $colId');
		return result;
	}

	// Insert Operation: Insert object to database
	Future<int> insert(String name, int complete) async {
		Database db = await database;
		var result = await db.rawInsert('INSERT INTO $habitTable($colName, $colComplete) VALUES (?, ?)', [name, complete]);
		return result;
	}

  Future<int> insertDay(String date, int ctDone) async {
		Database db = await database;
    List<HabitDay> cur = await getDayList();
    String today = HabitDay.dtToString(DateTime.now());
    
    for (int i = 0; i < cur.length; i++) {
      if (HabitDay.dtToString(cur[i].dt) == today) {
        return cur[i].totalComp;
      }
    }
		var result = await db.rawInsert('INSERT INTO $dayTable($colDate, $colTotHb) VALUES (?, ?)', [date, ctDone]);
		return 0;
	}

	// Update Operation: Update object and save it to database
	Future<int> update(Habit hb) async {
		var db = await database;
    int compInt = 0;
    if (hb.complete == false) {
      compInt = 0;
    } else {
      compInt = 1;
    }

		var result = await db.rawUpdate('UPDATE $habitTable SET name = ?, complete = ? WHERE id = ?', [hb.name, compInt, hb.id]);
		return result;
	}

  Future<int> updateDay(String today, int todayDone) async {
		var db = await database;

		var result = await db.rawUpdate('UPDATE $dayTable SET $colTotHb = ? WHERE $colDate = ?', [todayDone, today]);
		return result;
	}

	// Delete Operation: Delete object from database
	Future<int> delete(int id) async {
		var db = await database;
		int result = await db.rawDelete('DELETE FROM $habitTable WHERE $colId = $id');
		return result;
	}

	// Get number of objects in database
	Future<int> getCount() async {
		Database db = await database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $habitTable');
		int? result = Sqflite.firstIntValue(x);
    result ??= 0;
    
		return result;
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'Habit List' [ List<Habit> ]
	Future<List<Habit>> getHabitList() async {
		var habitMapList = await getAllHabits(); // Get 'Map List' from database
		int count = habitMapList.length;         // Count the number of map entries in db table

		List<Habit> hbList = [];

		for (int i = 0; i < count; i++) {
			hbList.add(Habit.fromMap(habitMapList[i]));
		}

		return hbList;
	}

  Future<List<HabitDay>> getDayList() async {
		var dayList = await getAllDates(); // Get 'Map List' from database
		int count = dayList.length;         // Count the number of map entries in db table

		List<HabitDay> hbdayList = [];

		for (int i = 0; i < count; i++) {
			hbdayList.add(HabitDay.fromMap(dayList[i]));
		}

		return hbdayList;
	}

  Future<int> resetComp() async {
    var db = await database;

		var result = await db.rawUpdate('UPDATE $habitTable SET $colComplete = ?', [0]);
		return result;
  }

  // Delete database for testing
  Future<void> deleteDB() async {
		await deleteDatabase(join(await getDatabasesPath(), 'habit_data.db'));
	}

  Future<String> getPath() async {
    return await getDatabasesPath();
  }

  Future<void> resetDay() async {
    var db = await database;
    await db.execute('DELETE FROM $dayTable WHERE $colDate = ?', [HabitDay.dtToString(DateTime.now())]);
  }
}