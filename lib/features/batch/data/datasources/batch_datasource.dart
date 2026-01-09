import 'package:lost_and_found_mobile/features/batch/data/models/batch_api_model.dart';
import 'package:lost_and_found_mobile/features/batch/data/models/batch_hive_model.dart';

abstract interface class IBatchLocalDataSource {
  Future<List<BatchHiveModel>> getAllBatches();
  Future<List<BatchHiveModel>> getBatchById(String batchId);
  Future<bool> createBatch(BatchHiveModel model);
  Future<bool> updateBatch(BatchHiveModel model);
  Future<bool> deleteBatch(String batchId);
}

abstract interface class IBatchRemoteDataSource {
  Future<List<BatchApiModel>> getAllBatches();
  Future<List<BatchApiModel>> getBatchById(String batchId);
  Future<bool> createBatch(BatchHiveModel model);
  Future<bool> updateBatch(BatchHiveModel model);
  // Future<bool> deleteBatch(String batchId);
}