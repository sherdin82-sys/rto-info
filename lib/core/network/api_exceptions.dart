/// Base exception for all network and API errors in RTO Info.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const ApiException({required this.message, this.statusCode, this.details});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NoInternetException extends ApiException {
  const NoInternetException({
    super.message = 'No active internet connection detected. Please check network settings.',
  });
}

class TimeoutException extends ApiException {
  const TimeoutException({
    super.message =
        'The request to Parivahan servers timed out. Please try again later.',
  });
}

class ServerException extends ApiException {
  const ServerException({
    super.message = 'Parivahan gateway server error. Please try again later.',
    super.statusCode,
    super.details,
  });
}

class VehicleNotFoundException extends ApiException {
  final String registrationNumber;
  const VehicleNotFoundException({
    required this.registrationNumber,
    super.message = 'No registration records found for this vehicle number.',
  });
}

class NoCredentialsException extends ApiException {
  const NoCredentialsException({
    super.message = 'Authorized Government Gateway credentials not configured. Please use demonstration data.',
  });
}
