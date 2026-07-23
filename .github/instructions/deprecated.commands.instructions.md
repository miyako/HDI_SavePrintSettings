---
description: "Rules for identifying and replacing deprecated 4D commands in projects with a compatibilityVersion floor of v17+, including the _o_/_O_ compatibility-layer naming convention"
---

# 4D Deprecated Commands — Agent Rules

## Overview

4D maintains backward compatibility by keeping old commands available under internal
"compatibility" names, even long after a modern replacement exists. Any project converted
to project mode (`.4DProject`) is running **4D v17 or later** — the binary-to-project
conversion tool does not exist for earlier versions. This means **any command whose
replacement shipped in v17 or earlier is safe to migrate unconditionally**; there is no
need to preserve the old form for compatibility with an older runtime that can no longer
exist for this project.

This document describes how to recognise deprecated commands and migrate them, independent
of the more specific `C_*` → `var`/`#DECLARE` (see `variable.declarations.instructions.md`)
and `Get localized string` → `Localized string` (see `localisation.instructions.md`)
migrations, which are covered by their own instruction files.

---

## Recognising Deprecated Commands

### The `_o_` / `_O_` naming convention

Commands prefixed with `_o_` or `_O_` (case varies by command) are 4D's internal
**compatibility layer** — old command implementations kept solely so pre-existing compiled
code keeps working. They are never the preferred spelling for new or updated code.

**Indicators a command is part of the compatibility layer:**
- The command name starts with `_o_` or `_O_` (e.g. `_o_Object Accept action`,
  `_O_PLATFORM PROPERTIES`, `_O_REDRAW LIST`).
- The 4D documentation page for the command is titled or tagged "deprecated" and links to
  a "replaced by" command.
- The command only appears in old/unconverted code, never in current 4D sample code or
  blog posts.

### Other deprecation signals

Not all deprecated commands use the `_o_`/`_O_` prefix. Also watch for:
- Commands explicitly called out in 4D's "Simplified commands for cleaner codebase" blog
  post (see References) — e.g. `Get localized string` → `Localized string`.
- Constants used only to emulate behaviour now exposed directly as a boolean command (e.g.
  comparing a platform code constant instead of calling a dedicated `Is <Platform>`
  command).
- Commands whose 4D documentation page has a "Deprecated" banner or redirects to another
  command's page.

---

## Known Deprecated Commands and Replacements

| Deprecated command | Token | Replacement | Notes |
|---------------------|-------|-------------|-------|
| `_O_PLATFORM PROPERTIES` | `:C365` | `Is macOS`, `Is Windows` | Returns a platform code longint via a parameter; replace the `Case of` / constant comparison with a direct boolean check. |
| `_o_Object Accept action` / `_o_Object Cancel action` (used with `OBJECT SET ACTION`) | `:K76:3` / `:K76:2` | `"action": "accept"` / `"action": "cancel"` in the object's `form.4DForm` definition | Standard actions set declaratively in the form JSON get platform-native enable/disable behaviour; `OBJECT SET ACTION` at runtime does not need to duplicate this. |
| `Get localized string` | `:C991` (legacy) | `Localized string` | See `localisation.instructions.md`. Only relevant for `compatibilityVersion >= 2070` (4D 20 R7+). |
| `C_LONGINT`, `C_TEXT`, `C_OBJECT`, `C_BOOLEAN`, `C_POINTER`, `C_BLOB`, `C_DATE`, `C_TIME`, `C_PICTURE`, `C_VARIANT`, `C_COLLECTION` | various | `var` / `#DECLARE` | See `variable.declarations.instructions.md`. Only relevant for `compatibilityVersion >= 2070`. |
| `New process` (used solely to create an event cycle for a modal dialog) | `:C7` | `CALL WORKER(1; ...)` + `DIALOG(...; *)` | See `startup.instructions.md`. Not a renamed command, but an obsolete pattern that should be replaced outright. |

> This table is **not exhaustive**. Always check the command's page on
> `https://developer.4d.com/docs/commands/` for a "Deprecated" notice before assuming a
> command is still current, especially for anything with an `_o_`/`_O_` prefix.

---

## Migration Rules

### Rule 1: Replace platform-code comparisons with `Is <Platform>`

**Before:**
```4d
var $platform : Integer
_O_PLATFORM PROPERTIES:C365($platform)

Case of 
	: ($platform=Mac OS:K25:2)
		// mac-specific code
	: ($platform=Windows:K25:3)
		// windows-specific code
End case 
```

**After:**
```4d
If (Is macOS)
	// mac-specific code
Else 
	// windows-specific code
End if 
```

**Key points:**
- `Is macOS` and `Is Windows` are plain boolean commands — no output parameter, no
  constant comparison, no `Case of` needed for a two-platform branch.
- Drop the now-unused `$platform` variable declaration entirely; do not leave an unused
  `var` line behind.
- If the code only ever branched on two platforms (mac/Windows), an `If`/`Else` is
  clearer than a `Case of`. Keep `Case of` only if 4D adds further platform commands you
  need to branch on (there are currently only `Is macOS` and `Is Windows`).

### Rule 2: Prefer declarative `"action"` in form JSON over `OBJECT SET ACTION` with `_o_` constants

**Before:**
```4d
OBJECT SET ACTION:C1259(*; "BtnDemo"; _o_Object Accept action:K76:3)
```

**After:**
```json
"BtnDemo": {
	"type": "button",
	"action": "accept",
	...
}
```

**Why:** Setting the standard action in the form JSON gives the button native
enable/disable behaviour without any method code, and removes the need for the `*`
named-object-reference call (which also requires the method to be marked `invisible` per
`method.visibility.instructions.md`). Only use `OBJECT SET ACTION` at runtime when the
action must be assigned conditionally based on logic that cannot be expressed statically
in the form.

### Rule 3: Do not "fix" a deprecated command by swapping tokens only

Renaming a command's token (e.g. changing `:C365` to another number) without changing the
command name and call pattern is not a migration — it is guessing, which is explicitly
forbidden by `startup.instructions.md` and `tahoe.css.instructions.md`. Always replace the
**command name and its parameter signature**, matching the modern command's actual
signature (e.g. `Is macOS` takes no parameters and returns a boolean, unlike
`_O_PLATFORM PROPERTIES` which writes into a longint parameter).

---

## Audit Procedure

### Step 1: Search for compatibility-layer commands

```
grep -rn "_[oO]_[A-Za-z]" Project/Sources --include=*.4dm
```

Any match is a candidate for migration — confirm the modern replacement on
`https://developer.4d.com/docs/commands/` before changing anything.

### Step 2: Cross-check other instruction files

Some deprecations are covered by dedicated instruction files and should be handled there,
not duplicated here:
- `C_*` declarations → `variable.declarations.instructions.md`
- `Get localized string` → `localisation.instructions.md`
- Blocking `DIALOG` + `CLOSE WINDOW` + `New process` startup patterns →
  `startup.instructions.md`

### Step 3: Verify no non-variable / no-parameter mismatches remain

After replacing a command, re-read the full method to confirm:
- Any variable that only existed to hold the deprecated command's output parameter
  (e.g. `$platform`) is removed if no longer read elsewhere.
- Any `Case of` / `If` structure that branched on a returned constant now branches on the
  new boolean command directly, without a leftover comparison against the constant.

### Step 4: Confirm nothing regressed

Re-run the project's existing lint/build/compile step (if any) and manually trace each
call site of the removed command to confirm behaviour is preserved.

---

## Anti-Patterns to Avoid

### ❌ Leaving the output parameter and `Case of` in place

```4d
// WRONG — still declares $platform and branches on constants, only the fetch command changed
var $platform : Integer
If (Is macOS)
	$platform:=Mac OS
End if 
Case of 
	: ($platform=Mac OS)
		...
End case 
```

**Why:** This defeats the purpose of the simplification. Branch on the boolean command
directly.

### ❌ Guessing a token for the replacement command

```4d
// WRONG — invented token
Is macOS:C9999
```

**Why:** Per `startup.instructions.md`, never invent token numbers. Omit the token
entirely; 4D resolves the plain name and adds the correct token on save.

### ❌ Assuming every `_o_`/`_O_`-prefixed command has a direct one-line replacement

**Why:** Some compatibility commands map to a completely different mechanism (e.g.
`_o_Object Accept action` maps to a form JSON property, not another method-level command).
Always check what category of replacement applies — command-for-command, or
command-for-declarative-property — before editing.

### ❌ Silently keeping deprecated commands "because they still work"

**Why:** Deprecated commands may be removed in a future 4D version, and they are
excluded from new documentation and examples, making the code harder to maintain. If a
project's `compatibilityVersion` already implies a modern floor (v17+, or 20 R7+ for
`C_*`/`Get localized string`), there is no compatibility reason left to keep the legacy
form.

---

## Checklist

- [ ] Searched for `_o_`/`_O_`-prefixed commands across all `.4dm` files
- [ ] Each match's replacement confirmed on the 4D command reference (not guessed)
- [ ] Output-parameter variables removed once no longer needed (e.g. `$platform`)
- [ ] `Case of` / constant comparisons simplified to direct boolean checks where the
      replacement command is a boolean (e.g. `Is macOS`, `Is Windows`)
- [ ] Declarative `"action"` used in form JSON instead of `OBJECT SET ACTION` with `_o_`
      constants, where the action can be expressed statically
- [ ] No invented/guessed tokens introduced on replacement commands
- [ ] Cross-referenced `variable.declarations.instructions.md`, `localisation.instructions.md`,
      and `startup.instructions.md` so deprecated-command migrations aren't duplicated or
      contradicted across instruction files

---

## References

- 4D command reference (check each page for a "Deprecated" notice): https://developer.4d.com/docs/commands/
- `Is macOS`: https://developer.4d.com/docs/commands/is-macos
- `Is Windows`: https://developer.4d.com/docs/commands/is-windows
- Simplified commands for cleaner codebase: https://blog.4d.com/simplified-commands-for-cleaner-codebase/
- Menu/form standard actions: https://developer.4d.com/docs/Menus/properties
