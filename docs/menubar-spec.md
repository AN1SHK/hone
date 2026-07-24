# HONE — Mac menubar app: build spec

*The native layer. The browser extension catches tab-switching; this catches **app**-switching — Cmd+Tab to Slack, Discord, Messages — system-wide. Same mechanic, whole machine.*

---

## Why native (and why it's the harder, more defensible build)

A browser extension can only see the browser. The moment you Cmd+Tab out to Slack, it's blind. Only a native macOS app can watch the *frontmost application* change and intervene. It's meaningfully harder to build than a web page or extension — which, per the Entry commandment, is exactly why it's a better moat.

## First principle

Same as the extension: **the tool catches the act of leaving your work, not a list of apps.** You pin the app you're working in; switching away during a block triggers a friction overlay and counts a "catch."

---

## Core mechanic

1. Start a block (menubar click or global hotkey). The current frontmost app becomes the **work app** (stored by bundle ID).
2. While the block runs, listen for the frontmost app changing.
3. When you activate any app that isn't the work app → show a full-screen friction overlay: *"That was the reflex, not the work. 23:41 left. ← Back to [work app]."* Count a catch.
4. "Back to work" reactivates the pinned app and dismisses the overlay. Strict mode holds an 8-second friction pause first.

## The one API that makes it possible

`NSWorkspace.didActivateApplicationNotification` — fires every time the frontmost app changes, handing you the `NSRunningApplication`. This is the native equivalent of the extension's `tabs.onActivated`. No Accessibility permission required to observe it.

```swift
let ws = NSWorkspace.shared
ws.notificationCenter.addObserver(
    forName: NSWorkspace.didActivateApplicationNotification,
    object: nil, queue: .main
) { note in
    guard block.active,
          let app = note.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication
    else { return }
    if app.bundleIdentifier != block.workAppBundleID {
        block.catches += 1
        showInterceptOverlay(returningTo: block.workAppBundleID)   // friction + "Back to work"
    }
}

// "Back to work"
func focusWork(_ bundleID: String) {
    NSWorkspace.shared.runningApplications
        .first { $0.bundleIdentifier == bundleID }?
        .activate(options: [.activateAllWindows])
}
```

## Components

- **Menubar item** — `MenuBarExtra` (SwiftUI, macOS 13+). Title shows minutes left (e.g. "24"). Click opens a popover: intention field, duration (25/50/90), Start/Stop, strict toggle, streak, and an "Open HONE" button that launches the web dashboard.
- **App-switch observer** — the `NSWorkspace` listener above. The heart.
- **Intercept overlay** — a borderless `NSWindow`, `level = .screenSaver`, `collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]`, clear background, SwiftUI content via `NSHostingView`. Covers the distracting app with the checkpoint. Strict mode = an 8-second countdown before a "Stay here anyway" unlocks.
- **Timer + notifications** — a countdown to `endTime`; `UNUserNotificationCenter` for the halfway "reactivate" nudge and the completion chime.
- **Global hotkey** — `KeyboardShortcuts` (Sindre Sorhus, Swift Package) for a system-wide start/stop, e.g. ⌥⇧F.
- **Persistence** — a `Codable` model in Application Support (or `UserDefaults`): `block { active, endTime, minutes, intention, workAppBundleID, catches }` and `stats { blocks, minutes, catches, days }`. Mirror the extension's schema so they can share a format later.
- **Agent app** — set `LSUIElement = true` (no Dock icon, menubar only). **Launch at login** via `SMAppService.mainApp.register()`.

## Stack

Swift + SwiftUI + a little AppKit. Xcode project. One SPM dependency (`KeyboardShortcuts`). macOS 13+. No sandbox needed for v1 (observing app activation and drawing an overlay don't require entitlements); for distribution, sign with a Developer ID and notarize.

## Honest limits (design around these, don't fight them)

- **You can't forcibly "kill" another app.** macOS won't allow hard-blocking without heavy measures. The realistic levers are (a) the friction overlay covering the screen, and (b) `NSRunningApplication.hide()` to tuck the distracting app away. That's enough — the point is to interrupt autopilot, not jail the user.
- **Websites are one app to macOS.** The menubar app sees "Chrome is frontmost," not which site. So **pair the two**: the menubar app owns app-switching; the browser extension owns tab/site-switching inside Chrome. Together they cover the whole machine. (Full site-level blocking natively = a Network Extension content filter — heavy, entitlement-gated, save for later.)
- **No screen capture, no reading other apps' content** — not needed, and avoids scary permissions.

## Scope

**v1** — app-switch interception overlay, block timer, menubar UI, global hotkey, launch-at-login, shared stats with the web dashboard.
**Later** — Network Extension for native site filtering, calendar-aware auto-blocks, phone companion, and merging the extension + menubar into one account/data layer.

## Build/run

1. New Xcode macOS App (SwiftUI). Set `LSUIElement = YES` in Info.plist.
2. Add `KeyboardShortcuts` via Swift Package Manager.
3. Implement the `NSWorkspace` observer, the overlay window, the `MenuBarExtra` popover, the timer, and persistence.
4. Run from Xcode for personal use (self-signed). To share it: archive → notarize → distribute the signed `.app`.

*This spec is enough to hand to an AI coding tool or a Swift dev and get a working v1. The core is ~200 lines; the observer + overlay is the whole trick.*
