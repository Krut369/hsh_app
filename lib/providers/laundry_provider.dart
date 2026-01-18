import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/service_provider.dart';

/// Laundry orders state
class LaundryOrdersState {
  final List<dynamic> orders;
  final bool isLoading;
  final String? error;

  LaundryOrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  LaundryOrdersState copyWith({
    List<dynamic>? orders,
    bool? isLoading,
    String? error,
  }) {
    return LaundryOrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Laundry orders notifier
class LaundryOrdersNotifier extends StateNotifier<LaundryOrdersState> {
  LaundryOrdersNotifier() : super(LaundryOrdersState());

  /// Fetch laundry orders
  Future<void> fetchOrders({String? status}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await serviceProvider.laundry.getOrders(status: status);

      if (response.success && response.data != null) {
        state = LaundryOrdersState(
          orders: response.data is List ? response.data : [response.data],
          isLoading: false,
        );
      } else {
        state = LaundryOrdersState(
          isLoading: false,
          error: response.message ?? 'Failed to load orders',
        );
      }
    } catch (e) {
      state = LaundryOrdersState(
        isLoading: false,
        error: 'Error loading orders: ${e.toString()}',
      );
    }
  }

  /// Create new laundry order
  Future<bool> createOrder({
    required List<Map<String, dynamic>> items,
    required String serviceType,
    String? note,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await serviceProvider.laundry.createOrder(
        items: items,
        serviceType: serviceType,
        note: note,
      );

      if (response.success) {
        // Refresh orders list
        await fetchOrders();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Failed to create order',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error creating order: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update order status (for laundry staff)
  Future<bool> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await serviceProvider.laundry.updateOrderStatus(
        orderId: orderId,
        status: status,
      );

      if (response.success) {
        // Refresh orders list
        await fetchOrders();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Failed to update status',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error updating status: ${e.toString()}',
      );
      return false;
    }
  }

  /// Refresh orders
  Future<void> refresh({String? status}) async {
    await fetchOrders(status: status);
  }
}

final laundryOrdersProvider =
    StateNotifierProvider<LaundryOrdersNotifier, LaundryOrdersState>(
  (ref) => LaundryOrdersNotifier(),
);

/// Laundry config state
class LaundryConfigState {
  final Map<String, dynamic>? config;
  final bool isLoading;
  final String? error;

  LaundryConfigState({
    this.config,
    this.isLoading = false,
    this.error,
  });

  LaundryConfigState copyWith({
    Map<String, dynamic>? config,
    bool? isLoading,
    String? error,
  }) {
    return LaundryConfigState(
      config: config ?? this.config,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Laundry config notifier
class LaundryConfigNotifier extends StateNotifier<LaundryConfigState> {
  LaundryConfigNotifier() : super(LaundryConfigState());

  /// Fetch laundry config
  Future<void> fetchConfig() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await serviceProvider.laundry.getConfig();

      if (response.success && response.data != null) {
        state = LaundryConfigState(
          config: response.data,
          isLoading: false,
        );
      } else {
        state = LaundryConfigState(
          isLoading: false,
          error: response.message ?? 'Failed to load config',
        );
      }
    } catch (e) {
      state = LaundryConfigState(
        isLoading: false,
        error: 'Error loading config: ${e.toString()}',
      );
    }
  }

  /// Update laundry config
  Future<bool> updateConfig(Map<String, dynamic> prices) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await serviceProvider.laundry.updateConfig(prices: prices);

      if (response.success) {
        await fetchConfig();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Failed to update config',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error updating config: ${e.toString()}',
      );
      return false;
    }
  }
}

final laundryConfigProvider =
    StateNotifierProvider<LaundryConfigNotifier, LaundryConfigState>(
  (ref) => LaundryConfigNotifier(),
);
