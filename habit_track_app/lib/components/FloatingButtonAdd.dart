
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FloatingButtonAdd extends StatelessWidget {
  final Function()? onPressed;

  const FloatingButtonAdd ({
    super.key,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme cs = theme.colorScheme;
    
    return FloatingActionButton(
      tooltip: "Add new habit",
      onPressed: onPressed,
      child: Icon(Icons.add, color: cs.onPrimary, size: 30) 
    );
  }
  
}