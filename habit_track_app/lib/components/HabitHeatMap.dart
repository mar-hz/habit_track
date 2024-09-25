// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_track_app/database/HabitDay.dart';

class HabitHeatMap extends StatelessWidget {
  final List<HabitDay> datamap;

  const HabitHeatMap({
    super.key,
    required this.datamap
  });

  Map<DateTime, int> makeData() {
    final Map<DateTime, int> data = {};

    if (datamap.isEmpty) {
      data[DateTime.now()] = 0;
      return data;
    }

    int ct = datamap.length;
    for (int i = 0; i < ct; i++) {
      HabitDay cur = datamap[i];
      data[cur.dt] = cur.totalComp;
    }

    return data;
  }

  DateTime getIniDat() {
    DateTime td = DateTime.now();
    return DateTime(td.year, td.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme cs = theme.colorScheme;

    Map<DateTime, int> data = makeData();
    DateTime inidat = getIniDat();

    // Map<DateTime, int> data = {
    //       DateTime(2024, 4, 5): 11
    // };

    String _printCount(DateTime value) {
      if (data[value] == null) {
        return 'Habits completed: 0';
      } else {
        return 'Habits completed: ${data[value]}';
      }
    }

    return HeatMapCalendar(
        margin: const EdgeInsets.all(4.0),
        flexible: true,
    
        datasets: data,
        initDate: inidat,
    
        colorMode: ColorMode.color,
        monthFontSize: 18,
        textColor: cs.onSurface,
        showColorTip: false,
        colorsets: {
          1: Colors.deepPurple[100]!,
          2: Colors.deepPurple[200]!,
          3: Colors.deepPurple[300]!,
          4: Colors.deepPurple[400]!,
          5: Colors.deepPurple,
          6: Colors.deepPurple[600]!,
          7: Colors.deepPurple[700]!,
          8: Colors.deepPurple[800]!,
          9: Colors.deepPurple[900]!,
          10: const Color.fromARGB(255, 57, 19, 119)
        },
        onClick: (value) {
          if (value.isAfter(DateTime.now())) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Come back in the future!"), duration: Duration(seconds: 1, milliseconds: 30)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_printCount(value)), duration: const Duration(seconds: 1, milliseconds: 30)));
          }
        },
    );
  } 
}