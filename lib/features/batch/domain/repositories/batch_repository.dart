import 'package:dartz/dartz.dart';
import 'package:lost_and_found_mobile/core/error/failures.dart';
import 'package:lost_and_found_mobile/features/batch/domain/entities/batch_entity.dart';

abstract interface class IBatchRepository{
  Future<Either<Failure, List<BatchEntity >>> getAllBatches();
  Future<Either<Failure, List<BatchEntity >>> getBatchById(String batchId);
  Future<Either<Failure, bool >> createBatch(BatchEntity entity);
  Future<Either<Failure, bool>> updateBatch(BatchEntity entity);
  Future<Either<Failure, bool>> deleteBatch(String batchId);

}

//Retrun type : j pani huna sakcha 
// parameter pani j pani huna sakcha

//generic class 
// T add(Y)
// successtype add (Params)