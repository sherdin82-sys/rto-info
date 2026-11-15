import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/vehicle_number_validator.dart';

class VehicleSearchState {
  final String query;
  final String cleanPlate;
  final bool isValid;
  final String? errorMessage;

  const VehicleSearchState({
    this.query = '',
    this.cleanPlate = '',
    this.isValid = false,
    this.errorMessage,
  });

  VehicleSearchState copyWith({
    String? query,
    String? cleanPlate,
    bool? isValid,
    String? errorMessage,
  }) {
    return VehicleSearchState(
      query: query ?? this.query,
      cleanPlate: cleanPlate ?? this.cleanPlate,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage,
    );
  }
}

class VehicleSearchNotifier extends StateNotifier<VehicleSearchState> {
  VehicleSearchNotifier() : super(const VehicleSearchState());

  void setQuery(String raw) {
    final clean = VehicleNumberValidator.cleanPlate(raw);
    final valid = VehicleNumberValidator.isValid(clean);
    state = state.copyWith(
      query: raw,
      cleanPlate: clean,
      isValid: valid,
      errorMessage: raw.isNotEmpty && !valid && clean.length >= 4
          ? 'Invalid Indian vehicle registration format (e.g. DL01AB1234)'
          : null,
    );
  }

  void clear() {
    state = const VehicleSearchState();
  }
}

final vehicleSearchProvider =
    StateNotifierProvider<VehicleSearchNotifier, VehicleSearchState>((ref) {
      return VehicleSearchNotifier();
    });
