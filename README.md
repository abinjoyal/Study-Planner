# Study Planner

Study Planner is a mobile application developed with Flutter and Supabase to streamline academic organization and exam preparation. The application enables students to break down syllabi into structured modules, automate daily study schedules, track real-time study metrics, and sustain disciplined learning habits.

---

## Features

- **Syllabus and Curriculum Organization**: Structured hierarchy for subjects, chapters, and topics with status tracking.
- **Automated Schedule Generation**: Dynamic generation of daily and weekly study targets aligned with exam dates and availability.
- **Focus and Productivity Timer**: Integrated timer to track active study sessions and measure focus duration.
- **Progress Tracking and Analytics**: Visual metrics displaying completion percentages, subject mastery, and consistency streaks.
- **Task and Deadline Management**: Daily actionable task lists derived from broader study milestones.
- **Reminders and Push Notifications**: Local notifications for scheduled study intervals, upcoming revisions, and deadlines.
- **State and Cache Persistence**: Local storage with offline availability and remote data synchronization.

---

## Technical Stack

| Category | Technology |
| :--- | :--- |
| **Framework** | Flutter (Dart SDK ^3.12.2) |
| **State Management** | Flutter Riverpod |
| **Backend & Database** | Supabase (PostgreSQL, Authentication, Realtime) |
| **Local Storage** | Shared Preferences |
| **Networking & Connectivity** | Dio, Internet Connection Checker Plus |
| **Notifications** | Flutter Local Notifications |
| **Environment Management**| Flutter Dotenv |

---

## Architecture and Project Structure

The project follows a feature-driven clean architecture pattern, isolating common infrastructure from individual domain modules:

```text
lib/
├── core/
│   ├── constants/
│   ├── network/
│   ├── theme/
│   └── utils/
├── features/
│   ├── focus/           # Session timers and focus tracking
│   ├── home/            # Dashboard, metrics, and daily overview
│   ├── notifications/   # Notification scheduling and handling
│   ├── onboarding/      # Initial user onboarding flows
│   ├── planner/         # Study schedules, calendar, and task generation
│   ├── profile/         # User preferences and account settings
│   ├── progress/        # Performance reports and completion statistics
│   └── splash/          # App initialization and auth state checks
└── main.dart            # Application entry point
```

---

## Planning and Execution Workflow

```text
Syllabus Input (Subjects & Topics)
               │
               ▼
Exam Dates & Available Study Hours
               │
               ▼
Automated Schedule Distribution
               │
               ▼
Daily Task Queue & Focus Sessions
               │
               ▼
Analytics & Progress Evaluation
```

---

## Getting Started

### Prerequisites

- Flutter SDK (version 3.12.2 or higher)
- Android Studio / Xcode / VS Code with Flutter extension
- Active Supabase account and project

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/abinjoyal/Study-Planner.git
   cd Study-Planner
   ```

2. Configure environment variables:
   Create a `.env` file in the root directory and specify your Supabase credentials:
   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

3. Fetch dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

---

## Development Roadmap

- [x] Initial Project Setup and Feature Architecture
- [x] Onboarding and Splash Navigation
- [ ] Supabase Authentication and User Profiles
- [ ] Subject and Syllabus Data Management
- [ ] Schedule Generation Engine
- [ ] Pomodoro / Study Focus Session Timer
- [ ] Notification Scheduling System
- [ ] Offline Cache Sync

---

## License

This project is licensed under the MIT License.