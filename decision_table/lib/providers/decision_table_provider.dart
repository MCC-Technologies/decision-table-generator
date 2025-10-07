// decision_table_provider.dart
import 'package:flutter/material.dart';
import '../models/condition_model.dart';

class DecisionTableProvider extends ChangeNotifier {
  List<Condition> conditions = [];
  List<String> results = [];
  List<List<String>> ruleCombinations = [];
  List<List<String>> resultTable = [];

  // Add a new condition
  void addCondition(String name) {
    conditions.add(Condition(name: name, values: {}));
    notifyListeners();
  }

  // Add possible values to a condition
  void addConditionValue(int conditionIndex, String code, String meaning) {
    conditions[conditionIndex].values[code] = meaning;
    notifyListeners();
  }

  // Add result/action
  void addResult(String name) {
    results.add(name);
    notifyListeners();
  }

  // --- Recursive combination generator ---
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

  // --- Generate all rules and result table ---
  void buildDecisionTable() {
    ruleCombinations.clear();
    resultTable.clear();

    _generateCombinations(0, [], ruleCombinations);

    // Fill result table with placeholder "X"
    for (var i = 0; i < ruleCombinations.length; i++) {
      resultTable.add(List.generate(results.length, (_) => 'X'));
    }
    notifyListeners();
  }
}
