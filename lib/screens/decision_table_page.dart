// decision_table_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/decision_table_provider.dart';
import '../utils/helpers.dart';

class DecisionTablePage extends StatelessWidget {
  const DecisionTablePage({super.key});

  static const _palette = [
    (label: 'Green', color: Colors.green),
    (label: 'Red', color: Colors.red),
    (label: 'Amber', color: Colors.amber),
    (label: 'Blue', color: Colors.blue),
    (label: 'Purple', color: Colors.purple),
    (label: 'Grey', color: Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DecisionTableProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Decision Table'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Start over',
            onPressed: () => _showResetDialog(context, provider),
          ),
          IconButton(
            icon: Icon(Icons.copy),
            tooltip: 'Copy CSV',
            onPressed: provider.ruleCombinations.isEmpty
                ? null
                : () async {
                    await copyCsvToClipboard(
                      provider.conditions,
                      provider.results,
                      provider.ruleCombinations,
                      provider.resultTable,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('CSV copied to clipboard')),
                      );
                    }
                  },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Decision Table', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 12),
          _buildHighlightControls(context, provider),
          SizedBox(height: 12),
          _buildDuplicateBanner(provider),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('#')),
                ...provider.conditions.map(
                  (c) => DataColumn(label: Text(c.name)),
                ),
                ...provider.results.map((r) => DataColumn(label: Text(r.name))),
              ],
              rows: [
                for (int i = 0; i < provider.ruleCombinations.length; i++)
                  DataRow(
                    color: WidgetStateProperty.resolveWith(
                      (_) => _rowColor(provider, i),
                    ),
                    cells: [
                      DataCell(Text('${i + 1}')),
                      ...provider.ruleCombinations[i].map(
                        (val) => DataCell(Text(val)),
                      ),
                      ...List.generate(provider.results.length, (ri) {
                        final result = provider.results[ri];
                        final current = provider.resultTable[i][ri];
                        return DataCell(
                          InkWell(
                            onTap: () => _showValueDialog(
                              context,
                              provider,
                              i,
                              ri,
                              current,
                              result.allowedValues,
                            ),
                            child: Chip(label: Text(current)),
                          ),
                        );
                      }),
                    ],
                  ),
              ],
            ),
          ),
          Divider(height: 30),
          Text('Legend', style: Theme.of(context).textTheme.titleLarge),
          ...provider.conditions.map(
            (c) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: TextStyle(fontWeight: FontWeight.bold)),
                ...c.values.entries.map((v) => Text('  ${v.key} = ${v.value}')),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: Icon(Icons.copy),
                label: Text('Copy CSV'),
                onPressed: provider.ruleCombinations.isEmpty
                    ? null
                    : () async {
                        await copyCsvToClipboard(
                          provider.conditions,
                          provider.results,
                          provider.ruleCombinations,
                          provider.resultTable,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('CSV copied to clipboard')),
                          );
                        }
                      },
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                icon: Icon(Icons.share),
                label: Text('Export CSV'),
                onPressed: provider.ruleCombinations.isEmpty
                    ? null
                    : () async {
                        await exportCsvToFile(
                          provider.conditions,
                          provider.results,
                          provider.ruleCombinations,
                          provider.resultTable,
                        );
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color? _rowColor(DecisionTableProvider provider, int ruleIndex) {
    final dupes = provider.findDuplicateRules();
    if (dupes.contains(ruleIndex)) return Colors.red.withValues(alpha: 0.15);

    final hi = provider.highlightResultIndex;
    if (hi == null) return null;
    final value = provider.resultTable[ruleIndex][hi];
    return provider.highlightColors[value]?.withValues(alpha: 0.2);
  }

  Widget _buildHighlightControls(
    BuildContext context,
    DecisionTableProvider provider,
  ) {
    if (provider.results.isEmpty) return SizedBox.shrink();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Row highlighting',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (provider.highlightResultIndex != null)
                  TextButton(
                    onPressed: () => provider.clearHighlight(),
                    child: Text('Clear'),
                  ),
              ],
            ),
            SizedBox(height: 8),
            DropdownButton<int?>(
              value: provider.highlightResultIndex,
              hint: Text('Select result column'),
              isExpanded: true,
              items: [
                DropdownMenuItem(value: null, child: Text('None')),
                ...provider.results.asMap().entries.map(
                  (e) =>
                      DropdownMenuItem(value: e.key, child: Text(e.value.name)),
                ),
              ],
              onChanged: (val) => provider.setHighlightResult(val),
            ),
            if (provider.highlightResultIndex != null) ...[
              SizedBox(height: 12),
              Text(
                'Assign colors to values:',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 8),
              ...provider.results[provider.highlightResultIndex!].allowedValues
                  .map((v) => _buildColorRow(context, provider, v)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildColorRow(
    BuildContext context,
    DecisionTableProvider provider,
    String value,
  ) {
    final selected = provider.highlightColors[value];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(value)),
          SizedBox(width: 8),
          ..._palette.map(
            (p) => GestureDetector(
              onTap: () => provider.setHighlightColor(value, p.color),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: p.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected == p.color
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, DecisionTableProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 32),
        title: Text('Start over?'),
        content: Text(
          'This will clear all conditions, results, and rules. This cannot be undone.',
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
              provider.reset();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: Text('Start over'),
          ),
        ],
      ),
    );
  }

  void _showValueDialog(
    BuildContext context,
    DecisionTableProvider provider,
    int ruleIndex,
    int resultIndex,
    String current,
    List<String> allowedValues,
  ) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text('Set value for "${provider.results[resultIndex].name}"'),
        children: allowedValues
            .map(
              (v) => SimpleDialogOption(
                onPressed: () {
                  provider.updateResultCell(ruleIndex, resultIndex, v);
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      v == current
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(v),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDuplicateBanner(DecisionTableProvider provider) {
    final dupes = provider.findDuplicateRules();
    if (dupes.isEmpty) return SizedBox.shrink();

    final ruleNumbers = dupes.map((i) => 'Rule ${i + 1}').join(', ');
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Duplicate condition combinations detected: $ruleNumbers',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
