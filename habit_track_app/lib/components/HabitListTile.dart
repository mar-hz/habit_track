// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitListTile extends StatelessWidget {

  final String title;
  final bool value;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? onSettings;
  final void Function(BuildContext)? onDelete;

  const HabitListTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.onSettings,
    required this.onDelete, 
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme cs = theme.colorScheme;

    List<Color> colorPick(bool value) {
      if (value) {
        return [cs.secondary, cs.onSecondary];
      } else {
        return [cs.surface, cs.onSurface];
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        startActionPane:ActionPane(
              motion: const ScrollMotion(), 
              children: [
                SlidableAction(
                  onPressed: onSettings,
                  backgroundColor: Colors.grey[700]!,
                  icon: Icons.settings,
                )
              ]
            ),
        
            endActionPane:ActionPane(
              motion: const ScrollMotion(), 
              children: [
                SlidableAction(
                  onPressed: onDelete,
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                )
              ]
            ),

        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorPick(value)[0]
          ),
          child: CheckboxListTile(
                  title: Text(
                    title,   
                    style: TextStyle(color: colorPick(value)[1], fontSize: 17.5)
                  ),
                  value: value, 
                  onChanged: onChanged,
              
                  checkColor: cs.onSecondary,
                  side: MaterialStateBorderSide.resolveWith(
                    (states) => BorderSide(
                      color: colorPick(value)[1],
                      width: 1.5
                    )),
                )
            ),
          ),
    );
  }

}