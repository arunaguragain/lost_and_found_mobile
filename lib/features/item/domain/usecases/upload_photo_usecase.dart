import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_and_found_mobile/core/error/failures.dart';
import 'package:lost_and_found_mobile/core/usecases/app_usecase.dart';
import 'package:lost_and_found_mobile/features/item/data/repositories/item_repository.dart';
import 'package:lost_and_found_mobile/features/item/domain/repositories/item_repository.dart';

final uploadPhotoUsecaseProvider = Provider<UploadPhotoUsecase>((ref) {
  final repository = ref.read(itemRepositoryProvider);
  return UploadPhotoUsecase(repository: repository);
});

class UploadPhotoUsecase implements UsecaseWithParams<String, File> {
  final IItemRepository _repository;

  UploadPhotoUsecase({required IItemRepository repository})
    : _repository = repository;
  @override
  Future<Either<Failure, String>> call(File params) {
    return _repository.uploadImage(params);
  }
}
