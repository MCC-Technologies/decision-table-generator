// add_results_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/condition_model.dart';
import '../providers/decision_table_provider.dart';
import '../widgets/reusable_widgets.dart';

class AddResultsPage extends StatelessWidget {
  final TextEditingController _resultName = TextEditingController();

  AddResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DecisionTableProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add Results')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _resultName,
            decoration: InputDecoration(labelText: 'Result name'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_resultName.text.isNotEmpty) {
                _showAddResultDialog(context, provider, _resultName.text);
                _resultName.clear();
              }
            },
            child: Text('Add Result'),
          ),
          Divider(),
          ...provider.results.asMap().entries.map((entry) {
            final index = entry.key;
            final result = entry.value;
            return Card(
              child: ExpansionTile(
                title: Text(result.name),
                subtitle: Text('Default: ${result.defaultValue}'),
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
                          _showDeleteResultDialog(context, provider, index),
                    ),
                  ],
                ),
                children: [
                  ...result.allowedValues.map(
                    (v) => ListTile(
                      title: Text(v),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (v == result.defaultValue)
                            Chip(label: Text('default'))
                          else
                            TextButton(
                              onPressed: () =>
                                  provider.setResultDefault(index, v),
                              child: Text('Set default'),
                            ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 18,
                              color: Colors.red,
                            ),
                            tooltip: 'Delete value',
                            onPressed: v == result.defaultValue
                                ? null
                                : () => _showDeleteValueDialog(
                                    context,
                                    provider,
                                    index,
                                    v,
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
            onPressed: () {
              final errors = provider.validate();
              if (errors.isNotEmpty) {
                showValidationError(context, errors);
                return;
              }
              provider.buildDecisionTable();
              Navigator.pushNamed(context, '/table');
            },
            child: Text('Generate Decision Table'),
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
      text: provider.results[index].name,
    );
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Rename result'),
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
                provider.renameResult(index, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteResultDialog(
    BuildContext context,
    DecisionTableProvider provider,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 32),
        title: Text('Delete result?'),
        content: Text(
          'Are you sure you want to delete "${provider.results[index].name}" and all its values?',
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
              provider.deleteResult(index);
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
    String value,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 32),
        title: Text('Delete value?'),
        content: Text('Are you sure you want to delete "$value"?'),
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
              provider.deleteResultValue(index, value);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddResultDialog(
    BuildContext context,
    DecisionTableProvider provider,
    String name,
  ) {
    final valueController = TextEditingController();
    final List<String> pendingValues = [];
    String? pendingDefault;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text('Configure "$name"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: valueController,
                      decoration: InputDecoration(labelText: 'Allowed value'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final v = valueController.text.trim();
                      if (v.isNotEmpty && !pendingValues.contains(v)) {
                        setStateDialog(() {
                          pendingValues.add(v);
                          pendingDefault ??= v;
                          valueController.clear();
                        });
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ...pendingValues.map(
                (v) => ListTile(
                  dense: true,
                  title: Text(v),
                  trailing: pendingDefault == v
                      ? Chip(label: Text('default'))
                      : TextButton(
                          onPressed: () =>
                              setStateDialog(() => pendingDefault = v),
                          child: Text('Set default'),
                        ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: pendingValues.isEmpty || pendingDefault == null
                  ? null
                  : () {
                      provider.addResult(
                        Result(
                          name: name,
                          allowedValues: pendingValues,
                          defaultValue: pendingDefault!,
                        ),
                      );
                      Navigator.pop(ctx);
                    },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddValueDialog(
    BuildContext context,
    DecisionTableProvider provider,
    int index,
  ) {
    final valueController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add value to "${provider.results[index].name}"'),
        content: TextField(
          controller: valueController,
          decoration: InputDecoration(labelText: 'Value'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final v = valueController.text.trim();
              if (v.isNotEmpty) {
                provider.addResultValue(index, v);
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
