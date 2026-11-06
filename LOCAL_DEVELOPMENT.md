# Local development

Personal fork: <https://github.com/Diabl0570/InputConfig>

Upstream: <https://github.com/ryleighnewman/InputConfig>

The `local-development` branch adds a local build command and splits expressions
that Xcode 26.6 could not type-check, in the built-in test bench and SwiftUI views.
Their conditions and outputs are preserved. The MIT license remains unchanged.
The starting upstream commit is
`958bdd97ceecb182004b3d7d8521761b5a7e7756`, version 1.8, build 34.

## Build and open

Requirements: macOS 14 or newer and Xcode 26 or newer, selected as the active
developer directory.

Run from the repository root:

```sh
./scripts/build-local.sh
open "build/local/InputConfig Local.app"
```

The script uses Xcode's Debug configuration and creates an app at
`build/local/InputConfig Local.app`. It signs the app and its bundled helper
locally with ad-hoc signatures; an Apple developer certificate or App Store
account is not needed for this build. It verifies both signatures before returning.
This is a development build for this Mac, not a notarized distribution build.

The app's bundle identifier is `io.github.diabl0570.InputConfig`. The distinct
identifier keeps it separate from the upstream App Store app and its settings.
The script replaces only its generated app on subsequent builds. Quit the local
app before rebuilding it.

On first use, macOS may request Accessibility and Bluetooth access. Grant those
yourself in System Settings when ready to test your controller. Rebuilding an
ad-hoc-signed app can require granting Accessibility again. No system permissions
are changed by the build script.

For the first controller test, pause the BetterTouchTool controller mapping,
connect the PS5 or Stadia controller, and check that InputConfig's visualizer
registers its buttons and sticks before activating a preset.

## Edit in Xcode

```sh
open InputConfig.xcodeproj
```

Use the build script after editing. If you prefer Xcode's Run button, select your
own team and change the bundle identifier in Signing & Capabilities first. The
upstream project file still contains the original developer's signing settings.

## Git remotes

- `origin` is your fork, where your changes belong.
- `upstream` is the original project, for fetching future updates.

```sh
git fetch upstream
git switch local-development
git merge upstream/main
```

Review the merge, rebuild, and test before pushing it to your fork. Retain
`LICENSE` and the existing third-party notices when distributing modified copies.

## Scope and checks

- Public ports changed: `scripts/build-local.sh`, the local build command. The
  expression refactors do not change app interfaces.
- Protected paths touched: none. The generated local app retains the upstream
  sandbox entitlements. System permissions and mapping behaviour are unchanged.
- Evidence: Xcode build and code-signature verification; controller hardware
  requires a separate interactive test.

Verified on 6 November 2026 with Xcode 26.6: the Debug build succeeded for Apple
silicon, both app and helper signatures passed `codesign --verify --deep --strict`,
and the app opened to its welcome screen. The embedded Steam Controller helper
contains both arm64 and x86_64 architectures. The build still reports upstream
compiler warnings. Controller input, permissions, and the built-in test bench
were not exercised.
