# GreyLearn — Modular Architecture Migration

> Completed: May 11, 2026  
> Author: GitHub Copilot

---

## Overview

This document explains every decision made during the conversion of the GreyLearn iOS app from a **monolithic single-target structure** to a **modular Swift Package Manager (SPM) architecture** using 10 local packages.

---

## Why Modular Architecture?

| Benefit | Explanation |
|---|---|
| **Faster builds** | Only changed modules recompile; untouched packages are cached. |
| **Clear ownership** | Each team/feature owns its package. Boundaries are enforced by the compiler. |
| **Enforced `public` API** | Types must be explicitly `public` to cross module boundaries — accidental coupling is impossible. |
| **Testability** | Domain logic and feature ViewModels can be tested independently, without the full app or SwiftUI running. |
| **Scalability** | New features are added as new packages, not as folders in an ever-growing target. |
| **Previews** | Feature packages can be previewed and developed in isolation. |

---

## Repository Structure After Migration

```
GreyLearn/                        ← Xcode project root
├── GreyLearn.xcodeproj/
├── GreyLearn/                    ← Main app target (thin shell)
│   ├── App/
│   │   └── GreyLearnApp.swift    ← Composition root — wires all packages together
│   ├── Coordination/
│   │   └── AppRouteView.swift    ← Route → View mapping (imports all feature pkgs)
│   ├── Resources/                ← Assets.xcassets + Fonts (stay in main bundle)
│   └── Info.plist
├── Packages/                     ← All local SPM packages live here
│   ├── Core/
│   ├── Domain/
│   ├── DesignSystem/
│   ├── AppCoordination/
│   ├── FeatureLaunch/
│   ├── FeatureLogin/
│   ├── FeatureHome/
│   ├── FeaturePath/
│   ├── FeatureProfile/
│   └── FeatureChat/
├── GreyLearnTests/               ← Updated to import Domain + FeatureHome
└── GreyLearnUITests/
```

---

## Module Dependency Graph

```
                 GreyLearnApp (app target)
                        │
       imports all feature packages + AppCoordination
                        │
     ┌──────────────────┼──────────────────────────────┐
     ▼                  ▼                              ▼
FeatureLaunch    FeatureLogin              FeatureHome / FeaturePath
FeatureProfile   FeatureChat               (and other features)
     │                  │                              │
     └──────────────────┼──────────────────────────────┘
                        ▼
                 AppCoordination  ←──── all coordinators, routes, AppDependencies
                  /         \
                 ▼           ▼
             Domain      DesignSystem
              /               \
             ▼                 ▼
           Core              Core
```

**Rules:**
- `Core` has **no dependencies** (pure Foundation)
- `Domain` depends on `Core` only
- `DesignSystem` depends on `Core` only (no Domain knowledge)
- `AppCoordination` depends on `Domain` + `DesignSystem`
- Feature packages depend on `AppCoordination`, `Domain`, `DesignSystem`
- The **main app target** is the only place that imports ALL feature packages simultaneously

---

## Package Details

### `Core`
**Path:** `Packages/Core`  
**Dependencies:** none  
**Contents:**
- `Array+Extension.swift` — `chunked(into:)` helper
- `Date+Extension.swift` — `daysFromNow(_:)`, `timeOfDayGreeting`, `greeting(withName:)`
- `String+Extension.swift` — `firstLetter`

**Why separate?** These are Foundation-only utilities with no SwiftUI, no business logic, and no UI. Keeping them isolated means any package (including server-side Swift targets in the future) can import them without dragging in SwiftUI.

---

### `Domain`
**Path:** `Packages/Domain`  
**Dependencies:** `Core`  
**Contents:**
- `Entities/` — `User`, `Course`, `Module`, `Section`, `Topic`, `ChatMessage`, `Streak`, `ModuleStatus`, `UserStatus`
- `Repository/` — `CourseRepository` (protocol), `MockCourseRepository`, `LocalRepository`
- `Storage/` — `LocalStorageManager`, `StorageKeys`

**Why separate?** Domain types are the language of the app. Every other module speaks in terms of `User`, `Course`, `Module`, etc. Having them in one place avoids circular imports and makes it trivial to write tests that only import `Domain`.

---

### `DesignSystem`
**Path:** `Packages/DesignSystem`  
**Dependencies:** `Core`  
**Contents:**
- `Colors/Color+Extensions.swift` — Strongly-typed `Color.greyPurple`, `Color.greyLightGray`, etc.
- `Typography/AeonikFont.swift`, `AppTypography.swift`, `FontHelper.swift`
- `Components/AppTextStyle.swift` + `AppText` — unified text view
- `Components/PrimaryButton.swift`
- `Components/TaskProgressView.swift`
- `Modifiers/CustomBackButtonModifier.swift` — **refactored** (see below)
- `Extensions/View+Extension.swift`

**Key refactor — `CustomBackButtonModifier`:**  
The original modifier read `@Environment(AppCoordinator.self)` directly. This would have created a circular dependency (`DesignSystem` → `AppCoordination` → `DesignSystem`). 

**Solution:** The modifier now takes an `onPop: () -> Void` closure:
```swift
.customBackButton(onPop: { coordinator.pop() })
```
Feature views pass their coordinator's `pop()` action explicitly. `DesignSystem` stays free of any coordination concerns.

**Assets & Fonts:** The `.xcassets` catalog and font `.ttf` files remain in the main app target's `Resources/` folder. SPM packages reference colors and fonts by **string name** (`Color("grey-purple")`, `Font.custom("Aeonik-Bold", size: 34)`). SwiftUI resolves these from `Bundle.main` at runtime, so no files need to move. The `Color+Extensions.swift` file provides compile-time-safe typed accessors.

---

### `AppCoordination`
**Path:** `Packages/AppCoordination`  
**Dependencies:** `Domain`, `DesignSystem`  
**Contents:**
- `Coordinator.swift` — base `Coordinator` protocol
- `AppCoordinator.swift` — root coordinator (navigation path, login state, user)
- `AppDependencies.swift` — DI container for the app coordinator
- `Routes/AppRoute.swift`, `HomeRoute.swift`, `PathRoute.swift`, `PathSheetRoute.swift`
- `Coordinators/LoginCoordinator.swift`, `HomeCoordinator.swift`, `PathCoordinator.swift`, `ProfileCoordinator.swift`, `ChatCoordinator.swift`

**Key design decision — `PathSheetRoute.makeView()` removed:**  
The original `PathSheetRoute` had a `makeView()` method that returned `BadgeEarnedView`. This forced `AppCoordination` to import `FeaturePath`, creating a circular dependency. 

**Solution:** `PathSheetRoute` is a pure data enum (no SwiftUI). `PathView` (in `FeaturePath`) switches on `coordinator.presentedRoute` directly and creates `BadgeEarnedView` inline. `AppCoordination` stays clean.

**Feature coordinators here, not in feature packages:**  
All coordinators (`HomeCoordinator`, `LoginCoordinator`, etc.) live in `AppCoordination` rather than in their respective feature packages. This is because:
1. Every coordinator holds a reference to `AppCoordinator` (a type in `AppCoordination`)
2. Putting `LoginCoordinator` in `FeatureLogin` would require `FeatureLogin` → `AppCoordination`, which is fine, but `AppCoordinator` would then need to hold `LoginCoordinator` (back in `FeatureLogin`) — circular.
3. Keeping all coordinators in one package avoids the cycle entirely.

---

### `FeatureLaunch`
**Path:** `Packages/FeatureLaunch`  
**Dependencies:** `DesignSystem`  
**Contents:** `LaunchScreenView.swift`

Simplest package — no coordinators, no view models. Pure presentation.

---

### `FeatureLogin`
**Path:** `Packages/FeatureLogin`  
**Dependencies:** `AppCoordination`, `Domain`, `DesignSystem`  
**Contents:**
- `Presentation/LoginView.swift`
- `Presentation/LoginViewModel.swift`
- `DI/LoginDependencies.swift`

`LoginDependencies` lives here (not in `AppCoordination`) because it holds a `LoginViewModel` — a type that only `FeatureLogin` knows about.

---

### `FeatureHome`
**Path:** `Packages/FeatureHome`  
**Dependencies:** `AppCoordination`, `Domain`, `DesignSystem`  
**Contents:**
- `Presentation/HomeView.swift`
- `Presentation/HomeViewModel.swift`
- `Presentation/CustomViews/` — `HomeHeaderCard`, `MascotGreetingCard`, `TodayTaskCard`, `ActiveLearningCard`, `BadgesCard`
- `DI/HomeDependencies.swift`

**Key change — `HomeView` no longer owns `NavigationStack`:**  
The original `HomeView` wrapped everything in a `NavigationStack` and registered `navigationDestination(for: AppRoute.self)`. This forced `HomeView` to render `AppRouteView` — a type only the main app knows about (because it imports all feature packages).

**Solution:** `NavigationStack` and `navigationDestination` moved to `GreyLearnApp.swift`. `HomeView` is now a pure content view (a `ScrollView`). The app passes `HomeCoordinator` via environment separately from `AppCoordinator`, so `HomeView` only needs `FeatureHome`'s own coordinator.

---

### `FeaturePath`
**Path:** `Packages/FeaturePath`  
**Dependencies:** `AppCoordination`, `Domain`, `DesignSystem`, `Core`  
**Contents:**
- `Presentation/PathView.swift`
- `Presentation/CustomViews/ModuleBadgeAnchorPreferenceKey.swift` + `CourseProgressView`
- `Presentation/CustomViews/LearningPathConnector.swift`
- `Presentation/CustomViews/BadgeEarnedView.swift`

`ModuleBadgeAnchorPreferenceKey` and `CourseProgressView` moved from `Utilities/Components/Views/` to `FeaturePath` because they are path-specific — they use `Module` domain types and exist solely to power `PathView`.

---

### `FeatureProfile`
**Path:** `Packages/FeatureProfile`  
**Dependencies:** `AppCoordination`, `Domain`, `DesignSystem`  
**Contents:** `Presentation/ProfileView.swift`

---

### `FeatureChat`
**Path:** `Packages/FeatureChat`  
**Dependencies:** `AppCoordination`, `Domain`, `DesignSystem`  
**Contents:**
- `Presentation/ChatView.swift`
- `Presentation/CustomViews/ChatBubble.swift`

---

## Main App Target Changes

### `GreyLearnApp.swift` (rewritten)
The app entry point is now the **composition root** — the only place that knows about all packages at once:

1. Creates the single `AppCoordinator` instance
2. Creates all feature coordinators, passing the shared `AppCoordinator` to each
3. Owns the `NavigationStack` (with `navigationDestination`)
4. Shows the launch overlay

```swift
init() {
    let app = AppCoordinator()
    _appCoordinator   = State(wrappedValue: app)
    _loginCoordinator = State(wrappedValue: LoginCoordinator(appCoordinator: app))
    _homeCoordinator  = State(wrappedValue: HomeCoordinator(appCoordinator: app))
}
```

### `AppRouteView.swift` (rewritten)
This file **intentionally stays in the main app target** — it is the only file that imports every feature package (`FeatureChat`, `FeaturePath`, `FeatureProfile`) and maps `AppRoute` enum cases to concrete SwiftUI views. Moving it into any package would require that package to import all others, creating a circular dependency.

Feature coordinators for pushed views (`PathCoordinator`, `ChatCoordinator`, `ProfileCoordinator`) are created inline here since they are stateless wrappers around the shared `AppCoordinator`.

---

## Xcode Project Changes

The `project.pbxproj` was automatically updated to:

1. Add **`XCLocalSwiftPackageReference`** entries pointing to each `Packages/<Name>` directory (relative paths).
2. Add **`XCSwiftPackageProductDependency`** entries for each product consumed by the `GreyLearn` app target and the `GreyLearnTests` target.
3. Add **`PBXBuildFile`** entries linking each product into the Frameworks build phase.
4. Add a **`packageReferences`** array to the `PBXProject` section.
5. Populate `packageProductDependencies` in both the `GreyLearn` and `GreyLearnTests` native targets.

**App target links:** `AppCoordination`, `Domain`, `FeatureLaunch`, `FeatureLogin`, `FeatureHome`, `FeaturePath`, `FeatureProfile`, `FeatureChat`  
**Test target links:** `Domain`, `FeatureHome`

> Transitive dependencies (`Core`, `DesignSystem`) are resolved automatically by SPM and do not need to be listed in the app target's explicit linkage.

---

## Test Changes

All test files previously used `@testable import GreyLearn`. Since the types they test are now in separate public modules, the imports were updated:

| Test File | New Import |
|---|---|
| `CourseTests.swift` | `import Domain` |
| `CouseRepositoryTests.swift` | `import Domain` |
| `LocalRepositoryTests.swift` | `import Domain` |
| `ModuleTests.swift` | `import Domain` |
| `HomeViewModelTest.swift` | `import Domain` + `import FeatureHome` |

Because all types are now `public`, `@testable import` is no longer needed (and would not work across module boundaries anyway).

---

## What to Do in Xcode After Opening

1. **Open `GreyLearn.xcodeproj`** — Xcode will automatically detect the `packageReferences` in the pbxproj and resolve all local packages. Wait for the "Resolving Package Dependencies" spinner to finish.

2. **If packages fail to resolve:** Go to **File → Packages → Reset Package Caches**, then build again.

3. **Remove old source files from the app target** (they are still on disk in `GreyLearn/` but the same types now live in packages — keeping both will cause duplicate symbol errors):
   - Select the following groups in the Xcode navigator and delete the **references** (not the files) OR keep them and use the File Inspector to **uncheck "Target Membership"** for the GreyLearn target:
     - `GreyLearn/Coordination/` (AppCoordinator, AppRoute, AppRouteView, Coordinator — the new versions are in the packages)
     - `GreyLearn/DI/`
     - `GreyLearn/Entities/`
     - `GreyLearn/Repository/`
     - `GreyLearn/Features/` (all feature subdirectories)
     - `GreyLearn/Utilities/` (all except anything app-specific)
   
   **Keep in the app target:**
   - `GreyLearn/App/GreyLearnApp.swift`
   - `GreyLearn/Coordination/AppRouteView.swift`
   - `GreyLearn/Resources/` (fonts, assets)
   - `GreyLearn/Info.plist`

4. **Build** (`⌘B`) — all packages should compile in dependency order (Core → Domain → DesignSystem → AppCoordination → Feature packages → App).

> **Note:** The project uses `PBXFileSystemSynchronizedRootGroup` (Xcode 16+ file-system sync) for the `GreyLearn/` folder, which means ALL files in that folder are automatically included. You'll need to either delete the old source files from disk OR add explicit exclusion rules in the project's File System Synchronized Groups settings to avoid duplicate symbols.

---

## Access Control Summary

Every type/function that crosses a module boundary is marked `public`. Types that are implementation details stay `internal` (the default). This enforces the module API surface at compile time:

| What | Access |
|---|---|
| Entity structs (`User`, `Course`, etc.) | `public` |
| Repository protocols | `public` |
| Mock implementations | `public` (needed by tests and DI) |
| `LocalStorageManager`, `LocalRepository` | `public` |
| All coordinators | `public` |
| All SwiftUI views | `public` |
| All view models | `public` |
| Private helper methods within a view | `private` (unchanged) |

---

## Future Improvements

1. **Move `AppRouteView` to a dedicated `AppShell` package** by defining a `ViewFactory` protocol in `AppCoordination` that feature packages conform to. The app target registers its factories, eliminating the last multi-import file.

2. **Add test targets to individual packages** by adding a `.testTarget(...)` in each `Package.swift`. This enables testing each module in strict isolation, without the host app's `Bundle.main`.

3. **Add a `Networking` package** for real API calls, injected via `CourseRepository` protocol — no feature package needs to change.

4. **Enable `ENABLE_TESTING` per package** — use `swift build --enable-code-coverage` per-package for CI coverage reports scoped to each module.

5. **Consider `FeatureHome` → `HomeShell`** split: separate the `HomeViewModel` (pure logic, no SwiftUI) into a `HomeCore` package and keep SwiftUI views in `FeatureHome`, enabling true headless unit testing.
