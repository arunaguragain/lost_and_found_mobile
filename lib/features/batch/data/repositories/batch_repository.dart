import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_and_found_mobile/core/error/failures.dart';
import 'package:lost_and_found_mobile/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_and_found_mobile/features/batch/data/datasources/local/batch_local_datasource.dart';
import 'package:lost_and_found_mobile/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_and_found_mobile/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_and_found_mobile/features/batch/domain/repositories/batch_repository.dart';

final batchRepositoryProvider = Provider<IBatchRepository>((ref) {
  return BatchRepository(datasource: ref.read(BatchLocalDatasourceProvider));
});

class BatchRepository implements IBatchRepository {
  final IBatchDataSource _datasource;

  BatchRepository({required IBatchDataSource datasource})
    : _datasource = datasource;

  @override
  Future<Either<Failure, bool>> createBatch(BatchEntity entity) async {
    try {
      final model = BatchHiveModel.fromEntity(entity);
      final result = await _datasource.createBatch(model);
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: 'Failed to create Batch'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBatch(String batchId) {
    // TODO: implement deleteBatch
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> getAllBatches() async {
    try {
      final models = await _datasource.getAllBatches();
      final entities = BatchHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> getBatchById(
    String batchId,
  ) async {
    try {
      final models = await _datasource.getBatchById(batchId);
      final entities = BatchHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateBatch(BatchEntity model) {
    // TODO: implement updateBatch
    throw UnimplementedError();
  }
}
