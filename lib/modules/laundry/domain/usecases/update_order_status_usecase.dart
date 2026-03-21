import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/domain/repositories/laundry_repository.dart';

class UpdateOrderStatusUseCase {
  final LaundryRepository repository;
  UpdateOrderStatusUseCase(this.repository);

  Future<void> execute(String orderId, OrderStatus status) async {
    return await repository.updateOrderStatus(orderId, status);
  }
}
