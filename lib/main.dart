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
      child: const DecisionTableApp(),
    ),
  );
}

class DecisionTableApp extends StatelessWidget {
  const DecisionTableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      initialRoute: '/',
      routes: {
        '/': (context) => AddConditionsPage(),
        '/results': (context) => AddResultsPage(),
        '/table': (context) => DecisionTablePage(),
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: brightness,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDark ? Colors.indigo.shade900 : Colors.indigo.shade50,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: isDark ? Colors.indigo.shade900 : Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? Colors.indigo.shade700
            : Colors.indigo.shade100,
        labelStyle: TextStyle(
          color: isDark ? Colors.white : Colors.indigo.shade900,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.indigo.shade700 : Colors.indigo.shade100,
        thickness: 1,
      ),
    );
  }
}
