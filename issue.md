# Dashboard Web Refactor & Update

## 1. Best Practice Refactor
**Goal:** Clean code. Separation of concerns.
**Action:**
- Move `_buildUserHeader` from `dashboard_page_web.dart` to standalone widget `user_header_sidebar.dart`.
- Extract `_handleMenuTap` logic from `honeycomb_menu.dart` to provider or controller. UI must stay dumb. Use `const` everywhere possible.

## 2. Bugs & Solutions
**Bug 1:** Infinite loading dialog. If `getSsoTicket()` fails early, `Navigator.of(context).pop()` never runs.
**Solution:** Move `Navigator.of(context).pop()` to `finally` block in `_handleMenuTap`.

**Bug 2:** Async gap context warning. `BuildContext` used after await.
**Solution:** Cache provider instance before await. Check `if (!context.mounted) return;` before showing snackbar or popping dialog.

## 3. Feature Tasks
**Task A: Remove Center Hexagon Hover Scale**
- Modify `EntranceHexCell` in `honeycomb_menu.dart`.
- Add `bool disableHoverScale` parameter.
- Pass `disableHoverScale: true` when `item['type'] == 'center'`.
- In `EntranceHexCell` build, ignore `AnimatedScale` (force scale 1.0) if flag true.

**Task B: Header to Left Sidebar**
- Modify `dashboard_page_web.dart`.
- Change base layout from `Column` to `Row`.
- Redesign `_buildUserHeader` to vertical sidebar format. Wrap in fixed-width container.

**Task C: Increase Hexagon Size**
- Modify `dashboard_page_web.dart`.
- Change `hexSize: 75.0` in `HoneycombMenu` to `110.0` (or appropriate larger value).

## Notes for Implementer
- Need docs? Use Dart MCP (`mcp_dart-mcp-server_...` tools).
- Terminal commands: Must use `fvm`. Example: `fvm flutter pub get`.
- No new libraries needed for this task. Native Flutter + existing packages sufficient.
- Final step: Run `fvm flutter analyze`. Fix all warnings. Zero errors allowed.
