import 'package:flutter/material.dart';

Widget sectionHeader(String title) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Text(
    title,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
);

Future<void> showValidationError(BuildContext context, List<String> errors) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 32),
      title: Text('Cannot generate table'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: errors
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.indigo),
                    SizedBox(width: 8),
                    Expanded(child: Text(e)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
