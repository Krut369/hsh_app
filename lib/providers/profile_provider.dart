import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile_model.dart';
import '../services/service_provider.dart';

/// Profile state
class ProfileState {
  final ProfileData? profileData;
  final bool isLoading;
  final String? error;

  ProfileState({
    this.profileData,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    ProfileData? profileData,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profileData: profileData ?? this.profileData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Profile notifier with API integration
class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState()) {
    // Auto-fetch profile on initialization
    fetchProfile();
  }

  /// Fetch profile from API
  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await serviceProvider.student.getProfile();

      if (response.success && response.data != null) {
        final data = response.data;
        
        // Convert API response to ProfileData model
        final profileData = ProfileData(
          userName: data['name'] ?? 'User',
          profileImageUrl: data['profile_image'] ?? 
              'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
          details: [
            ProfileDetail(
              icon: Icons.wc_outlined,
              label: 'ID',
              value: data['id']?.toString() ?? 'N/A',
            ),
            ProfileDetail(
              icon: Icons.person_outline,
              label: 'Name',
              value: data['name'] ?? 'N/A',
            ),
            ProfileDetail(
              icon: Icons.phone,
              label: 'Room',
              value: data['room_number'] ?? 'N/A',
            ),
            ProfileDetail(
              icon: Icons.home_outlined,
              label: 'Hostel Block',
              value: data['hostel_block'] ?? 'N/A',
            ),
            ProfileDetail(
              icon: Icons.phone,
              label: 'Phone',
              value: data['phone'] ?? 'N/A',
            ),
          ],
        );

        state = ProfileState(
          profileData: profileData,
          isLoading: false,
        );
      } else {
        state = ProfileState(
          isLoading: false,
          error: response.message ?? 'Failed to load profile',
        );
      }
    } catch (e) {
      state = ProfileState(
        isLoading: false,
        error: 'Error loading profile: ${e.toString()}',
      );
    }
  }

  /// Update profile
  Future<bool> updateProfile({
    String? name,
    String? roomNumber,
    String? hostelBlock,
    String? phone,
    String? profileImage,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await serviceProvider.student.updateProfile(
        name: name,
        roomNumber: roomNumber,
        hostelBlock: hostelBlock,
        phone: phone,
        profileImage: profileImage,
      );

      if (response.success) {
        // Refresh profile data
        await fetchProfile();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Failed to update profile',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error updating profile: ${e.toString()}',
      );
      return false;
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);

