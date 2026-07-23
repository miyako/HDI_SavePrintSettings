# HDI_SavePrintSettings

A 4D v16 **HDI** (How Do I) binary database demonstrating how to save and restore print settings, converted to a 4D project using 4D 21. The codebase was then updated and cleaned up with the help of **GitHub Copilot**.

## Origin

This project started as a binary `.4DB` example database originally distributed with 4D v16. It was converted to the modern project architecture (`.4DProject`) using 4D 21's built-in binary-to-project conversion tool.

- **Blog post:** [New commands to save and restore print settings](https://blog.4d.com/print-settings-blob-improvement/)

- **Original download:** [HDI_SavePrintSettings.zip](https://download.4d.com/Demos/4D_v16/HDI_SavePrintSettings.zip)

## Branches

Each branch represents a distinct modernisation effort, guided by a corresponding Copilot instruction file.

| Branch | Description | Instructions |
|--------|-------------|--------------|
| [`miyako-hdi-migration-tasks`](../../tree/miyako-hdi-migration-tasks) | Full HDI modernisation (XLIFF, declarations, menu, method visibility, startup, dark mode CSS) | [localisation.instructions.md](.github/copilot/instructions/localisation.instructions.md), [variable.declarations.instructions.md](.github/copilot/instructions/variable.declarations.instructions.md), [menu.instructions.md](.github/copilot/instructions/menu.instructions.md), [method.visibility.instructions.md](.github/copilot/instructions/method.visibility.instructions.md), [startup.instructions.md](.github/copilot/instructions/startup.instructions.md), [css.instructions.md](.github/copilot/instructions/css.instructions.md), [tahoe.css.instructions.md](.github/copilot/instructions/tahoe.css.instructions.md) |

## Copilot Token Usage

| Session | Branch | Model(s) | Input Tokens | Output Tokens | Turns |
|---------|--------|----------|-------------:|--------------:|------:|
| HDI print settings migration | `miyako-hdi-migration-tasks` | Claude Sonnet 5 | 9,853,886 | 59,523 | 69 |
| **Total** | | | **9,853,886** | **59,523** | **69** |

## Model Selection Assessment

This project was modernised in a single session covering all tasks (XLIFF, declarations, menu, method visibility, startup, dark mode CSS). Claude Sonnet 5 was used throughout. Given the breadth of work -- multiple instruction files applied sequentially in one session -- Sonnet 5 was an appropriate choice. The combined task involved moderate complexity with clear instruction files guiding each step.

**Recommendation:** For future single-session migrations of this scope, Sonnet 5 remains the right default. If splitting into individual sessions, the mechanical subtasks (declarations, method visibility, menu) could use Haiku 4.5.

## Screenshots

<img width="360" height="352" alt="Screenshot 2026-07-23 at 13 20 14" src="https://github.com/user-attachments/assets/28e6f8d9-8825-434a-99f4-fafe42276b65" />
<img width="720" height="572" alt="Screenshot 2026-07-23 at 13 20 17" src="https://github.com/user-attachments/assets/40a51a5f-97c4-4fb0-8fd6-25941a7ab0be" />
<img width="720" height="572" alt="Screenshot 2026-07-23 at 13 20 28" src="https://github.com/user-attachments/assets/71a436f4-0129-4348-944a-b2d732eb01e4" />

