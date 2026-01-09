
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_and_found_mobile/core/api/api_client.dart';
import 'package:lost_and_found_mobile/core/api/api_endpoints.dart';
import 'package:lost_and_found_mobile/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_and_found_mobile/features/batch/data/models/batch_api_model.dart';
import 'package:lost_and_found_mobile/features/batch/data/models/batch_hive_model.dart';

final batchRemoteProvider = Provider<IBatchRemoteDataSource>((ref) {
  return BatchRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class BatchRemoteDatasource implements IBatchRemoteDataSource {
  final ApiClient _apiClient;

  BatchRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> createBatch(BatchHiveModel model) async {
    //do not use try catch if u want professional
    // TODO: implement createBatch
    final response = await _apiClient.post(ApiEndpoints.batches);
    return response.data['success'] == true;
  }

  @override
  Future<List<BatchApiModel>> getAllBatches() async {
    final response = await _apiClient.get(ApiEndpoints.batches);
    final data = response.data['data'] as List;
    //json -> api model -> entity : from Json
    //entity -> api model -> adapter : toJson
    return data.map((json) => BatchApiModel.fronJson(json)).toList();
  }

  @override
  Future<List<BatchApiModel>> getBatchById(String batchId) {
    // TODO: implement getBatchById
    throw UnimplementedError();
  }

  @override
  Future<bool> updateBatch(BatchHiveModel model) {
    // TODO: implement updateBatch
    throw UnimplementedError();
  }
}
