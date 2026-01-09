import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_and_found_mobile/core/error/failures.dart';
import 'package:lost_and_found_mobile/core/usecases/app_usecase.dart';
import 'package:lost_and_found_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:lost_and_found_mobile/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_and_found_mobile/features/auth/domain/repositories/auth_repository.dart';

// Create Provider
final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentUserUsecase(authRepository: authRepository);
});

class GetCurrentUserUsecase implements UsecaseWithoutParams<AuthEntity> {
  final IAuthRepository _authRepository;

  GetCurrentUserUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call() {
    return _authRepository.getCurrentUser();
  }
}