// decision_table_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/decision_table_provider.dart';

class DecisionTablePage extends StatelessWidget {
  const DecisionTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DecisionTableProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Decision Table')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Decision Table', style: Theme.of(context).textTheme.titleLarge),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                ...provider.conditions.map(
                  (c) => DataColumn(label: Text(c.name)),
                ),
                ...provider.results.map((r) => DataColumn(label: Text(r))),
              ],
              rows: [
                for (int i = 0; i < provider.ruleCombinations.length; i++)
                  DataRow(
                    cells: [
                      ...provider.ruleCombinations[i].map(
                        (val) => DataCell(Text(val)),
                      ),
                      ...provider.resultTable[i].map(
                        (res) => DataCell(Text(res)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Divider(height: 30),
          Text('Legend', style: Theme.of(context).textTheme.titleLarge),
          ...provider.conditions.map((c) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: TextStyle(fontWeight: FontWeight.bold)),
                ...c.values.entries.map((v) => Text("  ${v.key} = ${v.value}")),
              ],
            );
          }),
        ],
      ),
    );
  }
}
