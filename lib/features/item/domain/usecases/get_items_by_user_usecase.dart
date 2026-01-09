import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_and_found_mobile/core/error/failures.dart';
import 'package:lost_and_found_mobile/core/usecases/app_usecase.dart';
import 'package:lost_and_found_mobile/features/item/data/repositories/item_repository.dart';
import 'package:lost_and_found_mobile/features/item/domain/entities/item_entity.dart';
import 'package:lost_and_found_mobile/features/item/domain/repositories/item_repository.dart';

class GetItemsByUserParams extends Equatable {
  final String userId;

  const GetItemsByUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getItemsByUserUsecaseProvider = Provider<GetItemsByUserUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return GetItemsByUserUsecase(itemRepository: itemRepository);
});

class GetItemsByUserUsecase
    implements UsecaseWithParams<List<ItemEntity>, GetItemsByUserParams> {
  final IItemRepository _itemRepository;

  GetItemsByUserUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, List<ItemEntity>>> call(GetItemsByUserParams params) {
    return _itemRepository.getItemsByUser(params.userId);
  }
}
