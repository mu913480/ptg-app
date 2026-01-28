---
description: How to create a new feature following clean architecture
---

# Feature Creation Workflow

This workflow documents how to create new features in this Flutter project following clean architecture principles.

## Feature Structure

Each feature should be created in `lib/features/<feature_name>/` with the following structure:

```
lib/features/<feature_name>/
├── bloc/
│   ├── <feature_name>_bloc.dart
│   ├── <feature_name>_event.dart
│   └── <feature_name>_state.dart
├── models/
│   └── <model_name>.dart
└── ui/
    └── <feature_name>_screen.dart
```

## Key Patterns

### 1. BLoC Pattern
- Use `flutter_bloc` for state management
- Separate events, states, and bloc logic into distinct files
- Use `Equatable` for models, events, and states

### 2. Models
- Use `Equatable` for all model classes
- Use `fromJson` and `toJson` methods for serialization
- Models are stored in the `models/` folder

### 3. Database Operations
- Use `DatabaseService.getRecords()` for fetching data
- Use `DatabaseService.insertRecord()` for inserting data
- Use `DatabaseService.updateRecord()` for updating data
- Use `NetworkChecker` before making any API calls

### 4. UI
- Screens are stored in the `ui/` folder
- Handle loading, error, and empty states
- Use `BlocProvider` to provide blocs to screens
- Use `BlocBuilder` or `BlocListener` for state management

### 5. Routing
- Add new routes in `lib/routes/routes.dart`
- Wrap screens with `BlocProvider` when adding to routes

## Steps to Create a New Feature

1. **Create the feature directory structure**
   ```
   lib/features/<feature_name>/
   ├── bloc/
   ├── models/
   └── ui/
   ```

2. **Create model classes** (if needed)
   - Use Equatable
   - Add fromJson/toJson methods

3. **Create BLoC files**
   - `<feature_name>_event.dart` - Define events
   - `<feature_name>_state.dart` - Define states with Equatable
   - `<feature_name>_bloc.dart` - Handle events and emit states

4. **Create the UI screen**
   - Implement loading, error, and empty states
   - Use BlocBuilder/BlocListener

5. **Add routing**
   - Add route in `lib/routes/routes.dart`
   - Wrap with BlocProvider

