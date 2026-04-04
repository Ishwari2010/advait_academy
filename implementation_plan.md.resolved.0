# Advait Academy Flutter Application Implementation Plan

Developing a mobile app for managing staff and their salary records using Flutter and Firebase Firestore.

## User Review Required

> [!IMPORTANT]
> **Firebase Setup**: The user must setup a project in the Firebase Console and add Android/iOS apps to get the configuration files (`google-services.json` and `GoogleService-Info.plist`).
> **Hourly Rates**: I'll use configurable constants for hourly rates (Teaching: ₹500, Non-Teaching: ₹200) as defaults.

## Proposed Changes

### Configuration
#### [NEW] [pubspec.yaml](file:///C:/Users/acer/.gemini/antigravity/scratch/advait_academy/pubspec.yaml)
Project configuration with `provider`, `cloud_firestore`, `firebase_core`, `google_fonts`, `intl`.

### Models
#### [NEW] [staff_model.dart](file:///C:/Users/acer/.gemini/antigravity/scratch/advait_academy/lib/models/staff_model.dart)
Data model for staff members.
#### [NEW] [salary_record_model.dart](file:///C:/Users/acer/.gemini/antigravity/scratch/advait_academy/lib/models/salary_record_model.dart)
Data model for monthly salary entries.

### Services
#### [NEW] [firestore_service.dart](file:///C:/Users/acer/.gemini/antigravity/scratch/advait_academy/lib/services/firestore_service.dart)
Service class for Firestore interactions (fetch staff, add staff, fetch records, add record).

### State Management
#### [NEW] [staff_provider.dart](file:///C:/Users/acer/.gemini/antigravity/scratch/advait_academy/lib/providers/staff_provider.dart)
Provider class to handle state changes and notify listeners.

### Screens
#### [NEW] [home_screen.dart](file:///C:/Users/acer/.gemini/antigravity/scratch/advait_academy/lib/screens/home_screen.dart)
Split view for Teaching and Non-Teaching staff.
#### [NEW] [add_staff_screen.dart](file:///C:/Users/acer/.gemini/antigravity/scratch/advait_academy/lib/screens/add_staff_screen.dart)
Form for adding new staff.
#### [NEW] [staff_detail_screen.dart](file:///C:/Users/acer/.gemini/antigravity/scratch/advait_academy/lib/screens/staff_detail_screen.dart)
History view and "Add Monthly Salary" entry.

### Widgets
#### [NEW] [app_theme.dart](file:///C:/Users/acer/.gemini/antigravity/scratch/advait_academy/lib/widgets/app_theme.dart)
Common theme definitions (Green & Orange).
#### [NEW] [add_salary_bottom_sheet.dart](file:///C:/Users/acer/.gemini/antigravity/scratch/advait_academy/lib/widgets/add_salary_bottom_sheet.dart)
Interactive form for adding salary records.

## Verification Plan

### Automated Tests
- No unit tests requested, but logic for salary calculation will be verified manually.
- Verification of Firestore saves and reads.

### Manual Verification
1.  Launch app.
2.  Add a staff member of each category.
3.  Add salary records.
4.  Verify total calculation.
5.  CheckFirestore console for correct data hierarchy.
