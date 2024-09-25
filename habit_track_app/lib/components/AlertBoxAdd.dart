
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AlertBoxAdd extends StatelessWidget {
  
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;
    
  const AlertBoxAdd ({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSave,
    required this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme cs = theme.colorScheme;

    return AlertDialog(
      backgroundColor: Colors.grey[800]!.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      content: TextField(
        controller: controller,
        style: TextStyle(color: cs.surface),
        
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]!),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cs.surface)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cs.secondary)),
        ),
      ),

      actions: [
        MaterialButton(
          color: cs.onBackground,
          highlightColor: cs.secondary,
          splashColor: cs.secondary,
          onPressed: onSave,
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),

        MaterialButton(
          color: cs.onBackground,
          highlightColor: cs.secondary,
          splashColor: cs.secondary,
          onPressed: onCancel,
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}