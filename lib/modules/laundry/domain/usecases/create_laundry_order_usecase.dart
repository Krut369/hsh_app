import '../entities/laundry_entities.dart';
import '../repositories/laundry_repository.dart';

class CreateLaundryOrderUseCase {
  final LaundryRepository _repository;

  CreateLaundryOrderUseCase(this._repository);

  Future<void> execute(LaundryOrderEntity order) async {
    if (order.items.isEmpty) {
      throw Exception('Order must have at least one item');
    }
    return await _repository.createOrder(order);
  }
}
