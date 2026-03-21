import '../entities/laundry_entities.dart';

abstract class LaundryRepository {
  Future<List<LaundryOrderEntity>> getOrders();
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  Future<LaundryCostEntity> getLaundryCost();
  Future<void> updateLaundryCost(LaundryCostEntity cost);
}
