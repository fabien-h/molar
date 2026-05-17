# Molar

A simple iOS app that guides a child through a thorough tooth-brushing routine:
**14 zones × 10 seconds** with a live teeth diagram, countdown, and haptic / audio cue between zones.

## Zones

| # | Area | Surface |
|---|---|---|
| 1 | Right front teeth (top + bottom) | Outside |
| 2 | Left front teeth (top + bottom) | Outside |
| 3 | Top front teeth | Inside |
| 4 | Bottom front teeth | Inside |
| 5 | Right back teeth (top + bottom) | Outside |
| 6 | Left back teeth (top + bottom) | Outside |
| 7 | Top left back teeth | Chewing |
| 8 | Top right back teeth | Chewing |
| 9 | Bottom left back teeth | Chewing |
| 10 | Bottom right back teeth | Chewing |
| 11 | Top left back teeth | Inside |
| 12 | Top right back teeth | Inside |
| 13 | Bottom left back teeth | Inside |
| 14 | Bottom right back teeth | Inside |

Total: 2 min 20 s.

## Getting started

The Xcode project is generated from `project.yml` with [XcodeGen](https://github.com/yonaskolb/XcodeGen):

```bash
xcodegen generate
open Molar.xcodeproj
```

Then build & run on the iOS simulator or a device (target: iOS 17+).

## Project layout

```
Molar/
├── MolarApp.swift          # @main entry point
├── ContentView.swift       # Routes between Start / Brushing / Completion
├── Models/
│   └── BrushingZone.swift  # The 14 zones + surface metadata
├── ViewModels/
│   └── BrushingSession.swift  # Timer state machine (@Observable)
└── Views/
    ├── StartView.swift
    ├── BrushingView.swift
    ├── CompletionView.swift
    └── TeethDiagramView.swift  # Stylized teeth + brush overlay
```

## Customizing

- Change zone duration: `BrushingSession.secondsPerZone`
- Edit / reorder zones: `BrushingZone.all`
- Tweak visuals: `TeethDiagramView` (teeth shape, colors, brush animation)
- Localize: replace English strings — `BrushingZone.name` / `.hint`, plus UI labels in views
