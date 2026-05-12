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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 20),
                      tooltip: 'Rename',
                      onPressed: () =>
                          _showRenameDialog(context, provider, index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 20, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () =>
                          _showDeleteConditionDialog(context, provider, index),
                    ),
                  ],
                ),
                children: [
                  ...condition.values.entries.map(
                    (v) => ListTile(
                      title: Text('${v.key} = ${v.value}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, size: 18),
                            tooltip: 'Edit value',
                            onPressed: () => _showEditValueDialog(
                              context,
                              provider,
                              index,
                              v.key,
                              v.value,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 18,
                              color: Colors.red,
                            ),
                            tooltip: 'Delete value',
                            onPressed: () => _showDeleteValueDialog(
                              context,
                              provider,
                              index,
                              v.key,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextButton(
                      onPressed: () =>
                          _showAddValueDialog(context, provider, index),
                      child: Text('Add Value'),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/results'),
            child: Text('Next: Add Results'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    DecisionTableProvider provider,
    int index,
  ) {
    final controller = TextEditingController(
      text: provider.conditions[index].name,
    );
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Rename condition'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'New name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.renameCondition(index, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConditionDialog(
    BuildContext context,
    DecisionTableProvider provider,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 32),
        title: Text('Delete condition?'),
        content: Text(
          'Are you sure you want to delete "${provider.conditions[index].name}" and all its values?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              provider.deleteCondition(index);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteValueDialog(
    BuildContext context,
    DecisionTableProvider provider,
    int index,
    String code,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 32),
        title: Text('Delete value?'),
        content: Text('Are you sure you want to delete "$code"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              provider.deleteConditionValue(index, code);
              Navigator.pop(context);
            },
            child: Text('Delete'),
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
        title: Text('Add value for "${provider.conditions[index].name}"'),
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
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (codeController.text.isNotEmpty &&
                  meaningController.text.isNotEmpty) {
                provider.addConditionValue(
                  index,
                  codeController.text.trim(),
                  meaningController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditValueDialog(
    BuildContext context,
    DecisionTableProvider provider,
    int index,
    String oldCode,
    String oldMeaning,
  ) {
    final codeController = TextEditingController(text: oldCode);
    final meaningController = TextEditingController(text: oldMeaning);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit value'),
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
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (codeController.text.isNotEmpty &&
                  meaningController.text.isNotEmpty) {
                provider.updateConditionValue(
                  index,
                  oldCode,
                  codeController.text.trim(),
                  meaningController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
