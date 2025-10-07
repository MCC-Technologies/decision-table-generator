// add_results_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/decision_table_provider.dart';

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
          ElevatedButton(
            onPressed: () {
              if (_resultName.text.isNotEmpty) {
                provider.addResult(_resultName.text);
                _resultName.clear();
              }
            },
            child: Text('Add Result'),
          ),
          Divider(),
          ...provider.results.map((r) => ListTile(title: Text(r))),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              provider.buildDecisionTable();
              Navigator.pushNamed(context, '/table');
            },
            child: Text('Generate Decision Table'),
          ),
        ],
      ),
    );
  }
}
