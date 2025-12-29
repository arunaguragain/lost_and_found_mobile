import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_and_found_mobile/core/services/hive/hive_service.dart';
import 'package:lost_and_found_mobile/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_and_found_mobile/features/batch/data/models/batch_hive_model.dart';

final BatchLocalDatasourceProvider = Provider<BatchLocalDatasource>((ref) {
  return BatchLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});

class BatchLocalDatasource implements IBatchDataSource {
  //Dependency Injection
  final HiveService _hiveService;

  BatchLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createBatch(BatchHiveModel entity) async {
    try {
      await _hiveService.createBatch(entity);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteBatch(String batchId) {
    // TODO: implement deleteBatch
    throw UnimplementedError();
  }

  @override
  Future<List<BatchHiveModel>> getAllBatches() async {
    try {
      return _hiveService.getAllBatches();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<BatchHiveModel>> getBatchById(String batchId) {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateBatch(BatchHiveModel entity) {
    // TODO: implement updateBatch
    throw UnimplementedError();
  }
}
