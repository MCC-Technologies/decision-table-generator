// helpers.dart
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/condition_model.dart';

Future<void> copyCsvToClipboard(
  List<Condition> conditions,
  List<Result> results,
  List<List<String>> ruleCombinations,
  List<List<String>> resultTable,
) async {
  final csv = buildCsv(conditions, results, ruleCombinations, resultTable);
  await Clipboard.setData(ClipboardData(text: csv));
}

Future<void> exportCsvToFile(
  List<Condition> conditions,
  List<Result> results,
  List<List<String>> ruleCombinations,
  List<List<String>> resultTable,
) async {
  final csv = buildCsv(conditions, results, ruleCombinations, resultTable);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/decision_table.csv');
  await file.writeAsString(csv);
  await Share.shareXFiles([
    XFile(file.path, mimeType: 'text/csv'),
  ], subject: 'Decision Table Export');
}

String buildCsv(
  List<Condition> conditions,
  List<Result> results,
  List<List<String>> ruleCombinations,
  List<List<String>> resultTable,
) {
  final buf = StringBuffer();

  // Header row: blank cell + Rule 1, Rule 2, ...
  final header = [
    '',
    ...List.generate(ruleCombinations.length, (i) => 'Rule ${i + 1}'),
  ];
  buf.writeln(_csvRow(header));

  // Condition rows
  for (int ci = 0; ci < conditions.length; ci++) {
    final row = [conditions[ci].name, ...ruleCombinations.map((r) => r[ci])];
    buf.writeln(_csvRow(row));
  }

  // Separator
  buf.writeln(
    _csvRow(['---', ...List.generate(ruleCombinations.length, (_) => '---')]),
  );

  // Result rows
  for (int ri = 0; ri < results.length; ri++) {
    final row = [results[ri].name, ...resultTable.map((r) => r[ri])];
    buf.writeln(_csvRow(row));
  }

  return buf.toString();
}

String _csvRow(List<String> cells) => cells.map(_csvCell).join(',');

String _csvCell(String s) =>
    s.contains(',') || s.contains('"') || s.contains('\n')
    ? '"${s.replaceAll('"', '""')}"'
    : s;
