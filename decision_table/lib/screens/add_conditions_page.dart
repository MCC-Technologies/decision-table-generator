// add_conditions_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/decision_table_provider.dart';

class AddConditionsPage extends StatelessWidget {
  final TextEditingController _conditionName = TextEditingController();

  AddConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DecisionTableProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add Conditions')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _conditionName,
            decoration: InputDecoration(labelText: 'Condition name'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_conditionName.text.isNotEmpty) {
                provider.addCondition(_conditionName.text);
                _conditionName.clear();
              }
            },
            child: Text('Add Condition'),
          ),
          Divider(),
          ...provider.conditions.asMap().entries.map((entry) {
            final index = entry.key;
            final condition = entry.value;
            return Card(
              child: ExpansionTile(
                title: Text(condition.name),
                children: [
                  ...condition.values.entries.map(
                    (v) => ListTile(title: Text("${v.key} = ${v.value}")),
                  ),
                  ListTile(
                    title: TextButton(
                      child: Text('Add Value'),
                      onPressed: () =>
                          _showAddValueDialog(context, provider, index),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/results');
            },
            child: Text('Next: Add Results'),
          ),
        ],
      ),
    );
  }

  void _showAddValueDialog(
    BuildContext context,
    DecisionTableProvider provider,
    int index,
  ) {
    final codeController = TextEditingController();
    final meaningController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Value for ${provider.conditions[index].name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: '1-letter code'),
            ),
            TextField(
              controller: meaningController,
              decoration: InputDecoration(labelText: 'Meaning'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.addConditionValue(
                index,
                codeController.text,
                meaningController.text,
              );
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
