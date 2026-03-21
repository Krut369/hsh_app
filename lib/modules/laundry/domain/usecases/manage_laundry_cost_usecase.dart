import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/domain/repositories/laundry_repository.dart';

class ManageLaundryCostUseCase {
  final LaundryRepository repository;
  ManageLaundryCostUseCase(this.repository);

  Future<LaundryCostEntity> getCost() async {
    return await repository.getLaundryCost();
  }

  Future<void> updateCost(LaundryCostEntity cost) async {
    return await repository.updateLaundryCost(cost);
  }
}
