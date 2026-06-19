import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_location.dart';
import '../services/location_service.dart';

class LocationState {
  final AppLocation location;
  final bool isLoading;
  final String? error;

  const LocationState({
    required this.location,
    this.isLoading = false,
    this.error,
  });

  LocationState copyWith({
    AppLocation? location,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState(location: AppLocation.empty()));

  Future<void> fetchLocation() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final location = await LocationService.instance.getCurrentLocation();
      if (location.source == 'error') {
        state = state.copyWith(isLoading: false, error: location.address);
      } else {
        state = state.copyWith(location: location, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setManualLocation(AppLocation manualLocation) {
    state = state.copyWith(location: manualLocation, isLoading: false, error: null);
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});
