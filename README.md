# Decision Table Generator

A Flutter application for creating, editing, and exporting decision tables — a structured tool used in requirements engineering, testing, and business logic documentation.

## What is a Decision Table?

A decision table maps combinations of **conditions** (inputs) to **actions** (results). Each column represents a unique rule — one possible combination of condition values and its corresponding outcomes.

| Condition / Result | Rule 1 | Rule 2 | Rule 3 |
|---|---|---|---|
| Credit Score | H | M | L |
| Employment | E | E | U |
| → Loan Decision | Approved | Review | Declined |

## Features

- **Conditions** — define conditions with custom code/meaning value pairs (e.g. H = High)
- **Results** — define result columns with configurable allowed values and a default
- **Auto-generation** — all rule combinations are generated automatically from condition values
- **Editable cells** — tap any result cell to set its value from the allowed values for that result
- **Row highlighting** — pick a result column to drive row colors, assign a color per value
- **Duplicate detection** — warns when two rules share identical condition combinations
- **Validation** — prevents table generation if conditions or results are incomplete
- **Edit/delete** — rename, edit values, or delete conditions and results at any time
- **CSV export** — copy to clipboard or share as a `.csv` file
- **Reset** — start over without restarting the app
- **Light/dark mode** — follows system theme automatically

## Project Structure

```
lib/
├── models/
│   └── condition_model.dart       # Condition and Result models
├── providers/
│   └── decision_table_provider.dart  # State management
├── screens/
│   ├── add_conditions_page.dart   # Step 1: define conditions
│   ├── add_results_page.dart      # Step 2: define results
│   └── decision_table_page.dart   # Step 3: view and edit table
├── utils/
│   └── helpers.dart               # CSV build and export logic
├── widgets/
│   └── reusable_widgets.dart      # Shared UI components
└── main.dart                      # App entry point and theming
```

## Getting Started

### Requirements

- Flutter SDK 3.9.0 or higher
- Dart SDK 3.9.0 or higher

### Dependencies

```yaml
dependencies:
  provider: ^6.1.2
  path_provider: ^2.1.4
  share_plus: ^10.0.0
```

### Run

```bash
flutter pub get
flutter run
```

## Usage

1. **Add Conditions** — enter a condition name, then add code/meaning value pairs (e.g. Y = Yes, N = No)
2. **Add Results** — enter a result name, define its allowed values, and set a default
3. **Generate** — the app produces all rule combinations automatically
4. **Edit cells** — tap any result cell to change its value via dropdown
5. **Highlight rows** — use the highlighting panel to color-code rows by a result column
6. **Export** — copy or share the table as CSV

## License

MIT