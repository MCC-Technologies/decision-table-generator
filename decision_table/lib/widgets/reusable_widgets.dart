import 'package:flutter/material.dart';

Widget sectionHeader(String title) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Text(
    title,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
);
