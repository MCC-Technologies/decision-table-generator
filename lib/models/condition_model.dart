// condition_model.dart
class Condition {
  String name;
  Map<String, String> values; // e.g. {'Y': 'Yes', 'N': 'No'}

  Condition({required this.name, required this.values});
}

class Result {
  String name;
  final List<String> _allowedValues;
  String _defaultValue;

  Result({
    required this.name,
    required List<String> allowedValues,
    required String defaultValue,
  }) : assert(allowedValues.isNotEmpty, 'allowedValues cannot be empty'),
       assert(
         allowedValues.contains(defaultValue),
         'defaultValue must be one of allowedValues',
       ),
       _allowedValues = allowedValues,
       _defaultValue = defaultValue;

  List<String> get allowedValues => List.unmodifiable(_allowedValues);

  String get defaultValue => _defaultValue;

  set defaultValue(String value) {
    assert(
      _allowedValues.contains(value),
      'defaultValue must be one of allowedValues',
    );
    _defaultValue = value;
  }

  void addAllowedValue(String value) {
    if (!_allowedValues.contains(value)) _allowedValues.add(value);
  }

  void removeAllowedValue(String value) {
    assert(value != _defaultValue, 'Cannot remove the current defaultValue');
    _allowedValues.remove(value);
  }
}
