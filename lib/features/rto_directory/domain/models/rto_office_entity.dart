/// Domain model representing an RTO office in India.
class RtoOfficeEntity {
  final String rtoCode; // e.g. DL-01, MH-12
  final String officeName; // e.g. Mall Road Zonal Office
  final String city;
  final String state;
  final String stateCode; // e.g. DL, MH
  final String address;
  final String pincode;
  final String phone;
  final String website;

  const RtoOfficeEntity({
    required this.rtoCode,
    required this.officeName,
    required this.city,
    required this.state,
    required this.stateCode,
    required this.address,
    required this.pincode,
    required this.phone,
    required this.website,
  });

  Map<String, dynamic> toMap() => {
    'rtoCode': rtoCode,
    'officeName': officeName,
    'city': city,
    'state': state,
    'stateCode': stateCode,
    'address': address,
    'pincode': pincode,
    'phone': phone,
    'website': website,
  };

  factory RtoOfficeEntity.fromMap(Map<String, dynamic> map) => RtoOfficeEntity(
    rtoCode: map['rtoCode'] ?? '',
    officeName: map['officeName'] ?? '',
    city: map['city'] ?? '',
    state: map['state'] ?? '',
    stateCode: map['stateCode'] ?? '',
    address: map['address'] ?? '',
    pincode: map['pincode'] ?? '',
    phone: map['phone'] ?? '',
    website: map['website'] ?? '',
  );
}
