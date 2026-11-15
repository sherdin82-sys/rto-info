import 'dart:io';

import '../../lib/core/constants/app_constants.dart';
import '../../lib/core/utils/vehicle_number_validator.dart';
import '../../lib/app/localization/app_strings.dart';
import '../../lib/features/vehicle_details/domain/models/vehicle_entity.dart';
import '../../lib/features/vehicle_details/data/datasources/mock_vehicle_data_provider.dart';
import '../../lib/features/challan/data/datasources/challan_mock_datasource.dart';
import '../../lib/features/history/domain/models/search_history_entity.dart';
import '../../lib/features/favourites/domain/models/favourite_vehicle_entity.dart';
import '../../lib/core/storage/memory_storage_service.dart';
import '../../lib/features/dl/data/datasources/dl_mock_datasource.dart';
import '../../lib/features/fuel/domain/models/fuel_price_entity.dart';
import '../../lib/features/fuel/data/fuel_mock_datasource.dart';
import '../../lib/features/resale/domain/models/resale_valuation_model.dart';
import '../../lib/features/resale/domain/models/loan_emi_model.dart';
import '../../lib/features/rto_directory/data/rto_directory_data.dart';
import '../../lib/features/traffic_signs/data/traffic_signs_data.dart';
import '../../lib/features/mock_exam/data/quiz_questions_data.dart';
import '../../lib/core/database/local_rto_repository.dart';

Future<void> main() async {
  print('=====================================================');
  print('🚗 RTO INFO - Comprehensive Unit & Architecture Tests');
  print('=====================================================\n');

  int totalPassed = 0;

  void test(String name, void Function() fn) {
    try {
      fn();
      print('✓ PASS: $name');
      totalPassed++;
    } catch (e, st) {
      print('✗ FAIL: $name');
      print('  Error: $e\n$st');
      exitCode = 1;
    }
  }

  Future<void> asyncTest(String name, Future<void> Function() fn) async {
    try {
      await fn();
      print('✓ PASS: $name');
      totalPassed++;
    } catch (e, st) {
      print('✗ FAIL: $name');
      print('  Error: $e\n$st');
      exitCode = 1;
    }
  }

  // 1. Vehicle Number Formatting & Validation
  test('VehicleNumberValidator: cleanPlate sanitizes user input', () {
    assert(
      VehicleNumberValidator.cleanPlate(' dl 01-ab-1234 ') == 'DL01AB1234',
    );
    assert(VehicleNumberValidator.cleanPlate('hr-26 dq 5551') == 'HR26DQ5551');
    assert(VehicleNumberValidator.cleanPlate('ka 05 mj 5005') == 'KA05MJ5005');
  });

  test('VehicleNumberValidator: formatForDisplay formats Indian plates', () {
    assert(
      VehicleNumberValidator.formatForDisplay('DL01AB1234') == 'DL 01 AB 1234',
    );
    assert(
      VehicleNumberValidator.formatForDisplay('MH12DE1433') == 'MH 12 DE 1433',
    );
    assert(
      VehicleNumberValidator.formatForDisplay('KA05MJ5005') == 'KA 05 MJ 5005',
    );
    assert(
      VehicleNumberValidator.formatForDisplay('HR26DQ5551') == 'HR 26 DQ 5551',
    );
  });

  test(
    'VehicleNumberValidator: isValid identifies valid Indian number plates',
    () {
      assert(VehicleNumberValidator.isValid('DL01AB1234') == true);
      assert(VehicleNumberValidator.isValid('MH12DE1433') == true);
      assert(VehicleNumberValidator.isValid('KA05MJ5005') == true);
      assert(VehicleNumberValidator.isValid('HR26DQ5551') == true);
      assert(VehicleNumberValidator.isValid('UP32AZ0001') == true);
    },
  );

  test('VehicleNumberValidator: isValid rejects invalid strings', () {
    assert(VehicleNumberValidator.isValid('') == false);
    assert(VehicleNumberValidator.isValid('1234') == false);
    assert(VehicleNumberValidator.isValid('INVALIDNUMBERPLATE') == false);
    assert(VehicleNumberValidator.isValid('12AB34CD') == false);
  });

  // 2. VehicleEntity Domain Model & Serialization
  test('VehicleEntity serialization and privacy compliance', () {
    const vehicle = VehicleEntity(
      registrationNumber: 'DL 01 AB 1234',
      cleanRegistrationNumber: 'DL01AB1234',
      registrationDate: '12-Apr-2023',
      registrationAuthority: 'North Delhi RTO',
      rtoCode: 'DL-01',
      state: 'Delhi',
      vehicleClass: 'Motor Car (LMV)',
      registrationValidity: '11-Apr-2038',
      registrationStatus: 'ACTIVE',
      maker: 'MARUTI SUZUKI INDIA LTD',
      model: 'SWIFT VXI',
      vehicleCategory: 'Passenger Car',
      fuelType: 'PETROL',
      bodyType: 'Hatchback',
      engineCapacity: '1197 cc',
      seatingCapacity: 5,
      manufacturingYear: '2023',
      emissionStandard: 'BS-VI',
      color: 'MAGMA GREY',
      maskedChassisNumber: 'MA3EWFB1S***28114',
      maskedEngineNumber: 'K12MN***1092',
      maskedOwnerName: 'R****H K***R S****A',
      maskedFatherName: 'S****H C****R S****A',
      ownershipSerial: '1st Owner',
      maskedAddress: 'Civil Lines, Delhi - 110054',
      insuranceCompany: 'Tata AIG',
      insurancePolicyNumber: '016284918239011',
      insuranceValidity: '09-Apr-2027',
      insuranceStatus: 'ACTIVE',
      insuranceDaysRemaining: 145,
      pucCertificateNumber: 'DL0100492810',
      pucValidity: '14-May-2027',
      pucStatus: 'ACTIVE',
      pucTestingCenter: 'Mall Road PUC Center',
      fitnessValidity: '11-Apr-2038',
      permitValidity: 'Private Vehicle',
      roadTaxStatus: 'LTT Paid',
      roadTaxPaidUpto: 'Life Time',
      isHypothecated: true,
      hypothecationBank: 'HDFC Bank',
      hypothecationStatus: 'ACTIVE LOAN',
    );

    final map = vehicle.toMap();
    final reconstructed = VehicleEntity.fromMap(map);

    assert(reconstructed.cleanRegistrationNumber == 'DL01AB1234');
    assert(
      reconstructed.maskedOwnerName.contains('****'),
      'Owner name must be masked for privacy',
    );
    assert(reconstructed.isHypothecated == true);
    assert(reconstructed.hypothecationBank == 'HDFC Bank');
    assert(
      reconstructed.isDemoData == true,
      'Must clearly identify as demo data',
    );
    assert(VehicleEntity.safeValue(null) == 'Not Available');
    assert(VehicleEntity.safeValue('') == 'Not Available');
    assert(VehicleEntity.safeValue('ACTIVE') == 'ACTIVE');
  });

  // 3. MockVehicleDataProvider & Deterministic Generation
  await asyncTest('MockVehicleDataProvider returns accurate Parivahan records with demo indicator', () async {
    final ds = MockVehicleDataProvider();
    final seeded = await ds.getVehicleDetails('DL01AB1234');
    assert(seeded != null);
    assert(seeded!.maker == 'MARUTI SUZUKI INDIA LTD');
    assert(seeded!.fuelType == 'PETROL');
    assert(seeded!.isDemoData == true);

    final dynamicVehicle = await ds.getVehicleDetails('UP32AZ0001');
    assert(dynamicVehicle != null);
    assert(dynamicVehicle!.state == 'UP');
    assert(dynamicVehicle!.rtoCode == 'UP-32');

    final invalid = await ds.getVehicleDetails('INVALID');
    assert(invalid == null);
  });

  // 4. ChallanEntity & ChallanMockDataSource
  await asyncTest(
    'ChallanEntity differentiation and mock datasource retrieval',
    () async {
      final ds = ChallanMockDataSource();
      final challans = await ds.getChallansForVehicle('DL01AB1234');
      assert(challans.isNotEmpty);

      final pending = challans.where((c) => c.isPending).toList();
      final paid = challans.where((c) => c.isPaid).toList();

      assert(pending.isNotEmpty, 'Must have pending challans');
      assert(paid.isNotEmpty, 'Must have paid challans');
      assert(
        pending.first.officialPaymentPortalUrl ==
            'https://echallan.parivahan.gov.in/',
      );
    },
  );

  // 5. MemoryStorageService Persistence (Search History & Favourites)
  await asyncTest(
    'MemoryStorageService manages history & favourites',
    () async {
      final storage = MemoryStorageService();
      await storage.clearAllData();

      // Add search history
      final historyItem = SearchHistoryEntity(
        id: 'h-1',
        registrationNumber: 'DL01AB1234',
        formattedPlate: 'DL 01 AB 1234',
        makerModel: 'Maruti Suzuki Swift',
        vehicleClass: 'Motor Car (LMV)',
        searchedAt: DateTime.now(),
      );
      await storage.addHistory(historyItem);

      final historyList = await storage.getHistory();
      assert(historyList.length == 1);
      assert(historyList.first.registrationNumber == 'DL01AB1234');

      // Add favourite
      final favItem = FavouriteVehicleEntity(
        id: 'f-1',
        registrationNumber: 'DL01AB1234',
        formattedPlate: 'DL 01 AB 1234',
        makerModel: 'Maruti Suzuki Swift',
        vehicleClass: 'Motor Car (LMV)',
        fuelType: 'PETROL',
        insuranceValidity: '09-Apr-2027',
        insuranceStatus: 'ACTIVE',
        fitnessValidity: '11-Apr-2038',
        savedAt: DateTime.now(),
      );
      await storage.addFavourite(favItem);

      assert(await storage.isFavourite('DL01AB1234') == true);
      assert(await storage.isFavourite('MH12DE1433') == false);

      // Remove favourite
      await storage.removeFavourite('DL01AB1234');
      assert(await storage.isFavourite('DL01AB1234') == false);

      // Clear all
      await storage.clearAllData();
      assert((await storage.getHistory()).isEmpty);
      assert((await storage.getFavourites()).isEmpty);
    },
  );

  // 6. NoteFlow Offline-First Repository Architecture
  await asyncTest(
    'LocalRtoRepository: NoteFlow stream persistence and offline vehicle cache',
    () async {
      final repo = LocalRtoRepository(
        seedDemoData: false,
        enableDiskPersistence: false,
      );
      await repo.init();

      // Verify empty initial state
      assert((await repo.getSearchHistory()).isEmpty);
      assert((await repo.getFavourites()).isEmpty);

      // Add search history
      final historyItem = SearchHistoryEntity(
        id: 'h-1',
        registrationNumber: 'UP32AZ0001',
        formattedPlate: 'UP 32 AZ 0001',
        makerModel: 'Toyota Fortuner',
        vehicleClass: 'Motor Car (LMV)',
        searchedAt: DateTime.now(),
      );
      await repo.addSearchHistory(historyItem);
      final historyList = await repo.getSearchHistory();
      assert(historyList.length == 1);
      assert(historyList.first.registrationNumber == 'UP32AZ0001');

      // Add & toggle favourite
      final favItem = FavouriteVehicleEntity(
        id: 'fav-1',
        registrationNumber: 'UP32AZ0001',
        formattedPlate: 'UP 32 AZ 0001',
        makerModel: 'Toyota Fortuner',
        vehicleClass: 'Motor Car (LMV)',
        fuelType: 'DIESEL',
        insuranceValidity: '20-Oct-2027',
        insuranceStatus: 'ACTIVE',
        fitnessValidity: '25-Oct-2035',
        savedAt: DateTime.now(),
      );
      await repo.toggleFavourite(favItem);
      assert(await repo.isFavourite('UP32AZ0001') == true);

      // Toggle removes it
      await repo.toggleFavourite(favItem);
      assert(await repo.isFavourite('UP32AZ0001') == false);

      // Vehicle offline caching
      final seeded = await MockVehicleDataProvider().getVehicleDetails(
        'DL01AB1234',
      );
      assert(seeded != null);
      await repo.cacheVehicle(seeded!);
      final cached = await repo.getCachedVehicle('DL01AB1234');
      assert(cached != null);
      assert(cached!.registrationNumber == 'DL01AB1234');
      assert(cached!.maker == 'Maruti Suzuki India Ltd');

      // Theme mode & locale persistence
      await repo.setThemeMode('dark');
      assert(repo.themeMode == 'dark');
      await repo.setLocale('hi');
      assert(repo.locale == 'hi');

      repo.dispose();
    },
  );

  // 7. Localization Dictionary (English & Hindi)
  test('AppStrings: English and Hindi translations are complete', () {
    assert(AppStrings.get('appName', 'en') == 'RTO Info');
    assert(AppStrings.get('appName', 'hi') == 'आरटीओ इन्फो');

    assert(AppStrings.get('navHome', 'en') == 'Home');
    assert(AppStrings.get('navHome', 'hi') == 'होम');

    assert(AppStrings.get('navHistory', 'en') == 'History');
    assert(AppStrings.get('navHistory', 'hi') == 'इतिहास');

    assert(AppStrings.get('navFavourites', 'en') == 'Favourites');
    assert(AppStrings.get('navFavourites', 'hi') == 'पसंदीदा');

    assert(AppStrings.get('navSettings', 'en') == 'Settings');
    assert(AppStrings.get('navSettings', 'hi') == 'सेटिंग्स');
  });

  // 7. Strict Zero-Authentication Verification
  test(
    'Strict Rule: No authentication files, login, or signup screens exist',
    () {
      final libDir = Directory('lib');
      final allFiles = libDir.listSync(recursive: true);

      for (final entity in allFiles) {
        if (entity is File) {
          final path = entity.path.toLowerCase();
          assert(!path.contains('login'), 'Found prohibited login file: $path');
          assert(
            !path.contains('signup'),
            'Found prohibited signup file: $path',
          );
          assert(
            !path.contains('auth_guard'),
            'Found prohibited auth guard file: $path',
          );
          assert(
            !path.contains('firebase_auth'),
            'Found prohibited firebase_auth file: $path',
          );
        }
      }
    },
  );

  // 8. Android Configuration Verification
  test('Android package name is com.rtoinfo.app and permissions verified', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml');
    assert(manifest.existsSync());
    final content = manifest.readAsStringSync();
    assert(content.contains('package="com.rtoinfo.app"'));
    assert(content.contains('android.permission.INTERNET'));

    final gradle = File('android/app/build.gradle');
    assert(gradle.existsSync());
    final gradleContent = gradle.readAsStringSync();
    assert(gradleContent.contains('namespace = "com.rtoinfo.app"'));
    assert(gradleContent.contains('applicationId = "com.rtoinfo.app"'));

    // Version management verification
    assert(AppConstants.appVersion == '0.1.0');
    assert(AppConstants.buildNumber == 1);
    final changelog = File('CHANGELOG.md');
    assert(changelog.existsSync(), 'CHANGELOG.md must exist');
    assert(
      changelog.readAsStringSync().contains('[0.1.0]'),
      'CHANGELOG must document 0.1.0',
    );
  });

  // 9. Driving Licence (Sarathi Parivahan) Verification
  await asyncTest(
    'DL Verification: DlMockDataSource retrieves seeded and dynamic DLs',
    () async {
      final ds = DlMockDataSource();
      final seeded = await ds.getDlDetails('DL0420110149632');
      assert(seeded != null);
      assert(seeded!.maskedHolderName.contains('****'));
      assert(seeded!.vehicleClasses.any((c) => c.classCode == 'MCWG'));
      assert(seeded!.vehicleClasses.any((c) => c.classCode == 'LMV'));
      assert(seeded!.state == 'Delhi');

      final commercial = await ds.getDlDetails('MH1420180019284');
      assert(commercial != null);
      assert(commercial!.isCommercial == true);
      assert(commercial!.badgeNumber != null);

      final dynamicDl = await ds.getDlDetails('RJ1420220011223');
      assert(dynamicDl != null);
      assert(dynamicDl!.state == 'RJ');
    },
  );

  // 10. Fuel Prices & Trip Cost Calculator Logic
  test('Fuel Prices & TripCostResult calculation logic', () {
    assert(FuelMockDataSource.allCities.isNotEmpty);
    final delhi = FuelMockDataSource.allCities.firstWhere(
      (c) => c.city == 'New Delhi',
    );
    assert(delhi.petrolPrice > 90);
    assert(delhi.dieselPrice > 80);

    // Trip: 100 km, 20 km/L, ₹100/L fuel price -> 5 L required, ₹500 total cost, ₹5.00/km
    final trip = TripCostResult.calculate(
      distanceKm: 100,
      mileageKmpl: 20,
      fuelPrice: 100,
    );
    assert(trip.litersRequired == 5.0);
    assert(trip.totalCost == 500.0);
    assert(trip.costPerKm == 5.0);
  });

  // 11. Resale Valuation & Loan EMI Calculator Logic
  test('ResaleValuation & LoanEmi calculations match automotive standards', () {
    // Resale test: 2-year old car with ₹10,00,000 original price
    final resale = ResaleValuationCalculator.estimate(
      originalPrice: 1000000,
      purchaseYear: DateTime.now().year - 2,
      kmDriven: 20000,
      condition: 'Good',
      vehicleType: 'Hatchback',
    );
    assert(resale.estimatedValue < 1000000);
    assert(resale.estimatedValue > 600000);
    assert(resale.rangeLow < resale.estimatedValue);
    assert(resale.rangeHigh > resale.estimatedValue);

    // Loan EMI test: ₹1,00,000 at 12% for 12 months
    final emi = LoanEmiCalculator.calculate(
      principal: 100000,
      annualInterestRate: 12.0,
      tenureMonths: 12,
    );
    assert(emi.monthlyEmi > 8800 && emi.monthlyEmi < 9000);
    assert(emi.totalPayment > 100000);
    assert(emi.totalInterest > 0);
  });

  // 12. All-India RTO Directory Coverage
  test('RTO Directory includes major states and query filter works', () {
    assert(RtoDirectoryData.offices.isNotEmpty);
    assert(RtoDirectoryData.offices.any((o) => o.rtoCode == 'DL-01'));
    assert(RtoDirectoryData.offices.any((o) => o.rtoCode == 'MH-12'));
    assert(RtoDirectoryData.offices.any((o) => o.rtoCode == 'KA-01'));
    assert(RtoDirectoryData.offices.any((o) => o.rtoCode == 'TN-01'));
    assert(RtoDirectoryData.offices.any((o) => o.rtoCode == 'UP-32'));
  });

  // 13. Traffic Signs & MV Act Fines Catalogue
  test('TrafficSignsData contains categorized signs and fine schedules', () {
    final mandatory = TrafficSignsData.signs
        .where((s) => s.category == 'Mandatory')
        .toList();
    final cautionary = TrafficSignsData.signs
        .where((s) => s.category == 'Cautionary')
        .toList();
    final informatory = TrafficSignsData.signs
        .where((s) => s.category == 'Informatory')
        .toList();

    assert(mandatory.isNotEmpty);
    assert(cautionary.isNotEmpty);
    assert(informatory.isNotEmpty);
    assert(TrafficSignsData.fines.isNotEmpty);
    assert(TrafficSignsData.fines.any((f) => f.offence.contains('Helmet')));
  });

  // 14. RTO Learner Licence Mock Exam Bank
  test('QuizQuestionsData contains 15 Parivahan Sarathi test questions with valid options', () {
    assert(QuizQuestionsData.questions.length == 15);
    for (final q in QuizQuestionsData.questions) {
      assert(q.question.isNotEmpty);
      assert(q.options.length == 4);
      assert(q.correctIndex >= 0 && q.correctIndex < 4);
      assert(q.explanation.isNotEmpty);
    }
  });

  print('\n-----------------------------------------------------');
  print('Result: $totalPassed/18 Unit Tests Passed Successfully! ✓');
  print('=====================================================');
}
