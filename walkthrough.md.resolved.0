# Advait Academy - Staff & Salary Management App

A production-ready Flutter application for managing teaching and non-teaching staff, tracking their work hours, and calculating monthly salaries.

## Features Implemented

- **Categorized Staff Management**: Separate views for Teaching and Non-Teaching staff.
- **Dynamic Salary Calculation**: Auto-calculated based on days worked, hours per day, and staff-specific hourly rates.
- **Salary History**: Detailed record tracking for each staff member with cumulative totals.
- **Cloud Integration**: Real-time persistence using Firebase Firestore.
- **Premium UI**: Green and Orange theme with `Outfit` typography and smooth transitions.

## Project Structure

```text
lib/
├── models/
│   ├── staff_model.dart          # Data structure for Staff
│   └── salary_record_model.dart  # Data structure for Salary Records
├── providers/
│   └── staff_provider.dart       # State management using Provider
├── screens/
│   ├── home_screen.dart          # Categorized staff list
│   ├── add_staff_screen.dart     # New staff entry form
│   └── staff_detail_screen.dart  # Salary history and cumulative stats
├── services/
│   └── firestore_service.dart    # Firebase CRUD operations
└── widgets/
    ├── app_theme.dart            # Custom Green/Orange theme
    └── add_salary_bottom_sheet.dart # Salary entry form with auto-calc
```

## Setup Instructions

### 1. Firebase Configuration
To get the app running, you need to connect it to your Firebase project:

1.  Go to the [Firebase Console](https://console.firebase.google.com/).
2.  Create a new project named **Advait Academy**.
3.  Enable **Cloud Firestore** in the project and start it in "Test Mode" (or configure rules).
4.  Add an **Android** and **iOS** app to the project.
5.  Download `google-services.json` (Android) and place it in `android/app/`.
6.  Download `GoogleService-Info.plist` (iOS) and place it in `ios/Runner/`.

### 2. Run the App
Once Firebase is configured:
```bash
flutter pub get
flutter run
```

## Data Schema (Firestore)

- **`staff` (collection)**
  - `name`: string
  - `category`: "teaching" | "non-teaching"
  - `defaultHourlyRate`: number
  - **`salaryRecords` (sub-collection)**
    - `month`: number
    - `year`: number
    - `daysWorked`: number
    - `hoursPerDay`: number
    - `totalHours`: number
    - `hourlyRate`: number
    - `calculatedSalary`: number
    - `createdAt`: serverTimestamp
