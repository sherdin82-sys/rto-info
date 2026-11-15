# 🚗 RTO Info – Production Indian Vehicle Information Application

> A production-quality, automotive-themed Indian vehicle registration information application built using **Flutter**, **Dart**, **Riverpod**, and **GoRouter**.

Designed to provide fast, reliable, legally compliant access to Indian vehicle registration certificates (RC), insurance validity, PUC certificates, traffic e-challans, driving licence verification, and transport services under the **Motor Vehicles Act (1988/2019)** and **Central Motor Vehicles Rules (CMVR)**.

---

## 📱 Android Application Details

- **Application Name**: RTO Info
- **Package Name (Application ID)**: `com.rtoinfo.app`
- **Minimum SDK**: Android API 24 (Android 7.0 Nougat)
- **Target / Compile SDK**: Android API 36
- **JDK Requirement**: OpenJDK 17 (Temurin)

---

## 🎨 Automotive Design System

- **Primary Color**: Deep Navy Blue (`#0B1B3D`)
- **Secondary Color**: Electric Blue (`#0066FF`)
- **Accent Color**: Indian Transport Saffron (`#FF9933`)
- **Status Colors**: Emerald Green (`#10B981`), Amber (`#F59E0B`), Crimson (`#EF4444`)
- **Modes**: Full Light Mode & Dark Navy/Charcoal Mode with dynamic ThemeMode switching
- **Localization**: Dual English and Hindi (`हिंदी`) language support

---

## 🧭 Navigation & Core Structure

The application features a modern Material 3 bottom navigation bar that launches **directly into the Home Dashboard** (strictly without authentication guards or sign-in screens):

1. **Home (`/`)**: Prominent HSRP number plate search bar, sample plate pills, quick tools grid, and Section 139 digital document compliance notice.
2. **History (`/history`)**: Chronological local search history with timestamp, vehicle summary, and clear options.
3. **Favourites (`/favourites`)**: Bookmarked personal and family vehicles with quick status indicators for insurance and fitness.
4. **Settings (`/settings`)**: Theme switcher (System / Light / Dark), language selector (English / Hindi), data reset, and about screen.

### Secondary Feature Routes:
- `/rc`: Complete Parivahan RC smart card details, specifications, and compliance records.
- `/challan`: Traffic violation ledger, police unit, legal section, and fine amounts.
- `/dl`: Sarathi Driving Licence verification with Form 7 card view.
- `/fuel`: Daily petrol, diesel, and CNG rates across Indian metro cities.
- `/resale`: Multi-factor used vehicle valuation and auto loan monthly EMI calculator.
- `/rto`: All-India RTO directory covering 36 States and Union Territories.
- `/signs`: Classified road signs (Mandatory, Cautionary, Informatory) with penalties.
- `/exam`: Learner's Licence mock exam simulator with 60% passing criteria.

---

## 🏛️ Clean Architecture & Project Structure

```
lib/
├── app/
│   ├── app.dart                          # Root MaterialApp.router configuration
│   ├── router/
│   │   └── app_router.dart               # GoRouter with StatefulShellRoute bottom nav
│   ├── theme/
│   │   ├── app_colors.dart               # Automotive brand palette
│   │   ├── app_theme.dart                # Material 3 light & dark theme definitions
│   │   └── app_typography.dart           # Typography and number plate monospace styles
│   └── localization/
│       ├── app_locale.dart               # Riverpod Locale & ThemeMode state notifiers
│       └── app_strings.dart              # English and Hindi localization dictionary
├── core/
│   ├── constants/
│   │   └── app_constants.dart            # App constants, plate regex, sample data
│   ├── utils/
│   │   ├── vehicle_number_validator.dart # Pure-Dart number plate sanitization & validation
│   │   └── vehicle_number_formatter.dart # Flutter TextInputFormatter for HSRP plates
│   └── widgets/
│       ├── app_scaffold_with_nav_bar.dart# Shell scaffold with bottom navigation bar
│       ├── vehicle_search_bar.dart       # Prominent HSRP number plate search input
│       └── status_badge.dart             # Semantic compliance status pill badge
├── features/
│   ├── home/presentation/                # Home dashboard
│   ├── history/presentation/             # Search history screen
│   ├── favourites/presentation/          # Saved favourites screen
│   ├── settings/presentation/            # Settings & localization screen
│   ├── vehicle_details/presentation/     # Detailed RC profile screen
│   ├── challan/presentation/             # e-Challan records screen
│   ├── dl/presentation/                  # DL verification screen
│   └── tools/presentation/               # Fuel, resale, RTO directory, signs screens
└── main.dart                             # Application entry point with ProviderScope
```

---

## 🧪 Testing & Verification

Run the core architecture and unit test suite directly:

```bash
dart run test/unit/rto_info_core_test.dart
```

All 10 test suites verify:
- Input sanitization and Indian number plate format validation.
- Android package name `com.rtoinfo.app` across Manifest and Gradle files.
- Dual English and Hindi localizations.
- Zero-authentication guarantee (no login/signup screens or auth dependencies).
- Android permissions and CI workflow configuration.

---

## 📦 Automated Release APK Building

Automated GitHub Actions CI workflow is configured at [`.github/workflows/build-apk.yml`](.github/workflows/build-apk.yml):
- Sets up JDK 17 (Temurin) and Flutter SDK stable.
- Runs `flutter analyze` and `dart run test/unit/rto_info_core_test.dart`.
- Generates release APKs (`flutter build apk --release --split-per-abi`).
- Uploads release APK artifacts and publishes GitHub releases upon tag push.
