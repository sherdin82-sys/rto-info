# Changelog

All notable changes to the **RTO Info** application will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.2.1] - 2026-11-15

### Changed & Optimized
- **Compact Premium Flutter UI & Global Layout Refinement**:
  - Completely audited and refined component hierarchy and spacing across all 15 application modules, eliminating oversized elements, excessive whitespace, and truncated descriptions.
- **Home Screen Redesign**:
  - **Header**: Compact 52dp height with aligned 32x32 logo, app title, automotive subtitle, and compact language/theme switches.
  - **HSRP Plate Search**: Sleek 48dp height container, 38px IND strip with blue Ashoka chakra dot, monospace plate styling, and aligned search action.
  - **Sample Registration Chips**: Single-row horizontal scrollable ribbon (24dp height) for quick demo plate selection.
  - **Fuel Rates Banner**: Compact ticker card (~48dp height) with live indicator dot, fuel pump icon, high-contrast prices, and direct navigation to Fuel screen.
  - **Essential RTO Services Grid**: Fully overhauled 2-column grid using `LayoutBuilder` targeting 125–145 dp card height (`aspectRatio ~ 1.32`). Cards feature compact 34x34 icon containers, readable 13sp titles, and 2-line wrapped descriptions without truncation. Removed uninformative status badges (VERIFIED, PORTAL, CALC, DAILY, etc.).
  - **Section 139 Compliance Banner**: Compact card with 10dp padding, 18px shield icon, and clear statutory legal text.
  - **Bottom Navigation**: M3 `NavigationBar` height reduced to 56dp with refined selected indicator pill and 10.5sp labels.
- **Global Layout & Component-Level Optimization**:
  - `VehicleDetailsScreen`: Compacted 4-section layout (12px divider spacing, 14/10 screen padding, compact EMV chip RC Smart Card).
  - `ChallanScreen`: Compact summary banner, 10/12 violation cards, and 32dp action buttons.
  - `DlScreen`: Compact search card, 8px field spacing, 38dp verify button, and compact Sarathi Smart Card.
  - `FuelRatesScreen` & `TripCalculatorScreen`: Compact city rate cards, 8px separators, and refined trip expense calculator forms.
  - `ResaleScreen` & `LoanEmiScreen`: Compact inputs, 8px gaps, 38dp calculation buttons, and compact breakdown cards.
  - `RtoDirectoryScreen`: Compact 32dp state filter chips and compact office cards.
  - `TrafficSignsScreen`: Compact 36x36 sign icon circles, 10/12 card padding, and 8px list separators.
  - `MockExamScreen`: Compact 4dp progress indicator, 12dp question card, and 9dp vertical padding on option cards.
  - `HistoryScreen` & `FavouritesScreen`: Compact list items (10/8 padding, 32x32 icons, 6px separators).
  - `SettingsScreen`: Compact `RadioListTile` items with `VisualDensity.compact` and 4px card padding.
- **Architecture Integrity**:
  - 100% Flutter/Dart Native UI with zero web or React dependencies.
  - Strict zero-authentication flow preserved.
  - All 18 unit tests verified passing.

---

## [0.2.0] - 2026-11-15

### Added & Redesigned
- **Strict 100% Flutter & Dart Native UI**: Completely unified automotive design system built purely in Flutter widgets and Dart — zero React, HTML, CSS, JavaScript, or WebView.
- **Centralized Automotive Design Tokens**:
  - `AppColors`: Deep navy backgrounds (`0xFF080D1A`), electric blue interactions (`0xFF0066FF`), warm saffron/orange highlights (`0xFFFF7A00`), metallic gold accents (`0xFFFFD700`), and HSRP plate styling.
  - `AppSpacing`: Unified 8-point geometric spatial scale (`xs`, `s`, `m`, `l`, `xl`, `xxl`, `xxxl`, `huge`).
  - `AppRadius`: Harmonized border radius tokens (`xs: 6`, `s: 10`, `m: 14`, `card: 16`, `l: 18`, `xl: 24`, `button: 12`, `pill: 999`).
  - `AppTypography`: Display, title, body, label styles, monospaced HSRP plate styling, and automotive financial counters.
- **Unified Shared Widget System**:
  - `AppAppBar`: Standardized header across all screens with automotive subtitles, action slots, theme toggle, and bilingual language switch.
  - `PremiumCard`: Upgraded with glass borders, gradient backgrounds, and soft ambient drop shadows.
  - `AppTextField`: Automotive text input with prefix/suffix icons, clear button, and validation states.
  - `AppButton`: Reusable action button supporting primary, secondary, accent, and danger variants with loading states.
  - `AppBottomNavigation`: Bottom navigation bar with automotive indicator pill and reactive tab switching.
  - `StatusBadge`: Badging with pulsating dot indicator and high-contrast dark mode legibility.
  - `LoadingView` & `ErrorView`: Automotive animated loading spinner and error recovery views with retry triggers.
- **Complete Feature Module Modernization**:
  - `HomeScreen`: Live fuel ticker preview, HSRP plate input, sample plates quick chips, recent searches carousel, 10 essential RTO services, and Section 139 compliance banner.
  - `VehicleDetailsScreen`: Metallic gold EMV chip RC Smart Card, Section 6 privacy masking, countdown validity meters, and native share sheet intent.
  - `VehicleSearchScreen`: High-speed number plate query interface with clean search bar and error feedback.
  - `ChallanScreen`: Outstanding penalty summary banner, All/Pending/Settled filter chips, and official Parivahan payment portal disclaimer.
  - `DlScreen`: Sarathi Parivahan Smart DL Card format with vehicle category endorsements and badge indicators.
  - `FuelRatesScreen`: Daily fuel ticker across Indian metros, search filter, Petrol/Diesel/CNG rate pills, and integrated trip cost estimator.
  - `ResaleScreen`: Indian used-vehicle fair market value calculator, depreciation meters, and auto loan EMI amortization breakdown.
  - `RtoDirectoryScreen`: All-India RTO directory with state filter chips, helpline telephone actions, and state transport portal links.
  - `TrafficSignsScreen`: 4-tab handbook covering Mandatory, Cautionary, Informatory signs, and MV Act 2019 fines schedule.
  - `MockExamScreen`: Parivahan Sarathi LL examination simulation, question progress bar, instant feedback with legal explanations, and final scorecard.
  - `HistoryScreen`: Chronological search history list with individual swipe-to-dismiss and clear-all confirmation dialog.
  - `FavouritesScreen`: Bookmarked vehicle cards with quick actions for Challan and RC lookups.
  - `SettingsScreen`: Theme selector, language switcher, native Android device info reader via `MethodChannel`, and local data reset.

---

## [0.1.0] - 2026-11-15

### Added
- **Zero-Authentication Flow**: Instant access to all dashboard features upon launch without login, signup, or account guards.
- **HSRP Number Plate Lookup**: High Security Registration Plate format parser, uppercase validator, and spacing generator.
- **Parivahan RC Smart Card**: Digital Registration Certificate with gold chip aesthetics, Section 6 specifications, and statutory privacy masking on owner credentials.
- **Traffic e-Challan Module**: Clear differentiation between Paid and Pending notices with violation descriptions and a direct link to the official [Parivahan Payment Portal](https://echallan.parivahan.gov.in/).
- **Driving Licence (DL) Verification**: Sarathi Parivahan look, Non-Transport and Transport validities, and endorsed vehicle classes (MCWG, LMV, TRANS).
- **Daily Fuel Rates & Trip Cost Calculator**: Live petrol, diesel, and CNG rates across 13+ metro cities with interactive fuel consumption and trip expenditure calculator.
- **Resale Valuation & Loan EMI Calculator**: Used vehicle market valuation based on Indian automotive depreciation models and auto loan EMI amortization calculator.
- **All-India RTO Directory**: Comprehensive directory covering all 36 States/UTs with instant search by RTO code, helpline phone numbers, and official state transport links.
- **Traffic Signs & MV Act Fines Handbook**: Categorized catalogue of Mandatory, Cautionary, and Informatory signs with official Motor Vehicles Amendment Act penalties.
- **RTO Learner's Licence Mock Exam**: 15-question interactive simulation of the Parivahan Sarathi computer-based test with 60% passing benchmark, explanations, and review certificate.
- **Local Storage**: Search history and bookmarks/favourites persistence with in-memory fallback.
- **Localization & Themes**: Full English and Hindi (`हिंदी`) translation with Material 3 Light and Dark themes.
- **Android & CI/CD**: Android packaging configured for `com.rtoinfo.app` (minSdk 24, compileSdk 36) with automated GitHub Actions workflow for release APK and AAB compilation.
- **NoteFlow Reference Architecture Alignment**:
  - Kotlin `MethodChannel` (`com.rtoinfo.app/native`) for hardware info, battery levels, network status, and native share sheets.
  - Drift / SQLite DDL schema contracts for local persistence.
  - Offline-first `LocalRtoRepository` with reactive broadcast streams and asynchronous disk storage.
  - NoteFlow design components (`PremiumCard`, `EmptyStateView`) and typography system.
  - 15 modular feature directories cleanly separating data, domain, and presentation layers.
  - Multi-architecture `--split-per-abi` release APK pipeline.
