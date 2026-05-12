// decision_table_provider.dart
import 'package:flutter/material.dart';

import '../models/condition_model.dart';

class DecisionTableProvider extends ChangeNotifier {
  List<Condition> conditions = [];
  List<Result> results = [];
  List<List<String>> ruleCombinations = [];
  List<List<String>> resultTable = [];

  void addCondition(String name) {
    conditions.add(Condition(name: name, values: {}));
    notifyListeners();
  }

  void addConditionValue(int conditionIndex, String code, String meaning) {
    conditions[conditionIndex].values[code] = meaning;
    notifyListeners();
  }

  void addResult(Result result) {
    results.add(result);
    notifyListeners();
  }

  void updateResultCell(int ruleIndex, int resultIndex, String value) {
    assert(
      results[resultIndex].allowedValues.contains(value),
      'Value must be one of allowedValues',
    );
    resultTable[ruleIndex][resultIndex] = value;
    notifyListeners();
  }

  void _generateCombinations(
    int index,
    List<String> current,
    List<List<String>> output,
  ) {
    if (index == conditions.length) {
      output.add(List.from(current));
      return;
    }
    conditions[index].values.forEach((code, meaning) {
      current.add(code);
      _generateCombinations(index + 1, current, output);
      current.removeLast();
    });
  }

  void buildDecisionTable() {
    ruleCombinations.clear();
    resultTable.clear();
    _generateCombinations(0, [], ruleCombinations);

    for (var i = 0; i < ruleCombinations.length; i++) {
      resultTable.add(results.map((r) => r.defaultValue).toList());
    }
    notifyListeners();
  }

  void setResultDefault(int resultIndex, String value) {
    results[resultIndex].defaultValue = value;
    notifyListeners();
  }

  void addResultValue(int resultIndex, String value) {
    results[resultIndex].addAllowedValue(value);
    notifyListeners();
  }

  List<String> validate() {
    final errors = <String>[];

    if (conditions.isEmpty) {
      errors.add('Add at least one condition.');
    } else {
      for (final c in conditions) {
        if (c.values.isEmpty) {
          errors.add('"${c.name}" has no values defined.');
        }
      }
    }

    if (results.isEmpty) {
      errors.add('Add at least one result.');
    }

    return errors;
  }

  void deleteCondition(int index) {
    conditions.removeAt(index);
    notifyListeners();
  }

  void deleteConditionValue(int conditionIndex, String code) {
    conditions[conditionIndex].values.remove(code);
    notifyListeners();
  }

  void renameCondition(int index, String newName) {
    conditions[index].name = newName;
    notifyListeners();
  }

  void updateConditionValue(
    int conditionIndex,
    String oldCode,
    String newCode,
    String newMeaning,
  ) {
    final values = conditions[conditionIndex].values;
    values.remove(oldCode);
    values[newCode] = newMeaning;
    notifyListeners();
  }

  void deleteResult(int index) {
    results.removeAt(index);
    notifyListeners();
  }

  void deleteResultValue(int resultIndex, String value) {
    results[resultIndex].removeAllowedValue(value);
    notifyListeners();
  }

  void renameResult(int index, String newName) {
    results[index].name = newName;
    notifyListeners();
  }

  void reset() {
    conditions.clear();
    results.clear();
    ruleCombinations.clear();
    resultTable.clear();
    highlightResultIndex = null;
    highlightColors.clear();
    notifyListeners();
  }

  int? highlightResultIndex;

  void setHighlightResult(int? index) {
    highlightResultIndex = index;
    notifyListeners();
  }

  Map<String, Color> highlightColors = {};

  void setHighlightColor(String value, Color color) {
    highlightColors[value] = color;
    notifyListeners();
  }

  void clearHighlight() {
    highlightResultIndex = null;
    highlightColors.clear();
    notifyListeners();
  }

  List<int> findDuplicateRules() {
    final seen = <String, int>{};
    final duplicates = <int>{};

    for (int i = 0; i < ruleCombinations.length; i++) {
      final key = ruleCombinations[i].join('|');
      if (seen.containsKey(key)) {
        duplicates.add(i);
        duplicates.add(seen[key]!);
      } else {
        seen[key] = i;
      }
    }

    return duplicates.toList()..sort();
  }
}
