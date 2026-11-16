# Changelog

All notable changes to the **RTO Info** application will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.2.6] - 2026-11-16

### Enhanced & Refined
- **Vehicle Registration Search Input Overhaul (`HomeScreen` & `VehicleSearchBar`)**:
  - **Typography & Proportions**:
    - Increased input font size to 21sp with semibold weight (`FontWeight.w600`) and 1.5 letter spacing for optimal readability of Indian High Security Registration Plates.
    - Set `textAlignVertical: TextAlignVertical.center` to perfectly vertically center registration numbers within the HSRP container.
    - Matched cursor and selection highlight colors to the electric blue brand theme (`0xFF0066FF`).
  - **Clean Container Architecture (Removed Inner Borders)**:
    - Stripped all redundant inner borders, outlines, underlines, and nested backgrounds from `TextField` (`border: InputBorder.none`, `enabledBorder: InputBorder.none`, `focusedBorder: InputBorder.none`, `disabledBorder: InputBorder.none`, `errorBorder: InputBorder.none`, `focusedErrorBorder: InputBorder.none`, `filled: false`, `contentPadding: EdgeInsets.zero`).
    - Retained the outer HSRP container with authentic blue `IND` strip, Ashoka Chakra dot, and primary action button.
- **Genuine High-Resolution Manufacturer Logo Integration (`HomeScreen` & `VehicleSearchScreen`)**:
  - **Standalone Vector-Rendered Transparent Emblems**:
    - Replaced low-resolution or full-wordmark images with official standalone emblem transparent PNGs for all 15 Indian manufacturers:
      - Maruti Suzuki (Suzuki "S" symbol), Hyundai (slanted "H" oval), Tata Motors (circular emblem), Mahindra (2021 Twin Peaks emblem), Toyota (triple-oval symbol), Honda ("H" mark), Kia (2021 connected mark), Volkswagen (VW roundel), Skoda (winged arrow), MG Motor (octagonal badge), Renault (2021 geometric diamond), Nissan (2020 illuminated ring), BMW (blue/white roundel), Mercedes-Benz (three-pointed star), Audi (interlocking four rings).
  - **Standardized Display Dimensions**:
    - Increased logo display size to 60x54dp within 76x64dp crisp pure-white badge cards with `BoxFit.contain` (12dp radius, high-contrast borders and subtle shadows).
    - Preserved exact aspect ratios with zero stretching or distortion in both Light and Dark themes.
    - Standardized across both `HomeScreen` and `VehicleSearchScreen`.

---

## [0.2.5] - 2026-11-16

### Enhanced & Refined
- **Vehicle Search Refinement & Live HSRP Plate Preview (`VehicleSearchScreen`)**:
  - **Live HSRP Plate Preview Simulation**:
    - Real-time animated simulation of Indian High Security Registration Plate (HSRP) conforming to CMVR Rule 50.
    - Features blue MoRTH IND strip, Ashoka Chakra dot, hot-stamped chromium hologram foil, and embossed typography.
    - Dynamic color adaptation by vehicle category: Electric Vehicles (MoRTH green background), Commercial transport (taxi yellow background), and Passenger vehicles (standard metallic white).
    - Intelligent Indian state and RTO territory detection (e.g., `DL` -> Delhi NCR, `MH` -> Maharashtra, `KA` -> Karnataka, `HR` -> Haryana, `UP` -> Uttar Pradesh, `BH` -> Bharat Series).
  - **Vehicle Category Quick Filters**:
    - Interactive filter chips for `All Vehicles`, `Cars (LMV)`, `Bikes (2W)`, `Electric (EV)`, and `Commercial`.
    - Instant dynamic filtering of sample records and live plate styling.
  - **Explore by Manufacturer Integration**:
    - Full horizontal catalog of 15 authentic Indian manufacturer logos directly in `VehicleSearchScreen`.
    - Interactive brand details modal sheet showing brand origin, segment leadership, model count, price ranges, popular model chips, and direct one-tap brand search.
    - Supports deep linking and query routing (`/search?brand=tata`).
  - **Curated All-India Sample Vehicles**:
    - Expanded curated vehicle samples with authentic registrations across Delhi, Maharashtra, Karnataka, Haryana, Uttar Pradesh, and Tamil Nadu.
    - Quick one-tap plate selection with immediate route execution.
  - **Statutory MoRTH Parivahan Verification Checklist**:
    - Visual guide outlining verified fields: Owner, Hypothecation bank, Insurance validity, PUCC emissions, and Virtual Court e-Challan records.
- **HomeScreen Vehicle Search Enhancements**:
  - Added auto-formatting via `VehicleNumberFormatter` with uppercase enforcement.
  - Added interactive clear button (`X`) when text is typed.
  - Added user validation feedback snackbars on empty or invalid registration plate submissions.
  - Aligned search action with elevated primary button for optimal thumb reach.
- **Manufacturer Logo High-Contrast Rendering**:
  - Upgraded brand logo cards with crisp pure-white badge containers and elevated borders, ensuring 100% brand fidelity, crisp contrast, and accurate colors in both Light and Dark themes.
  - Enriched `CarBrandEntity` with origin country, price range, segment leader focus, and verified model lineups.

---

## [0.2.4] - 2026-11-15

### Added & Enhanced
- **Daily Fuel Rates Horizontal Section**:
  - Restored high-visibility horizontal carousel with city cards displaying city name, state, petrol price (₹/L), diesel price (₹/L), CNG price (₹/kg), and last-updated timestamp.
  - Price increase/decrease indicators (`▲ +₹0.12`, `▼ -₹0.05`, `▬ 0.00`) verified via IOCL, BPCL & HPCL data.
  - Prioritizes user's currently selected city first in the list.
  - Header with `View all` action navigating directly to [FuelRatesScreen](file:///data/data/com.termux/files/home/gravity-project/rto-info/lib/features/fuel/presentation/fuel_rates_screen.dart) (`/fuel`).
- **Top New Cars Marketplace Hub**:
  - Replaced legacy used-cars section with authentic **Top New Cars** horizontal marketplace cards.
  - Uses genuine vehicle photographs of Indian 2026 models (Mahindra Thar ROXX, Hyundai Creta Facelift, Tata Nexon, Maruti Suzuki Swift 4th Gen, Honda Elevate, Volkswagen Virtus, Kia Seltos, Toyota Innova Hycross).
  - Displays verified starting ex-showroom prices (`From ₹ 12.99 Lakh*`), manufacturer, model, category pills (`4x4 Off-Road SUV`, `Mid-Size SUV`, etc.), and `NEW`/`HOT`/`HYBRID` badges.
- **Explore New Cars by Brand**:
  - Replaced used-cars brand badges with genuine transparent automotive manufacturer logos across 15 major Indian-market manufacturers:
    - Maruti Suzuki, Hyundai, Tata Motors, Mahindra, Toyota, Honda, Kia, Volkswagen, Skoda, MG Motor, Renault, Nissan, BMW, Mercedes-Benz, Audi.
    - Card displays official logo, brand name, and total available model count.
    - Interactive modal bottom sheet on tap detailing popular models with direct routes to search and valuation.
    - `View all` navigation to vehicle search.
- **Optimized Section Hierarchy**:
  - 1. Top App Bar with location selector & garage shortcut.
  - 2. Promotional automotive hero banner.
  - 3. Floating HSRP plate search & demo chips.
  - 4. Essential RTO quick services (8 primary + 4 driver utilities).
  - 5. Daily Fuel Rates horizontal carousel.
  - 6. Buy / Explore New Cars quick actions.
  - 7. Top New Cars marketplace cards.
  - 8. Explore New Cars by Brand.
  - 9. Offers for you promo banners.
  - 10. Trending Videos & road rules.
  - 11. Trending new bikes, Section 139 CMVR compliance, testimonials.
  - 12. Parivahan FAQs accordion.
  - 13. RTO Info branded footer.
  - 14. Preserved bottom navigation.
- **Unit & Architecture Tests**:
  - Added test suites for `NewCarEntity` and `CarBrandEntity` verifying asset existence, prices, and manufacturer mappings.
  - All 20 unit tests verified passing.

---

## [0.2.3] - 2026-11-15

### Enhanced & Restored
- **Homepage Enhancement & Complete Feature Restoration (`HomeScreen`)**:
  - **Restored Live City Fuel Rates Ticker**:
    - Real-time display of daily Petrol, Diesel, and CNG rates with daily price change pills (e.g. `▲ +₹0.12`, `▼ -₹0.05`, `▬ 0.00`).
    - **Dynamic City Sync**: Selecting any of the 14 Indian cities from the top bar dropdown immediately updates the fuel ticker rates for that specific city.
    - Quick navigation to full Fuel Rates & Trip Calculator screen (`/fuel`).
  - **Restored Comprehensive 4x2 Core Services Grid (8 Distinct Features)**:
    - `RC Details` (Electric blue) -> `/rc`
    - `Pay challan` (Crimson red) -> `/challan`
    - `DL Verify` (Emerald green) -> `/dl` (Restored)
    - `Fuel Rates` (Warm orange) -> `/fuel` (Restored)
    - `Resale Value` (Purple) -> `/resale` (Restored)
    - `Car Loan EMI` (Teal) -> `/loan-emi`
    - `RTO Directory` (Sky blue) -> `/rto` (Restored & renamed from "Car check")
    - `FASTag Manager` (Amber) -> Interactive FASTag services modal
  - **Restored Driver Utilities & Safety Hub (2x2 Grid)**:
    - `Mock Exam` (Teal) -> `/exam` (Sarathi Learner Licence practice test simulation)
    - `Traffic Signs` (Blue) -> `/signs` (100+ road safety signs handbook & fine schedule)
    - `Trip Cost` (Rose) -> `/trip-calculator` (Distance, mileage, and fuel expense estimator)
    - `RC Search` (Indigo) -> `/search` (All-India number plate lookup)
  - **Restored CMVR Section 139 Statutory Compliance Banner**:
    - Official legal assurance card citing Motor Vehicles Act Section 139 & CMVR Rule 139 for digital RC/DL validity on DigiLocker / mParivahan.
  - **Enhanced Interactive Components**:
    - Clickable brand filter badges (Maruti, Hyundai, Tata, Honda, Mahindra, Toyota, Kia) linking directly to vehicle search.
    - Trending used cars (Verna, Creta, Thar, City) with watermark rankings linking to fair market resale valuation.
    - Promotional hero carousel expanded with Sarathi DL verification slide.
  - **Architecture Integrity**:
    - 100% pure Flutter & Dart native implementation without web, HTML, or React dependencies.
    - Strict zero-authentication flow preserved.
    - All 18 unit tests verified passing.

---

## [0.2.2] - 2026-11-15

### Added & Redesigned
- **CarInfo-Referenced Premium Homepage Redesign (`HomeScreen`)**:
  - **Top App Bar**: Brand logo with location selector (`📍 Delhi NCR ∨`), interactive bottom sheet city switcher (12 major Indian metros), `🏠 My garage` shortcut linking directly to saved vehicles (`/favourites`), language switcher (`EN`/`हिं`), and theme toggle.
  - **Promotional Hero Carousel**: Petrol teal gradient banner with multi-slide carousel, verified badge illustrations, `Buy now` / `Check now` CTA buttons, dot pagination, and floating `Enter your Vehicle Number` badge.
  - **Floating HSRP Search Box**: Clean card overlapping the hero banner with deep blue `IND` strip, Ashoka Chakra circle, monospace plate input `(e.g. DL 01 AB 1234)`, and circular search action.
  - **Single-Row Sample Plate Chips**: Fast demo selection chips (`DL01AB1234`, `MH02CD5678`, `KA03EF9012`, `HR26DQ5551`, `UP16Z9999`).
  - **4x2 Primary Services Grid (8 Services)**:
    - `Pay challan` (Terminal POS icon, red accent) -> `/challan`
    - `Car insurance` (Car with shield, cyan accent) -> `/rc`
    - `Bike insurance` (Motorcycle with shield, green accent) -> `/rc`
    - `Vehicle report` (Clipboard report, blue accent) -> `/rc`
    - `RC search` (Magnifying glass, indigo accent) -> `/search`
    - `FASTag Manager` (FASTag toll tag, amber accent) -> FASTag dialog & banking portals
    - `Car check` (Diagnostics, purple accent) -> `/rto`
    - `Car loan` (Loan & EMI, teal accent) -> `/loan-emi`
  - **Buy & Sell Car Hub**: 4 quick action cards (`Buy used car`, `Buy new car`, `Sell your car`, `Car loan`).
  - **Top 10 Trending Used Cars**: Horizontal cards with large watermark ranking numbers `01`, `02`, `03`, `04` (Hyundai Verna, Hyundai Creta, Mahindra Thar, Honda City).
  - **Explore Used Car by Brand**: Circular brand badges (Maruti, Hyundai, Tata, Honda, Mahindra, Toyota, Kia).
  - **Offers for You**: Horizontal promotional banners for FASTag and e-Challan penalty alerts.
  - **Trending Videos & Traffic Rules**: 9:16 vertical video cards with play buttons linking to Road Safety, e-Challan, and Parivahan Sarathi LL exam simulation.
  - **Trending New Bikes**: Horizontal cards featuring Ola S1 X Electric, Royal Enfield Bullet 350, and Bajaj Pulsar NS200.
  - **User Testimonials**: Verified ratings and testimonials.
  - **Parivahan & RTO FAQs Accordion**: Expandable Q&A covering virtual RC validity under CMVR Rule 139, finding RC in Parivahan, and checking paid challans.
  - **Footer Brand Banner**: `RTO Info` - India's app for complete vehicle management.
- **100% Pure Flutter/Dart Native Implementation**:
  - Zero web, HTML, or React dependencies.
  - Zero authentication guard, instant dashboard access.
  - All 18 unit tests verified passing.

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
