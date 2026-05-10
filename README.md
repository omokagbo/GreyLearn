# GreyLearn

A modern iOS learning application built with SwiftUI that helps users track their learning journey through structured courses, modules, and daily streaks.

## Overview

GreyLearn is an iOS app that provides a personalized learning experience. Users can enroll in courses broken down into modules, sections, and topics, monitor their progress, maintain learning streaks, and interact with an AI-powered chat assistant — all within a clean, modern interface.

## Features

- **Onboarding & Authentication** — Secure login flow with session persistence
- **Home Dashboard** — Personalized greeting, streak tracker, and active course summary
- **Course & Path Navigation** — Structured learning paths with modules, sections, and topics
- **Progress Tracking** — Visual indicators for course stage and module completion
- **Learning Streaks** — Daily activity recording to keep users motivated
- **Badges** — Achievement badges awarded for milestones
- **AI Chat** — Built-in chat interface for learning assistance
- **Profile** — User profile management
- **Launch Screen** — Animated splash screen on app start

## Architecture

GreyLearn follows a **Coordinator + MVVM** pattern:

| Layer | Details |
|---|---|
| **Coordination** | `AppCoordinator`, `HomeCoordinator`, `ChatCoordinator` manage navigation using `NavigationStack` |
| **Presentation** | SwiftUI views backed by `ObservableObject` view models |
| **Repository** | `CourseRepository` and `LocalRepository` abstract data access |
| **DI** | Dependency injection via `HomeDependencies` / `LoginDependencies` structs with `.live` and mock configurations |
| **Entities** | `User`, `Course`, `Module`, `Section`, `Topic`, `Streak`, `ChatMessage` |
| **Storage** | `LocalStorageManager` with typed `StorageKeys` for local persistence |

## Project Structure

```
GreyLearn/
├── App/                    # App entry point
├── Coordination/           # Root coordinators & routes
├── DI/                     # Dependency injection containers
├── Entities/               # Domain models
├── Features/
│   ├── Chat/               # AI chat feature
│   ├── Home/               # Dashboard & active course
│   ├── Launch/             # Splash screen
│   ├── Login/              # Authentication
│   ├── Path/               # Learning path detail
│   └── Profile/            # User profile
├── Repository/             # Data layer
├── Resources/              # Assets, fonts
└── Utilities/              # Extensions, components, modifiers
```

## Requirements

| Requirement | Version |
|---|---|
| iOS | 17.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://www.github.com/omokagbo/GreyLearn
   cd GreyLearn
   ```

2. **Open in Xcode**
   ```bash
   open GreyLearn.xcodeproj
   ```

3. **Build & Run**
   - Select a simulator or connected device
   - Press `Cmd + R` to build and run

## Testing

Unit tests are located in the `GreyLearnTests` target and cover:

- `CourseTests` — Course entity logic
- `ModuleTests` — Module entity logic
- `HomeViewModelTest` — Home view model behaviour
- `CouseRepositoryTests` — Course repository contract
- `LocalRepositoryTests` — Local storage operations

Run tests with `Cmd + U` in Xcode.

## Fonts

The app uses the **Aeonik** typeface across all weights (Thin → Black) including italic variants.

## Author

**Emmanuel Omokagbo** — © 2026

## License

This project is proprietary. All rights reserved.
