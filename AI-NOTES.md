# AI Notes

## How I Used AI on This Project

This project was built iteratively using Claude (Anthropic) as a coding collaborator. Rather than generating the entire codebase at once, I used AI in a back-and-forth process — sharing existing code, asking targeted questions, and reviewing each change before moving on.

## Process

### Approach
The interaction was deliberately incremental. Before any code was written, Claude reviewed existing files to understand the current structure. Changes were proposed one step at a time and confirmed before implementation. This kept the output focused and avoided large rewrites that would be hard to review.

### What AI helped with
- Refreshing my understanding of what a decision table is and how it is structured
- Designing the `Condition` and `Result` models, including validation logic (e.g. enforcing that `defaultValue` must be one of `allowedValues`)
- Updating the provider from `List<String>` to a proper `Result` model without breaking existing functionality
- Implementing the recursive rule combination generator
- Building editable result cells with per-result configurable dropdowns
- CSV generation and export via clipboard and file share
- Edit and delete flows for conditions, results, and their values
- Validation before table generation
- Row highlighting with a user-selected result column and color picker
- Duplicate rule detection with a warning banner and row accent
- Light/dark theming using Material 3 and system settings
- Catching issues like `notifyListeners()` being called outside the provider, deprecated `withOpacity`, and `actions` placed on `Scaffold` instead of `AppBar`

### What I drove
- Project structure and file layout
- Choice of state management (Provider)
- Decision to keep changes iterative rather than generating everything at once
- Feature prioritization at each step
- Final review and testing of each change

## Takeaways

Using AI iteratively — sharing real code and confirming each step — produced much cleaner results than prompting for a full implementation upfront. The AI was most useful as a reviewer and implementer working within an existing structure, rather than as a generator starting from scratch.