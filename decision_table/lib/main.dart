import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/decision_table_provider.dart';
import 'screens/add_conditions_page.dart';
import 'screens/add_results_page.dart';
import 'screens/decision_table_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DecisionTableProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => AddConditionsPage(),
          '/results': (context) => AddResultsPage(),
          '/table': (context) => DecisionTablePage(),
        },
      ),
    ),
  );
}
