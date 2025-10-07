// condition_model.dart
class Condition {
  String name;
  Map<String, String> values; // e.g. {'Y': 'Yes', 'N': 'No'}

  Condition({required this.name, required this.values});
}
