# iOS Modular Architecture — The Complete Hands-On Guide

> **Who this is for:** iOS developers who want to break a monolithic Xcode project into independent, compiler-enforced modules using Swift Package Manager (SPM) local packages.  
> **Tools required:** Xcode 15+, Swift 5.9+, macOS Sonoma or later.  
> **After reading this:** You will be able to modularize any iOS application from scratch.

---

## Table of Contents

1. [Why Modularize?](#1-why-modularize)
2. [Core Concepts](#2-core-concepts)
3. [The Module Dependency Graph](#3-the-module-dependency-graph)
4. [Choosing What Goes in Each Module](#4-choosing-what-goes-in-each-module)
5. [Creating a Local SPM Package — Step by Step](#5-creating-a-local-spm-package--step-by-step)
6. [Writing Package.swift — Full Reference](#6-writing-packageswift--full-reference)
7. [Access Control — The Most Important Rule](#7-access-control--the-most-important-rule)
8. [Adding Local Packages to Your Xcode Project](#8-adding-local-packages-to-your-xcode-project)
9. [Migrating Existing Code — File by File](#9-migrating-existing-code--file-by-file)
10. [Handling Common Pitfalls](#10-handling-common-pitfalls)
11. [Testing in a Modular Architecture](#11-testing-in-a-modular-architecture)
12. [The Composition Root Pattern](#12-the-composition-root-pattern)
13. [A Complete Real-World Example](#13-a-complete-real-world-example)
14. [Module Architecture Patterns Reference](#14-module-architecture-patterns-reference)
15. [Checklist — Before You Ship](#15-checklist--before-you-ship)

---

## 1. Why Modularize?

Before investing time in this process, understand the concrete benefits. The table below compares what life looks like before and after modularization.

| Concern | Monolith | Modular |
|---|---|---|
| **Build times** | Full rebuild on any change | Only changed modules recompile |
| **Team ownership** | Any file can depend on any other | Module boundaries are compiler-enforced |
| **Accidental coupling** | Easy; nothing stops it | Impossible unless you explicitly `import` |
| **Feature isolation** | Hard; shared globals everywhere | Each feature is an independent library |
| **Testability** | Entire app must be linked to test one view model | Test `Domain` alone with no SwiftUI |
| **Previews** | May break when other files are broken | Feature package Previews work in isolation |
| **Onboarding** | New developer must understand everything | New developer owns one package |
| **Reuse across targets** | Copy-paste | `import PackageName` in any target |

### When NOT to modularize

- Very small apps (< 20 Swift files) — the overhead isn't worth it.
- Solo projects with no build time problems.
- Prototypes / proof-of-concept work.

---

## 2. Core Concepts

### 2.1 What is a Module?

A **module** in Swift is a single unit of code distribution. When you write `import Foundation`, `import SwiftUI`, or `import MyPackage`, you're importing a module. Each module has its own namespace and its own `public`/`internal` boundary.

In Xcode, modules come from:
- **Framework targets** (`.framework`)
- **Swift Package Manager targets** (`.swiftmodule`)
- **System libraries**

For modular iOS apps we use **SPM local packages** — they're the simplest, require no extra build system, and integrate perfectly with Xcode.

### 2.2 What is a Local Package?

A local package is a directory containing a `Package.swift` manifest file and source code. Unlike remote packages (fetched from GitHub), a local package lives inside your repository:

```
MyApp/
├── MyApp.xcodeproj/
├── MyApp/                   ← main app target source
└── Packages/                ← all local packages live here
    ├── Core/
    │   ├── Package.swift
    │   └── Sources/
    │       └── Core/
    │           └── MyFile.swift
    └── Domain/
        ├── Package.swift
        └── Sources/
            └── Domain/
```

### 2.3 What is a Dependency Graph?

Every module can depend on other modules. If `FeatureLogin` imports `Domain`, then `Domain` is a **dependency** of `FeatureLogin`. The full picture of who depends on whom is the **dependency graph**.

The rules:
- **No cycles.** If `A` depends on `B`, then `B` must NOT depend on `A`.
- **Dependencies are transitive.** If `A` depends on `B` and `B` depends on `C`, then `A` can use types from `C` only if `C` re-exports them or `A` also explicitly imports `C`.
- **The main app target is the root.** It depends on everything; nothing depends on it.

---

## 3. The Module Dependency Graph

This is the most important step. You design the graph BEFORE writing a single line of code.

### 3.1 Standard Layer Cake for iOS Apps

The most common architecture looks like this (arrows mean "depends on / imports"):

```
┌─────────────────────────────────────────────────────────┐
│                    App Target (thin)                     │
│         GreyLearnApp.swift  +  AppRouteView.swift        │
└───┬──────────┬───────────┬──────────┬───────────┬───────┘
    │          │           │          │           │
    ▼          ▼           ▼          ▼           ▼
Feature    Feature     Feature    Feature    Feature
 Home       Login       Path      Profile     Chat
    │          │           │          │           │
    └──────────┴───────────┴──────────┴───────────┘
                           │
                           ▼
                    AppCoordination
                  (all coordinators,
                   routes, app-level DI)
                    /             \
                   ▼               ▼
               Domain          DesignSystem
           (entities,         (colors, fonts,
            repos,             shared UI
            storage)           components)
                \                  /
                 ▼                ▼
                        Core
                  (Foundation-only
                   helpers, extensions)
```

### 3.2 The Golden Rules

**Rule 1 — Lower layers know nothing about upper layers.**  
`Domain` never imports `DesignSystem`, `AppCoordination`, or any Feature package. It only knows about `Core`.

**Rule 2 — Feature packages never import each other.**  
`FeatureHome` never imports `FeatureLogin`. If they need to share something, that shared thing belongs in a lower layer (`Domain` or `DesignSystem`).

**Rule 3 — The app target is the only place that imports everything.**  
`GreyLearnApp.swift` can import `FeatureHome`, `FeatureLogin`, `FeatureChat`, etc. No package can do this.

**Rule 4 — Design the graph on paper first.**  
Draw it out before you create any packages. Changing the graph later (to break a cycle) requires moving files between packages, which is painful.

### 3.3 How to Design Your Own Graph

Answer these questions for your app:

**Step 1:** What are your pure data types? (Models, entities, DTOs)  
→ These go in `Domain` or `Core`. They have no SwiftUI, no UI logic.

**Step 2:** What UI components are used in more than one feature?  
→ These go in `DesignSystem`. (Buttons, labels, color tokens, fonts.)

**Step 3:** What types does navigation depend on? (Route enums, coordinators)  
→ These go in `AppCoordination`. This package imports `Domain` (routes carry model types like `Course`) and `DesignSystem` (coordinators may need UI types).

**Step 4:** What is unique to each feature?  
→ Each feature gets its own package: `FeatureX`. It imports `AppCoordination`, `Domain`, and `DesignSystem`.

**Step 5:** What is the absolute minimum that must stay in the app target?  
→ `@main` entry point + any file that imports ALL feature packages (e.g., a route→view mapping view like `AppRouteView`).

---

## 4. Choosing What Goes in Each Module

### 4.1 The `Core` Package

**What belongs here:**
- Pure Swift extensions on standard library types (`Array`, `String`, `Date`, `Int`, etc.)
- General-purpose utilities with zero dependencies
- No `import SwiftUI`, no `import UIKit`, no `import Combine`

**What does NOT belong here:**
- Anything domain-specific (e.g., `User`, `Course`)
- Anything that touches the network, storage, or UI

**Example contents:**
```
Core/Sources/Core/
├── Array+Extension.swift     // chunked(into:), etc.
├── Date+Extension.swift      // daysFromNow(_:), timeOfDayGreeting
└── String+Extension.swift    // firstLetter, isValidEmail, etc.
```

### 4.2 The `Domain` Package

**What belongs here:**
- All entity / model structs (`User`, `Product`, `Order`, etc.)
- Repository protocols (`UserRepository`, `CourseRepository`)
- Mock / stub implementations of those protocols
- Storage helpers (`UserDefaults` wrappers, `KeychainManager`)
- Error types

**What does NOT belong here:**
- Any SwiftUI view
- Any view model
- Any coordinator

**Why protocols here?**  
Your feature packages code against the protocol. The real implementation (network, database) can be swapped in without touching the feature at all. This is the Dependency Inversion Principle.

```
Domain/Sources/Domain/
├── Entities/
│   ├── User.swift
│   ├── Product.swift
│   └── Order.swift
├── Repository/
│   ├── UserRepository.swift      // protocol
│   ├── MockUserRepository.swift  // for dev/tests
│   └── ProductRepository.swift
└── Storage/
    ├── LocalStorageManager.swift
    └── StorageKeys.swift
```

### 4.3 The `DesignSystem` Package

**What belongs here:**
- Brand colors (as `Color` extensions or a named type)
- Typography (font names, sizes, a `Font` factory)
- Reusable generic UI components: `PrimaryButton`, `AppText`, `LoadingView`
- View modifiers that apply to any view (e.g., `RoundedCard`, `ShimmerEffect`)
- Image / icon helpers

**What does NOT belong here:**
- Anything domain-specific (a component that renders a `User` or `Course`)
- Any coordinator / navigation logic
- Any view model

**The key test:** Can this component be copy-pasted into a completely different app and work? If yes → `DesignSystem`. If no → it belongs in a feature.

```
DesignSystem/Sources/DesignSystem/
├── Colors/
│   └── Color+Extensions.swift     // Color.primaryBlue, etc.
├── Typography/
│   ├── FontHelper.swift
│   └── AppTypography.swift
├── Components/
│   ├── PrimaryButton.swift
│   ├── AppText.swift
│   └── LoadingSpinner.swift
├── Modifiers/
│   └── CardModifier.swift
└── Extensions/
    └── View+Extension.swift
```

**⚠️ Important — Assets & Fonts:**  
Asset catalogs (`.xcassets`) and font files (`.ttf`, `.otf`) registered in the main app's `Info.plist` stay in the **main app target**. Your `DesignSystem` package references them by string name:

```swift
// In DesignSystem package — this works because fonts are in Bundle.main
public extension Color {
    static let primaryBlue = Color("primary-blue")  // resolves from Bundle.main
}
```

If you want assets to live fully inside the package, use SPM resources (see section 6.4).

### 4.4 The `AppCoordination` Package

**What belongs here:**
- The base `Coordinator` protocol
- `AppCoordinator` — owns the navigation path and global state
- All route enums (`AppRoute`, `HomeRoute`, `SettingsRoute`, etc.)
- All concrete coordinator classes (`HomeCoordinator`, `LoginCoordinator`, etc.)
- App-level DI containers (`AppDependencies`)

**What does NOT belong here:**
- Feature-specific DI containers that reference a ViewModel (put those in the feature package)
- Any SwiftUI view
- Any ViewModel

**Why keep all coordinators together?**  
`AppCoordinator` holds references to all feature coordinators. If `HomeCoordinator` lived in `FeatureHome`, you'd need `AppCoordination` → `FeatureHome` (to hold `HomeCoordinator`) AND `FeatureHome` → `AppCoordination` (to use `AppCoordinator`). That's a **cycle**. Keeping all coordinators in `AppCoordination` breaks it.

### 4.5 Feature Packages

Each feature package contains everything needed to display and interact with one feature:

- The feature's SwiftUI `View`(s)
- The feature's `ViewModel`(s) / `ObservableObject`(s)
- Feature-specific sub-views used only within this feature
- Feature-specific DI container (if it references a ViewModel type)

**Example — `FeatureLogin`:**
```
FeatureLogin/Sources/FeatureLogin/
├── Presentation/
│   ├── LoginView.swift
│   └── LoginViewModel.swift
└── DI/
    └── LoginDependencies.swift
```

**Naming conventions:**
- Package name: `FeatureLogin`, `FeatureHome`, `FeatureCheckout`
- Or: `LoginFeature`, `HomeFeature` — pick one style, be consistent.

---

## 5. Creating a Local SPM Package — Step by Step

There are two ways to create a package: via Xcode UI or via the terminal. Both produce the same result.

### Method A — Xcode UI (easiest)

**Step 1:** In Xcode, go to **File → New → Package…**

```
┌─────────────────────────────────────────────────┐
│  File   Edit   View   Navigate   Editor   Product │
│                                                   │
│  New                          ►  File…    ⌘N      │
│  Open…                           Project…         │
│  Open Recent                  ►  Package…  ◄──── │
│  ...                                              │
└─────────────────────────────────────────────────┘
```

**Step 2:** Name the package (e.g., `Core`), choose the save location as your `Packages/` folder inside the project root, and click **Create**.

**Step 3:** Xcode creates this structure automatically:
```
Core/
├── Package.swift
├── Sources/
│   └── Core/
│       └── Core.swift          ← delete this placeholder
└── Tests/
    └── CoreTests/
        └── CoreTests.swift     ← delete if not needed yet
```

**Step 4:** Repeat for every module you need.

### Method B — Terminal (faster for many packages)

```bash
# Navigate to your project root
cd ~/Desktop/MyApp

# Create the Packages directory
mkdir -p Packages

# Create each package
for name in Core Domain DesignSystem AppCoordination FeatureLogin FeatureHome; do
    mkdir -p "Packages/$name/Sources/$name"
    cat > "Packages/$name/Package.swift" << EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "$name",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "$name", targets: ["$name"]),
    ],
    targets: [
        .target(name: "$name"),
    ]
)
EOF
done
```

After running this, add dependencies between packages (see section 6).

---

## 6. Writing Package.swift — Full Reference

`Package.swift` is the manifest file that tells SPM everything about your package. Here is every field explained.

### 6.1 Minimal Package.swift

```swift
// swift-tools-version: 5.9          ← minimum Swift version needed to parse this file
import PackageDescription

let package = Package(
    name: "Core",                     ← the package name (used by Xcode)
    platforms: [.iOS(.v17)],          ← minimum platform version
    products: [
        // What other packages/targets can import from this package
        .library(name: "Core", targets: ["Core"]),
    ],
    targets: [
        // The actual compilation unit
        .target(name: "Core"),        ← sources default to Sources/Core/
    ]
)
```

### 6.2 Package with Dependencies

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
    ],
    dependencies: [
        // Local package — path is relative to THIS Package.swift
        .package(path: "../Core"),

        // Remote package — fetched from GitHub
        // .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                // Must match a product name from the dependency above
                "Core",
            ]
        ),
    ]
)
```

### 6.3 Package with Multiple Products / Targets

A single `Package.swift` can define multiple libraries. This is useful when you want to give consumers fine-grained control over what they import:

```swift
let package = Package(
    name: "Networking",
    products: [
        .library(name: "Networking",    targets: ["Networking"]),
        .library(name: "NetworkingMocks", targets: ["NetworkingMocks"]),
    ],
    targets: [
        .target(name: "Networking"),
        .target(name: "NetworkingMocks", dependencies: ["Networking"]),
        .testTarget(name: "NetworkingTests", dependencies: ["Networking", "NetworkingMocks"]),
    ]
)
```

### 6.4 Package with Resources (Assets, Fonts, JSON)

If you want fonts or asset catalogs to live inside a package (not the main app target), declare them as resources:

```swift
.target(
    name: "DesignSystem",
    resources: [
        // .process copies and processes the resource (e.g., compiles asset catalogs)
        .process("Resources/Assets.xcassets"),
        // .copy copies files as-is
        .copy("Resources/Fonts"),
    ]
)
```

Then inside the package code, access them via `Bundle.module`:

```swift
// Inside DesignSystem package
extension Color {
    static let primaryBlue = Color("primary-blue", bundle: .module)
}

extension Font {
    static func myFont(size: CGFloat) -> Font {
        .custom("MyFont-Bold", size: size, relativeTo: .body)
    }
}
```

And register fonts in code (not Info.plist) if they live in a package:
```swift
// Call this once at app startup
CTFontManagerRegisterFontsWithURL(fontURL, .process, nil)
```

### 6.5 Package with a Test Target

```swift
targets: [
    .target(name: "Domain"),
    .testTarget(
        name: "DomainTests",
        dependencies: ["Domain"]    // test target depends on the target it tests
    ),
]
```

Run tests for just this package from the terminal:
```bash
swift test --package-path Packages/Domain
```

### 6.6 Swift Version Settings

```swift
let package = Package(
    name: "Core",
    platforms: [.iOS(.v17)],
    // Optionally pin to a specific Swift version:
    swiftLanguageVersions: [.v5],
    ...
)
```

### 6.7 Complete Template — Copy This

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PACKAGE_NAME",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "PACKAGE_NAME", targets: ["PACKAGE_NAME"]),
    ],
    dependencies: [
        // Add local package dependencies here:
        // .package(path: "../Core"),
        // .package(path: "../Domain"),
        // .package(path: "../DesignSystem"),
    ],
    targets: [
        .target(
            name: "PACKAGE_NAME",
            dependencies: [
                // List product names from the packages above:
                // "Core",
                // "Domain",
            ],
            // Optional: add resources
            // resources: [.process("Resources")]
        ),
        // Optional: add tests
        // .testTarget(
        //     name: "PACKAGE_NAMETests",
        //     dependencies: ["PACKAGE_NAME"]
        // ),
    ]
)
```

---

## 7. Access Control — The Most Important Rule

In a modular app, **access control is your contract**. If you get it wrong, modules won't be able to use each other's types.

### 7.1 Swift Access Levels (quickref)

| Keyword | Visible to |
|---|---|
| `private` | Within the same declaration |
| `fileprivate` | Within the same file |
| `internal` | Within the same **module** (default) |
| `public` | Any module that imports this one |
| `open` | Any module (also allows subclassing/overriding) |

**The key rule:** Anything that crosses a module boundary MUST be `public`. Everything else should be `internal` (the default — you don't write it).

### 7.2 What Must Be `public`

| Thing | Must be public? | Notes |
|---|---|---|
| Struct/class/enum used by another module | ✅ Yes | |
| Init of a struct | ✅ Yes | Swift gives structs a default memberwise init but it is **internal**. You must explicitly write a `public init` |
| Properties read by another module | ✅ Yes | |
| Methods called by another module | ✅ Yes | |
| Protocol used by another module | ✅ Yes | |
| `static let` constants used elsewhere | ✅ Yes | |
| Private helpers inside a class | ❌ No | Keep them `private` |
| Internal state of a view model | ❌ No | Keep `internal` or `private` |

### 7.3 The Memberwise Init Problem

This is the #1 gotcha when moving structs to packages:

```swift
// Before (monolith) — memberwise init is fine, everything is internal
struct User {
    let id: UUID
    let name: String
}
// Elsewhere in the same target:
let user = User(id: UUID(), name: "Alice")  // works ✅
```

```swift
// After (in Domain package) — memberwise init is INTERNAL, not visible
public struct User {
    public let id: UUID
    public let name: String
    // No explicit public init → external callers CANNOT create a User!
}

// In FeatureLogin package:
let user = User(id: UUID(), name: "Alice")  // ❌ 'User' initializer is inaccessible
```

**Fix:** Always write an explicit `public init` for every `public struct`:

```swift
public struct User {
    public let id: UUID
    public let name: String

    public init(id: UUID, name: String) {  // ← explicit public init
        self.id   = id
        self.name = name
    }
}
```

### 7.4 `@Observable` Classes

When using the `@Observable` macro, the class itself AND the `init` must be `public`:

```swift
// AppCoordination package
@Observable
public final class AppCoordinator {
    public var path = NavigationPath()
    public var isLoggedIn: Bool = false

    public init() {}   // ← must be explicitly public
}
```

### 7.5 Protocol Conformance

Both the protocol AND the conforming type must handle access:

```swift
// Domain package
public protocol CourseRepository {
    func fetchActiveCourse() async throws -> Course
}

public struct MockCourseRepository: CourseRepository {
    public init() {}  // ← don't forget this

    public func fetchActiveCourse() async throws -> Course {
        return Course.mockCourse
    }
}
```

### 7.6 Quick Checklist for Access Control

When moving a file to a package, go through each declaration and ask:

```
Is this type/property/method used from OUTSIDE this package?
├── YES → mark it public (+ write public init for structs)
└── NO  → leave it internal (default) or private
```

---

## 8. Adding Local Packages to Your Xcode Project

After creating your packages, you must link them to the Xcode project. There are two approaches.

### Method A — Xcode UI (recommended for beginners)

**Step 1:** Open your `.xcodeproj` in Xcode.

**Step 2:** Select your project in the **Project Navigator** (the top item, with the Xcode icon).

**Step 3:** In the main editor area, select your **app target** (e.g., `MyApp`) under "Targets".

**Step 4:** Go to the **"General"** tab.

**Step 5:** Scroll down to **"Frameworks, Libraries, and Embedded Content"**.

```
┌────────────────────────────────────────────────┐
│  PROJECT          TARGETS                       │
│  MyApp            MyApp      ◄── selected      │
│  MyAppTests       MyAppTests                   │
│                                                 │
│  General  Signing & Capabilities  Build Phases  │
│                                                 │
│  ...                                            │
│                                                 │
│  Frameworks, Libraries, and Embedded Content    │
│  ┌──────────────────────────────────────────┐  │
│  │  (empty)                                 │  │
│  └──────────────────────────────────────────┘  │
│  [+]  [-]                                       │
└────────────────────────────────────────────────┘
```

**Step 6:** Click the **`+`** button at the bottom left of that section.

**Step 7:** In the sheet that appears, click **"Add Other…"** at the bottom, then **"Add Package Dependency…"**.

```
┌────────────────────────────────────────┐
│  Choose frameworks and libraries       │
│  to add                                │
│                                        │
│  [Search...]                           │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  No results                      │  │
│  └──────────────────────────────────┘  │
│                                        │
│  [Add Other ▼]         [Cancel] [Add]  │
│   └─ Add Package Dependency... ◄────   │
└────────────────────────────────────────┘
```

**Step 8:** In the search bar, click **"Add Local…"** button (bottom left of the sheet):

```
┌────────────────────────────────────────────────────────┐
│  Search or enter package URL                           │
│  ┌──────────────────────────────────────────────────┐ │
│  │  https://...                                      │ │
│  └──────────────────────────────────────────────────┘ │
│                                                        │
│  Recent Packages:                                      │
│  (none)                                                │
│                                                        │
│  [Add Local...]  ◄─── click this          [Cancel]    │
└────────────────────────────────────────────────────────┘
```

**Step 9:** Navigate to `Packages/Core` (or whichever package you're adding) and click **"Add Package"**.

**Step 10:** Xcode shows a confirmation. Make sure the correct product is checked and the correct target is selected:

```
┌────────────────────────────────────────────────────────┐
│  Choose Package Products and Targets                   │
│                                                        │
│  Package: Core                                         │
│                                                        │
│  Product         Target                                │
│  ☑ Core    →     MyApp      ◄─── check this           │
│                                                        │
│                            [Cancel]  [Add Package]     │
└────────────────────────────────────────────────────────┘
```

**Step 11:** Click **"Add Package"**. Repeat for every package.

**Step 12:** For the **test target**, go back to the `+` button but this time with your test target selected. Add `Domain` and any feature package your tests need.

### Method B — Direct `project.pbxproj` Edit (advanced, scriptable)

The `project.pbxproj` file inside `MyApp.xcodeproj/` is a plain text file (despite the `.pbxproj` extension). You can edit it programmatically using a Python/Ruby script. This is useful when you have many packages and don't want to click through the UI dozens of times.

You need to add four things to the pbxproj:

1. **`XCLocalSwiftPackageReference`** — registers the local package path
2. **`XCSwiftPackageProductDependency`** — declares the product you want to link
3. **`PBXBuildFile`** — creates a build file entry that connects the product to a build phase
4. **`PBXFrameworksBuildPhase.files`** — lists the build file in the link phase
5. **`PBXNativeTarget.packageProductDependencies`** — lists products the target depends on
6. **`PBXProject.packageReferences`** — lists all local package references

A template Python script for this is in [section 13.4](#134-automated-pbxproj-script).

### Method C — Package.swift at the Workspace Level (mono-repo)

For very large projects, you can use a top-level `Package.swift` that declares all local packages, then open everything as an Xcode workspace. This is what many large teams do. It's outside the scope of this guide but worth knowing about.

---

## 9. Migrating Existing Code — File by File

This is the practical part. Here's the exact process for moving a file from your monolith to a package.

### 9.1 The Migration Order

Always migrate bottom-up — start with the packages that have no dependencies:

```
Step 1: Core         (no deps)
Step 2: Domain       (depends on Core)
Step 3: DesignSystem (depends on Core)
Step 4: AppCoordination (depends on Domain + DesignSystem)
Step 5: Feature packages (depend on AppCoordination + Domain + DesignSystem)
Step 6: Clean up the main app target
```

Never try to migrate everything at once. Do one package, build, fix errors, commit, then move on.

### 9.2 Moving a File — Step by Step

Let's say you're moving `User.swift` from `MyApp/Entities/User.swift` to the `Domain` package.

**Step 1: Copy (don't move yet) the file into the package:**
```bash
cp MyApp/Entities/User.swift Packages/Domain/Sources/Domain/Entities/User.swift
```

**Step 2: Add `public` to every declaration that crosses the module boundary:**

Before (monolith):
```swift
struct User: Codable, Identifiable {
    let id: UUID
    var firstName: String
    var lastName: String
}
```

After (in Domain package):
```swift
public struct User: Codable, Identifiable {
    public let id: UUID
    public var firstName: String
    public var lastName: String

    public init(id: UUID, firstName: String, lastName: String) {
        self.id        = id
        self.firstName = firstName
        self.lastName  = lastName
    }
}
```

**Step 3: Add necessary `import` statements to the package file:**

If `User.swift` used `String+Extension.swift` from `Core`, add:
```swift
import Core
```

**Step 4: Build just the package to check for errors:**
```bash
swift build --package-path Packages/Domain
```

**Step 5: Once the package builds cleanly, add `import Domain` to every file in the monolith that uses `User`:**
```swift
// In GreyLearn/Features/Login/Presentation/LoginViewModel.swift
import Domain  // ← add this
```

**Step 6: Remove `User.swift` from the main app target** (either delete from disk or uncheck "Target Membership" in Xcode's File Inspector panel on the right).

**Step 7: Build the full project:**
```bash
xcodebuild -scheme MyApp -destination 'generic/platform=iOS Simulator' build
```

**Step 8: Fix any remaining errors, then commit.**

### 9.3 Common Error Patterns and Fixes

**Error: `'SomeType' is not a member of 'ModuleName'`**  
→ You forgot to mark the type `public`. Add `public` to the struct/class/enum declaration.

**Error: `'SomeType' initializer is inaccessible due to 'internal' protection level`**  
→ The struct has a `public` declaration but its init is still internal. Add an explicit `public init(...)`.

**Error: `'SomeType' is ambiguous for type lookup in this context`**  
→ Two modules define a type with the same name. Qualify it: `Domain.Section`, `SwiftUI.Section`.

**Error: `Cannot find type 'SomeType' in scope`**  
→ You forgot to `import ModuleName` at the top of the file.

**Error: `Circular dependency between targets`**  
→ Your dependency graph has a cycle. Redesign the graph (see section 10.1).

**Error: `Module 'X' was not compiled for testing`**  
→ Your test target imports a package but that package isn't linked to the test target. Add it in Xcode's General → Frameworks section for the test target.

---

## 10. Handling Common Pitfalls

### 10.1 Breaking Circular Dependencies

A circular dependency is when package A depends on package B AND package B depends on package A:

```
FeatureLogin ──imports──► AppCoordination
AppCoordination ──imports──► FeatureLogin   ← CYCLE! Won't compile.
```

**How to detect it:**  
When you add a package dependency and get a "dependency cycle" error from SPM, or when you notice that to make package A compile you need a type from package B which itself needs A.

**How to break it — 3 strategies:**

**Strategy 1: Extract the shared type to a lower layer**

If both A and B need type `T`, move `T` to a package that both A and B can depend on without depending on each other.

```
Before:                     After:
A ↔ B (cycle)               A → Shared ← B
                            (no cycle)
```

**Strategy 2: Use a protocol / closure instead of a concrete type**

Instead of having `DesignSystem` import `AppCoordination` to call `coordinator.pop()`, pass a closure:

```swift
// Before — causes DesignSystem to import AppCoordination (cycle risk):
struct BackButton: View {
    @Environment(AppCoordinator.self) private var coordinator
    var body: some View {
        Button("Back") { coordinator.pop() }
    }
}

// After — no import needed:
struct BackButton: View {
    let onTap: () -> Void
    var body: some View {
        Button("Back") { onTap() }
    }
}
// At the call site in a feature:
BackButton(onTap: { coordinator.pop() })
```

**Strategy 3: Invert the dependency with a protocol**

```swift
// AppCoordination package — defines the protocol
public protocol NavigationController {
    func push(_ route: AnyRoute)
    func pop()
}

// FeatureLogin — conforms to the protocol (doesn't import AppCoordination's concrete type)
// AppCoordinator — also conforms to the protocol
```

### 10.2 The `navigationDestination` Must Be Inside `NavigationStack`

A very common SwiftUI bug in modular apps: when `NavigationStack` lives in the app target and destination views live in feature packages, you might be tempted to attach `navigationDestination` outside the stack. This won't work.

```swift
// ❌ WRONG — navigationDestination outside NavigationStack
NavigationStack(path: $path) {
    ContentView()
}
.navigationDestination(for: MyRoute.self) { route in  // ← this doesn't work
    RouteView(route: route)
}

// ✅ CORRECT — navigationDestination inside the stack's content
NavigationStack(path: $path) {
    ContentView()
        .navigationDestination(for: MyRoute.self) { route in  // ← attached to a view inside
            RouteView(route: route)
        }
}
```

### 10.3 File System Synchronized Groups (Xcode 16+)

Xcode 16 introduced "File System Synchronized Groups" — when your target uses this, ALL files in the target's folder are automatically compiled. If you've moved a file to a package but the original file still exists in the main app folder, you'll get duplicate symbol errors.

**How to detect:** In Xcode, if the folder icon in the Navigator looks like this — a folder with a diamond-shaped symbol — it's using file system sync.

**Solutions:**
1. **Delete the original file from disk** after copying it to the package. (Recommended.)
2. **Add the file as an exception** in the File System Synchronized Group settings.
3. **Disable file system sync** for the target and manage files manually.

### 10.4 `@Observable` vs `ObservableObject` in Packages

Both work in packages, but have different requirements:

**`ObservableObject` (Combine-based):**
```swift
// Works in packages — no special considerations
public final class MyViewModel: ObservableObject {
    @Published public var value: String = ""
    public init() {}
}
```

**`@Observable` macro (Swift 5.9+):**
```swift
// Works in packages — mark the class AND init as public
@Observable
public final class AppCoordinator {
    public var path = NavigationPath()
    public init() {}
}
```

**⚠️ Combine `.assign(to: &$publishedProperty)` in packages:**  
The `assign(to: inout Published<T>.Publisher)` overload can cause parse errors in some SPM module contexts. Use `.sink { [weak self] in self?.property = $0 }.store(in: &cancellables)` instead — it's identical in behavior and works everywhere.

### 10.5 Swift Regex Literals in Packages

Swift regex literals (`/pattern/`) require the package toolchain to enable them explicitly in some configurations. If you get parse errors on regex literals inside a package, replace them with `NSRegularExpression`:

```swift
// ❌ May fail in some SPM configurations:
let regex = /^[A-Z0-9]+$/

// ✅ Works everywhere:
let regex = try? NSRegularExpression(pattern: #"^[A-Z0-9]+$"#)
```

### 10.6 Resources in Test Targets

If your test needs a JSON file, image, or other resource, add it to the test target in Package.swift:

```swift
.testTarget(
    name: "DomainTests",
    dependencies: ["Domain"],
    resources: [.copy("TestData")]  // copies TestData/ folder into the test bundle
)
```

Access it in tests:
```swift
let url = Bundle.module.url(forResource: "sample", withExtension: "json")!
```

---

## 11. Testing in a Modular Architecture

Modular architecture makes testing dramatically better because you can test a module's logic without the entire app.

### 11.1 Three Kinds of Tests

**Package-level unit tests** — fastest, most isolated:
```swift
// In Domain package's test target
import XCTest
import Domain

final class CourseTests: XCTestCase {
    func testStageProgress() {
        let stage = Course.mockCourse.stage
        XCTAssertEqual(stage.text, "Stage 3 of 11")
    }
}
```
Run: `swift test --package-path Packages/Domain`

**App-level integration tests** — tests that link multiple packages:
```swift
// In GreyLearnTests target
import XCTest
import Domain
import FeatureHome  // ← import the packages you need

final class HomeViewModelTests: XCTestCase {
    func testStreakIncrement() {
        let vm = HomeViewModel(dependencies: .init(
            courseRepository: MockCourseRepository(),
            localRepository: LocalRepository()
        ))
        vm.recordActivity()
        XCTAssertEqual(vm.streak, "🔥 1 day")
    }
}
```

**UI tests** — slowest, test the full running app (no module-level imports needed).

### 11.2 The Protocol-Based Stub Pattern

Because your repositories are protocols in `Domain`, writing stubs is trivial:

```swift
// In your test file — no extra mocking library needed
private struct StubCourseRepository: CourseRepository {
    let course: Course
    func fetchActiveCourse() async throws -> Course { course }
}

private struct FailingCourseRepository: CourseRepository {
    func fetchActiveCourse() async throws -> Course {
        throw URLError(.notConnectedToInternet)
    }
}
```

### 11.3 Isolated Storage for Tests

Never let tests touch real `UserDefaults.standard`. Use a named suite per test:

```swift
override func setUp() {
    super.setUp()
    let suiteName = UUID().uuidString  // unique per test run
    let defaults  = UserDefaults(suiteName: suiteName)!
    storage       = LocalStorageManager(defaults: defaults)
}

override func tearDown() {
    defaults.removePersistentDomain(forName: suiteName)
    super.tearDown()
}
```

### 11.4 Adding a Test Target to a Package

Modify the package's `Package.swift`:

```swift
targets: [
    .target(name: "Domain"),
    .testTarget(
        name: "DomainTests",
        dependencies: ["Domain"]
    ),
]
```

Create the test directory:
```bash
mkdir -p Packages/Domain/Tests/DomainTests
touch Packages/Domain/Tests/DomainTests/DomainTests.swift
```

Run:
```bash
swift test --package-path Packages/Domain
```

Or in Xcode: `⌘U` with the package's scheme selected.

---

## 12. The Composition Root Pattern

The **composition root** is the single place in your app where everything is wired together. In an iOS modular app, this is almost always the `@main` App struct.

### 12.1 What the Composition Root Does

1. Creates the root coordinator / state container
2. Creates all feature coordinators, injecting dependencies
3. Owns the top-level `NavigationStack`
4. Decides which feature view to show (logged in vs. logged out, for example)
5. Is the ONLY file that imports all feature packages simultaneously

### 12.2 Example Composition Root

```swift
import SwiftUI
import AppCoordination   // coordinators
import FeatureLaunch     // LaunchScreenView
import FeatureLogin      // LoginView
import FeatureHome       // HomeView
// + any other feature packages your root view needs

@main
struct MyApp: App {
    // ── State ─────────────────────────────────────────────────────────
    @State private var appCoordinator: AppCoordinator
    @State private var loginCoordinator: LoginCoordinator
    @State private var homeCoordinator: HomeCoordinator
    @State private var isLaunching = true

    // ── Init — wires everything together ─────────────────────────────
    init() {
        let app = AppCoordinator()
        _appCoordinator   = State(wrappedValue: app)
        _loginCoordinator = State(wrappedValue: LoginCoordinator(appCoordinator: app))
        _homeCoordinator  = State(wrappedValue: HomeCoordinator(appCoordinator: app))
    }

    // ── Root view ────────────────────────────────────────────────────
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack(path: $appCoordinator.path) {
                    rootContent
                        // navigationDestination MUST be inside NavigationStack content
                        .navigationDestination(for: AppRoute.self) { route in
                            AppRouteView(route: route)
                                .environment(appCoordinator)
                        }
                }

                if isLaunching {
                    LaunchScreenView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear { scheduleLaunchDismiss() }
        }
    }

    @ViewBuilder
    private var rootContent: some View {
        if appCoordinator.isLoggedIn, let user = appCoordinator.currentUser {
            HomeView(user: user)
                .environment(homeCoordinator)
                .environment(appCoordinator)
        } else {
            LoginView()
                .environment(loginCoordinator)
        }
    }

    private func scheduleLaunchDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 0.5)) { isLaunching = false }
        }
    }
}
```

### 12.3 The Route → View Mapping File

`AppRouteView.swift` is a second "composition" file that maps route enum cases to concrete feature views. It MUST stay in the main app target (not in any package) because it imports all feature packages:

```swift
import SwiftUI
import AppCoordination
import FeatureChat      // ChatView
import FeaturePath      // PathView
import FeatureProfile   // ProfileView

struct AppRouteView: View {
    @Environment(AppCoordinator.self) private var appCoordinator
    let route: AppRoute

    var body: some View {
        switch route {
        case .profile:
            if let user = appCoordinator.currentUser {
                ProfileView(user: user, onLogout: { appCoordinator.logout() })
                    .environment(ProfileCoordinator(appCoordinator: appCoordinator))
            }

        case .path(let course):
            PathView(course: course)
                .environment(PathCoordinator(appCoordinator: appCoordinator))

        case .chat:
            ChatView()
                .environment(ChatCoordinator(appCoordinator: appCoordinator))
        }
    }
}
```

---

## 13. A Complete Real-World Example

This section walks through modularizing a fictional "ShopApp" from scratch.

### 13.1 Starting Point

ShopApp is a monolith with these files:
```
ShopApp/
├── Models/
│   ├── Product.swift
│   └── CartItem.swift
├── Repositories/
│   ├── ProductRepository.swift
│   └── CartRepository.swift
├── Navigation/
│   ├── AppRoute.swift
│   └── AppCoordinator.swift
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   └── HomeViewModel.swift
│   ├── ProductDetail/
│   │   ├── ProductDetailView.swift
│   │   └── ProductDetailViewModel.swift
│   └── Cart/
│       ├── CartView.swift
│       └── CartViewModel.swift
├── DesignSystem/
│   ├── AppButton.swift
│   └── AppColors.swift
└── Utilities/
    └── String+Ext.swift
```

### 13.2 Step 1 — Design the Graph

```
       ShopApp (app target)
            │
    ┌───────┼───────┐
    ▼       ▼       ▼
 FeatureHome  FeatureProductDetail  FeatureCart
    │              │                     │
    └──────────────┼─────────────────────┘
                   ▼
            AppCoordination
           /               \
          ▼                 ▼
       Domain           DesignSystem
          \                 /
           ▼               ▼
               Core
```

### 13.3 Step 2 — Create the Package Structure

```bash
cd ~/Desktop/ShopApp

mkdir -p Packages/{Core,Domain,DesignSystem,AppCoordination,FeatureHome,FeatureProductDetail,FeatureCart}/Sources

# Create Package.swift for each — see section 6 for templates
```

### 13.4 Automated pbxproj Script

Here is a Python script template you can adapt to inject local packages into your `project.pbxproj`. Run it from your project root after creating your packages:

```python
#!/usr/bin/env python3
"""
inject_packages.py — Injects local SPM packages into a .pbxproj file.

Usage:
    python3 inject_packages.py

Edit the CONFIGURATION section below for your project.
"""

import re

# ─── CONFIGURATION ────────────────────────────────────────────────────────────

PBXPROJ_PATH = "MyApp.xcodeproj/project.pbxproj"

# Package name → relative path from project root
PACKAGES = {
    "Core":            "Packages/Core",
    "Domain":          "Packages/Domain",
    "DesignSystem":    "Packages/DesignSystem",
    "AppCoordination": "Packages/AppCoordination",
    "FeatureHome":     "Packages/FeatureHome",
    "FeatureCart":     "Packages/FeatureCart",
}

# Products to link to the main app target (by name, must match Package.swift product names)
APP_TARGET_PRODUCTS = [
    "AppCoordination",
    "FeatureHome",
    "FeatureCart",
]

# Products to link to the test target
TEST_TARGET_PRODUCTS = [
    "Domain",
    "FeatureHome",
]

# Native target IDs from your pbxproj (grep for PBXNativeTarget to find them)
APP_TARGET_ID   = "AABBCC001122334455667788"   # ← replace with yours
TEST_TARGET_ID  = "AABBCC009988776655443322"   # ← replace with yours
APP_FRAMEWORKS_PHASE_ID  = "AABBCC00FRAMEWORKS"
TEST_FRAMEWORKS_PHASE_ID = "AABBCC00TESTFRAME"
PROJECT_OBJECT_ID        = "AABBCC00PROJECTID"

# ─── IMPLEMENTATION ────────────────────────────────────────────────────────────
# (UUID generation uses deterministic hex strings — replace with uuid.uuid4() for real use)

def make_uid(prefix, name):
    """Generate a deterministic 24-char hex UID."""
    h = hex(abs(hash(prefix + name)))[2:].upper().zfill(24)[:24]
    return h

PKG_REF  = {n: make_uid("REF",  n) for n in PACKAGES}
PKG_PROD = {n: make_uid("PROD", n) for n in PACKAGES}
PKG_BF   = {n: make_uid("BF",   n) for n in PACKAGES}
PKG_PROD_TEST = {n: make_uid("TPROD", n) for n in TEST_TARGET_PRODUCTS}
PKG_BF_TEST   = {n: make_uid("TBF",   n) for n in TEST_TARGET_PRODUCTS}

with open(PBXPROJ_PATH, "r") as f:
    content = f.read()

# 1. XCLocalSwiftPackageReference entries
ref_block = "\n/* Begin XCLocalSwiftPackageReference section */\n"
for name, path in PACKAGES.items():
    uid = PKG_REF[name]
    ref_block += f'\t\t{uid} /* {name} */ = {{\n'
    ref_block += f'\t\t\tisa = XCLocalSwiftPackageReference;\n'
    ref_block += f'\t\t\trelativePath = {path};\n'
    ref_block += f'\t\t}};\n'
ref_block += "/* End XCLocalSwiftPackageReference section */\n"

# 2. XCSwiftPackageProductDependency entries
prod_block = "\n/* Begin XCSwiftPackageProductDependency section */\n"
for name in PACKAGES:
    uid = PKG_PROD[name]
    ref_uid = PKG_REF[name]
    prod_block += f'\t\t{uid} /* {name} */ = {{\n'
    prod_block += f'\t\t\tisa = XCSwiftPackageProductDependency;\n'
    prod_block += f'\t\t\tpackage = {ref_uid};\n'
    prod_block += f'\t\t\tproductName = {name};\n'
    prod_block += f'\t\t}};\n'
for name in TEST_TARGET_PRODUCTS:
    uid = PKG_PROD_TEST[name]
    ref_uid = PKG_REF[name]
    prod_block += f'\t\t{uid} /* {name}_test */ = {{\n'
    prod_block += f'\t\t\tisa = XCSwiftPackageProductDependency;\n'
    prod_block += f'\t\t\tpackage = {ref_uid};\n'
    prod_block += f'\t\t\tproductName = {name};\n'
    prod_block += f'\t\t}};\n'
prod_block += "/* End XCSwiftPackageProductDependency section */\n"

# 3. PBXBuildFile entries
bf_entries = ""
for name in APP_TARGET_PRODUCTS:
    bf_entries += f'\t\t{PKG_BF[name]} /* {name} */ = {{isa = PBXBuildFile; productRef = {PKG_PROD[name]}; }};\n'
for name in TEST_TARGET_PRODUCTS:
    bf_entries += f'\t\t{PKG_BF_TEST[name]} /* {name}_test */ = {{isa = PBXBuildFile; productRef = {PKG_PROD_TEST[name]}; }};\n'

# Inject before PBXFileReference section
content = content.replace(
    "/* Begin PBXFileReference section */",
    bf_entries + "/* Begin PBXFileReference section */"
)

# Inject before XCConfigurationList section
content = content.replace(
    "/* Begin XCConfigurationList section */",
    ref_block + prod_block + "/* Begin XCConfigurationList section */"
)

print("Done! Save content to", PBXPROJ_PATH)
print("Note: You still need to update packageReferences, packageProductDependencies,")
print("and Frameworks build phases manually or extend this script.")

with open(PBXPROJ_PATH, "w") as f:
    f.write(content)
```

> **⚠️ Warning:** Always commit your project before running any pbxproj script. If the output is malformed, Xcode will refuse to open the project. Use `git diff` to review changes.

### 13.5 Step 3 — Migrate Files in Order

**Core first:**
```bash
# Copy String+Ext.swift
cp ShopApp/Utilities/String+Ext.swift \
   Packages/Core/Sources/Core/String+Extension.swift

# Add public to all declarations
# Build the package
swift build --package-path Packages/Core
```

**Domain next:**
```bash
# Copy models
cp ShopApp/Models/Product.swift \
   Packages/Domain/Sources/Domain/Entities/Product.swift

cp ShopApp/Models/CartItem.swift \
   Packages/Domain/Sources/Domain/Entities/CartItem.swift

# Copy repository protocols
cp ShopApp/Repositories/ProductRepository.swift \
   Packages/Domain/Sources/Domain/Repository/ProductRepository.swift

# Add import Core to files that use Core extensions
# Add public to all declarations
# Build
swift build --package-path Packages/Domain
```

Continue up the graph...

---

## 14. Module Architecture Patterns Reference

### 14.1 The Navigator Pattern (what this guide uses)

```
AppCoordinator
    ├── owns NavigationPath
    ├── owns login/logout logic
    └── knows about AppRoute

FeatureCoordinator
    ├── has a reference to AppCoordinator
    ├── translates FeatureRoute → AppRoute
    └── delegates push/pop to AppCoordinator
```

**Pros:** Simple, easy to understand, low boilerplate.  
**Cons:** AppCoordinator knows about all routes; not ideal for very large apps.

### 14.2 The Router Protocol Pattern

Define a protocol in `AppCoordination` that all coordinators conform to:

```swift
// AppCoordination
public protocol Router {
    func push<R: Hashable>(_ route: R)
    func pop()
    func popToRoot()
    func present<R: Identifiable>(_ sheet: R)
}
```

Features code against `Router`, not `AppCoordinator`. This lets you swap the coordinator implementation in tests.

### 14.3 The TCA Pattern (The Composable Architecture)

If you use TCA (by Point-Free), your modules become `Reducer`s instead of coordinators. Each feature module contains a `Feature.swift` with `State`, `Action`, `Reducer`, and `View`. The composition happens at the app level via `Scope` and `Store`.

### 14.4 The MVVM-C Pattern (what most teams use)

```
Feature Package:
├── View (SwiftUI)
├── ViewModel (ObservableObject or @Observable)
└── Coordinator (in AppCoordination package)
```

This is what the GreyLearn modularization used. It's pragmatic and widely understood.

---

## 15. Checklist — Before You Ship

Use this checklist after completing a modularization. Check every item before merging to `main`.

### Package Structure
- [ ] All packages have a valid `Package.swift` with correct `platforms`
- [ ] No circular dependencies in the graph
- [ ] Every package can be compiled independently: `swift build --package-path Packages/X`
- [ ] All package names are consistent (e.g., all `FeatureX` or all `XFeature`)

### Access Control
- [ ] Every type used outside its package is `public`
- [ ] Every `public struct` has an explicit `public init(...)`
- [ ] Every `@Observable public final class` has a `public init()`
- [ ] No unnecessary `public` on internal helpers

### The Main App Target
- [ ] The app target's source folder contains ONLY the composition root files
- [ ] No old source files remain in the app target that duplicate package files
- [ ] `@main` struct only imports the packages it directly uses
- [ ] `AppRouteView` (or equivalent) is in the app target, not a package

### Navigation
- [ ] `navigationDestination` is attached to a view INSIDE the `NavigationStack` content
- [ ] No feature package imports another feature package
- [ ] All coordinators delegate push/pop to the root coordinator

### Tests
- [ ] Test imports use `import Domain` etc. (not `@testable import MyApp`)
- [ ] No test uses `UserDefaults.standard` — all use named suites
- [ ] All tests pass: `⌘U`

### Build
- [ ] Clean build succeeds: `⌘⇧K` then `⌘B`
- [ ] No warnings treated as errors that sneak through
- [ ] Archive succeeds: **Product → Archive**

---

## Appendix A — Quick Command Reference

```bash
# Validate a Package.swift
swift package --package-path Packages/Domain dump-package

# Build a single package
swift build --package-path Packages/Domain

# Test a single package
swift test --package-path Packages/Domain

# Build the full Xcode project
xcodebuild \
  -scheme MyApp \
  -destination 'generic/platform=iOS Simulator' \
  build

# Run unit tests
xcodebuild \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  test

# Reset SPM package cache (if packages won't resolve)
rm -rf ~/Library/Caches/org.swift.swiftpm
```

---

## Appendix B — Glossary

| Term | Meaning |
|---|---|
| **Module** | A compiled Swift unit with its own namespace and access boundary |
| **Package** | A directory with a `Package.swift` that defines one or more modules |
| **Local package** | A package that lives inside your repository (vs. fetched from GitHub) |
| **Product** | What a package exposes to the outside world (a library or executable) |
| **Target** | The actual compilation unit inside a package |
| **Dependency graph** | The directed acyclic graph of which modules depend on which |
| **Composition root** | The single place where all dependencies are wired together |
| **Access control** | Swift keywords (`public`, `internal`, `private`) that govern visibility |
| **Circular dependency** | When A depends on B and B depends on A — forbidden |
| **Transitive dependency** | If A→B→C, then C is a transitive dependency of A |
| **pbxproj** | The plain-text file inside `.xcodeproj` that describes the project structure |

---

## Appendix C — Further Reading

- [Swift Package Manager Documentation](https://www.swift.org/package-manager/) — official SPM reference
- [Swift Evolution SE-0246](https://github.com/apple/swift-evolution/blob/main/proposals/0246-mathable.md) — how modules work
- [WWDC 2022 — Meet Swift Package plugins](https://developer.apple.com/videos/play/wwdc2022/110359/) — advanced SPM
- [WWDC 2019 — Binary Frameworks in Swift](https://developer.apple.com/videos/play/wwdc2019/416/) — XCFrameworks context
- [Point-Free — Modular Architecture](https://www.pointfree.co/collections/composable-architecture) — TCA approach

---

*Guide version 1.0 — May 2026. Created for the GreyLearn iOS project.*
