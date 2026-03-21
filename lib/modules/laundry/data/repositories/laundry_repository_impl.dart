import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/domain/repositories/laundry_repository.dart';
import 'package:hsh_app/modules/laundry/data/models/laundry_models.dart';
import 'package:hsh_app/modules/laundry/data/sources/laundry_remote_data_source.dart';
import 'package:hsh_app/modules/laundry/data/sources/laundry_local_data_source.dart';

class LaundryRepositoryImpl implements LaundryRepository {
  final LaundryRemoteDataSource _remoteDataSource;
  // ignore: unused_field
  final LaundryLocalDataSource _localDataSource;

  LaundryRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<LaundryOrderEntity>> getOrders() async {
    final List<LaundryOrderModel> models = await _remoteDataSource.getOrders();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _remoteDataSource.updateOrderStatus(orderId, status.name);
  }

  @override
  Future<LaundryCostEntity> getLaundryCost() async {
    final model = await _remoteDataSource.getLaundryCost();
    return model.toEntity();
  }

  @override
  Future<void> updateLaundryCost(LaundryCostEntity cost) async {
    await _remoteDataSource
        .updateLaundryCost(LaundryCostModel.fromEntity(cost));
  }
}
