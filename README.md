# Study Planner

A Flutter-based study planning application designed to help students organize their syllabus, create study schedules, track learning progress, and prepare for exams effectively.

## Features

- Subject and syllabus management
- Daily and weekly study planning
- Exam and deadline tracking
- Study session timer
- Progress and productivity tracking
- Study streaks
- Topic-based notes
- Notifications and reminders
- Offline data support

## Tech Stack

- Flutter
- Dart
- Riverpod
- GoRouter
- Supabase
- PostgreSQL
- Hive

## Architecture

The project follows a scalable architecture with separation between presentation, domain, and data layers.

```text
lib/
├── core/
├── data/
├── domain/
├── presentation/
└── main.dart
```

## Planning Flow

```text
Subjects
   ↓
Topics
   ↓
Exam Date
   ↓
Available Study Time
   ↓
Schedule Generation
   ↓
Daily Tasks
   ↓
Progress Tracking
```

## Roadmap

- [ ] Authentication
- [ ] Subject and topic management
- [ ] Study planner
- [ ] Exam management
- [ ] Focus timer
- [ ] Progress analytics
- [ ] Notifications
- [ ] Offline synchronization
- [ ] Advanced scheduling

## Getting Started

```bash
git clone https://github.com/your-username/study-planner.git
cd study-planner
flutter pub get
flutter run
```

## Goal

Study Planner helps students turn their syllabus into structured daily tasks and build consistent study habits.

## License

MIT License