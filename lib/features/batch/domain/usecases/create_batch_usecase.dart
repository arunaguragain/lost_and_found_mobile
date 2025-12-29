import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_and_found_mobile/core/error/failures.dart';
import 'package:lost_and_found_mobile/core/usecases/app_usecase.dart';
import 'package:lost_and_found_mobile/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_and_found_mobile/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_and_found_mobile/features/batch/domain/repositories/batch_repository.dart';

class CreateBatchUsecaseParams extends Equatable {
  final String batchName;

  const CreateBatchUsecaseParams({required this.batchName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

final createBatchUsecaseProvider = Provider<CreateBatchUsecase>((ref) {
  return CreateBatchUsecase(
    batchRepository: ref.read(batchRepositoryProvider),
  );
});

//Usecase
class CreateBatchUsecase
    implements UsecaseWithParams<bool, CreateBatchUsecaseParams> {
  final IBatchRepository _batchRepository;

  CreateBatchUsecase({required IBatchRepository batchRepository})
    : _batchRepository = batchRepository;

  @override
  Future<Either<Failure, bool>> call(CreateBatchUsecaseParams params) {
    BatchEntity batchEntity = BatchEntity(batchName: params.batchName);
    return _batchRepository.createBatch(batchEntity);
  }
}
