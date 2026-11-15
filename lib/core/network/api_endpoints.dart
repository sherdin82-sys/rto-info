/// ApiEndpoints defines base configuration and official government gateway contracts.
/// NOTE: Direct Parivahan Vahan/Sarathi APIs require enterprise ministry credentials,
/// client SSL certificates, and IP whitelisting. No fake endpoints are invented.
class ApiEndpoints {
  ApiEndpoints._();

  // Future Authorized Government Gateway Configuration
  // When ministry access credentials are provided, set this base URL.
  static const String defaultParivahanBaseUrl = 'https://parivahan.gov.in';

  // Future Authorized Endpoint Paths (Standard Parivahan Vahan API contract)
  static const String pathRcDetails = '/vahan/v1/rc/lookup';
  static const String pathChallans = '/echallan/v1/vehicle/search';
  static const String pathDlDetails = '/sarathi/v1/dl/lookup';

  // Official Public Citizen Web Portals (for web verification & payments)
  static const String officialEChallanPortalUrl =
      'https://echallan.parivahan.gov.in/';
  static const String officialVahanPortalUrl =
      'https://vahan.parivahan.gov.in/';
  static const String officialSarathiPortalUrl =
      'https://sarathi.parivahan.gov.in/';
}
