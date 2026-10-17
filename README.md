# Daily Habit Tracker
Flutter · Clean Architecture · Firestore · flutter_bloc · freezed · dartz · get_it · go_router

## Run
1. `flutter create .` (generates platform folders), then `flutterfire configure`
2. `dart run build_runner build --delete-conflicting-outputs`
3. `flutter run`

Firestore collection `habits`: `{name, description, points, completedDates: ["yyyy-MM-dd"], createdAt}`

## Layers
`domain` (entities, repo interface, use cases — pure Dart) ← `data` (Firestore datasource, repo impl) ← `presentation` (Cubit + pages). Only `injection.dart` knows all layers.

## TODO for submission
Screenshots · demo video · vibe-coding walkthrough · repo link
