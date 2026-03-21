import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/domain/repositories/laundry_repository.dart';

class GetLaundryOrdersUseCase {
  final LaundryRepository _repository;

  GetLaundryOrdersUseCase(this._repository);

  Future<List<LaundryOrderEntity>> execute() async {
    return await _repository.getOrders();
  }
}
