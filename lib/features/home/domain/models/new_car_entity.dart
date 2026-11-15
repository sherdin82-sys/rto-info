/// Domain entity representing a new car model in India.
class NewCarEntity {
  final String id;
  final String name;
  final String manufacturer;
  final String category;
  final String exShowroomPrice;
  final String verifiedPricePrefix;
  final String imageAsset;
  final String? badge;
  final int? badgeColorValue;
  final String transmission;
  final String fuelType;
  final String seating;

  const NewCarEntity({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.category,
    required this.exShowroomPrice,
    this.verifiedPricePrefix = 'Starting at',
    required this.imageAsset,
    this.badge,
    this.badgeColorValue,
    required this.transmission,
    required this.fuelType,
    required this.seating,
  });

  static const List<NewCarEntity> topNewCars = [
    NewCarEntity(
      id: 'thar-roxx',
      name: 'Thar ROXX',
      manufacturer: 'Mahindra',
      category: '4x4 Off-Road SUV',
      exShowroomPrice: '₹ 12.99 Lakh*',
      imageAsset: 'assets/images/cars/thar_roxx.jpg',
      badge: 'NEW',
      badgeColorValue: 0xFFEF4444,
      transmission: 'Manual & Automatic',
      fuelType: 'Petrol & Diesel',
      seating: '5 Seater',
    ),
    NewCarEntity(
      id: 'creta-facelift',
      name: 'Creta',
      manufacturer: 'Hyundai',
      category: 'Mid-Size SUV',
      exShowroomPrice: '₹ 11.00 Lakh*',
      imageAsset: 'assets/images/cars/creta.jpg',
      badge: 'HOT',
      badgeColorValue: 0xFFFF7A00,
      transmission: 'Manual, IVT & DCT',
      fuelType: 'Petrol & Diesel',
      seating: '5 Seater',
    ),
    NewCarEntity(
      id: 'tata-nexon',
      name: 'Nexon',
      manufacturer: 'Tata Motors',
      category: 'Compact SUV (5★ BNCAP)',
      exShowroomPrice: '₹ 7.99 Lakh*',
      imageAsset: 'assets/images/cars/nexon.jpg',
      badge: 'BESTSELLER',
      badgeColorValue: 0xFF10B981,
      transmission: 'Manual, AMT & DCA',
      fuelType: 'Petrol, Diesel & CNG',
      seating: '5 Seater',
    ),
    NewCarEntity(
      id: 'swift-2024',
      name: 'Swift 4th Gen',
      manufacturer: 'Maruti Suzuki',
      category: 'Premium Hatchback',
      exShowroomPrice: '₹ 6.49 Lakh*',
      imageAsset: 'assets/images/cars/swift.jpg',
      badge: 'NEW',
      badgeColorValue: 0xFFEF4444,
      transmission: 'Manual & AGS',
      fuelType: 'Z-Series Petrol • 25.75 km/L',
      seating: '5 Seater',
    ),
    NewCarEntity(
      id: 'honda-elevate',
      name: 'Elevate',
      manufacturer: 'Honda',
      category: 'Mid-Size SUV',
      exShowroomPrice: '₹ 11.69 Lakh*',
      imageAsset: 'assets/images/cars/elevate.jpg',
      badge: 'POPULAR',
      badgeColorValue: 0xFF0066FF,
      transmission: '6-Speed MT & 7-Speed CVT',
      fuelType: '1.5L i-VTEC Petrol',
      seating: '5 Seater',
    ),
    NewCarEntity(
      id: 'vw-virtus',
      name: 'Virtus',
      manufacturer: 'Volkswagen',
      category: 'Performance Sedan (5★ GNCAP)',
      exShowroomPrice: '₹ 11.56 Lakh*',
      imageAsset: 'assets/images/cars/virtus.jpg',
      badge: 'TURBO',
      badgeColorValue: 0xFF8B5CF6,
      transmission: 'MT & 7-Speed DSG',
      fuelType: '1.0L & 1.5L TSI Petrol',
      seating: '5 Seater',
    ),
    NewCarEntity(
      id: 'kia-seltos',
      name: 'Seltos',
      manufacturer: 'Kia',
      category: 'Connected Tech SUV',
      exShowroomPrice: '₹ 10.90 Lakh*',
      imageAsset: 'assets/images/cars/seltos.jpg',
      badge: 'NEW',
      badgeColorValue: 0xFF06B6D4,
      transmission: 'MT, iMT, IVT & DCT',
      fuelType: '1.5L Turbo Petrol & Diesel',
      seating: '5 Seater',
    ),
    NewCarEntity(
      id: 'innova-hycross',
      name: 'Innova Hycross',
      manufacturer: 'Toyota',
      category: 'Hybrid MPV',
      exShowroomPrice: '₹ 19.77 Lakh*',
      imageAsset: 'assets/images/cars/innova_hycross.jpg',
      badge: 'HYBRID',
      badgeColorValue: 0xFF10B981,
      transmission: 'e-Drive & Direct CVT',
      fuelType: 'Self-Charging Strong Hybrid',
      seating: '7 & 8 Seater',
    ),
  ];
}

/// Domain entity representing an automotive manufacturer in India.
class CarBrandEntity {
  final String id;
  final String name;
  final String logoAsset;
  final int modelCount;
  final String popularModel;

  const CarBrandEntity({
    required this.id,
    required this.name,
    required this.logoAsset,
    required this.modelCount,
    required this.popularModel,
  });

  static const List<CarBrandEntity> allBrands = [
    CarBrandEntity(
      id: 'maruti_suzuki',
      name: 'Maruti Suzuki',
      logoAsset: 'assets/images/brands/maruti_suzuki.png',
      modelCount: 16,
      popularModel: 'Swift, Brezza, Grand Vitara',
    ),
    CarBrandEntity(
      id: 'hyundai',
      name: 'Hyundai',
      logoAsset: 'assets/images/brands/hyundai.png',
      modelCount: 12,
      popularModel: 'Creta, Venue, Verna',
    ),
    CarBrandEntity(
      id: 'tata',
      name: 'Tata Motors',
      logoAsset: 'assets/images/brands/tata.png',
      modelCount: 10,
      popularModel: 'Nexon, Punch, Harrier, Safari',
    ),
    CarBrandEntity(
      id: 'mahindra',
      name: 'Mahindra',
      logoAsset: 'assets/images/brands/mahindra.png',
      modelCount: 9,
      popularModel: 'Thar ROXX, Scorpio-N, XUV700',
    ),
    CarBrandEntity(
      id: 'toyota',
      name: 'Toyota',
      logoAsset: 'assets/images/brands/toyota.png',
      modelCount: 8,
      popularModel: 'Innova Hycross, Fortuner, Hyryder',
    ),
    CarBrandEntity(
      id: 'honda',
      name: 'Honda',
      logoAsset: 'assets/images/brands/honda.png',
      modelCount: 4,
      popularModel: 'Elevate, City, Amaze',
    ),
    CarBrandEntity(
      id: 'kia',
      name: 'Kia',
      logoAsset: 'assets/images/brands/kia.png',
      modelCount: 5,
      popularModel: 'Seltos, Sonet, Carens, EV6',
    ),
    CarBrandEntity(
      id: 'volkswagen',
      name: 'Volkswagen',
      logoAsset: 'assets/images/brands/volkswagen.png',
      modelCount: 3,
      popularModel: 'Virtus, Taigun, Tiguan',
    ),
    CarBrandEntity(
      id: 'skoda',
      name: 'Skoda',
      logoAsset: 'assets/images/brands/skoda.png',
      modelCount: 4,
      popularModel: 'Slavia, Kushaq, Kodiaq',
    ),
    CarBrandEntity(
      id: 'mg',
      name: 'MG Motor',
      logoAsset: 'assets/images/brands/mg.png',
      modelCount: 6,
      popularModel: 'Hector, Windsor EV, ZS EV',
    ),
    CarBrandEntity(
      id: 'renault',
      name: 'Renault',
      logoAsset: 'assets/images/brands/renault.png',
      modelCount: 3,
      popularModel: 'Kiger, Triber, Kwid',
    ),
    CarBrandEntity(
      id: 'nissan',
      name: 'Nissan',
      logoAsset: 'assets/images/brands/nissan.png',
      modelCount: 2,
      popularModel: 'Magnite, X-Trail',
    ),
    CarBrandEntity(
      id: 'bmw',
      name: 'BMW',
      logoAsset: 'assets/images/brands/bmw.png',
      modelCount: 14,
      popularModel: '3 Series, X1, X5, i4',
    ),
    CarBrandEntity(
      id: 'mercedes',
      name: 'Mercedes-Benz',
      logoAsset: 'assets/images/brands/mercedes.png',
      modelCount: 18,
      popularModel: 'C-Class, E-Class, GLC, GLE',
    ),
    CarBrandEntity(
      id: 'audi',
      name: 'Audi',
      logoAsset: 'assets/images/brands/audi.png',
      modelCount: 11,
      popularModel: 'A4, A6, Q3, Q5, e-tron',
    ),
  ];
}
