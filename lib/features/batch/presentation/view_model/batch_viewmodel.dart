import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_and_found_mobile/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_and_found_mobile/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:lost_and_found_mobile/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:lost_and_found_mobile/features/batch/presentation/state/batch_state.dart';

final batchViewmodelProvider = NotifierProvider<BatchViewmodel, BatchState>(() {
  return BatchViewmodel();
});

class BatchViewmodel extends Notifier<BatchState> {
  late final GetAllBatchUsecase _getAllBatchUsecase;
  late final UpdateBatchUsecase _updateBatchUsecase;
  late final CreateBatchUsecase _createBatchUsecase;
  @override
  BatchState build() {
    //initialization
    _getAllBatchUsecase = ref.read(getAllBatchUsecaseProvider);
    _updateBatchUsecase = ref.read(updateBatchUsecaseProvider);
    _createBatchUsecase = ref.read(createBatchUsecaseProvider);
    return BatchState();
  }

  Future<void> getAllBatches() async {
    state = state.copyWith(status: BatchStatus.loading);

    //wait for 2 seconds
    Future.delayed(Duration(seconds: 2), () {});
    final result = await _getAllBatchUsecase();

    result.fold(
      (Left) {
        state = state.copyWith(
          status: BatchStatus.error,
          errorMessage: Left.message,
        );
      },
      (batches) {
        state = state.copyWith(status: BatchStatus.loaded, batches: batches);
      },
    );
  }

  Future<void> createBatch(String batchName) async {
    //progress bar ghumaune
    state = state.copyWith(status: BatchStatus.loading);

    final params = CreateBatchUsecaseParams(batchName: batchName);
    final result = await _createBatchUsecase(params);

    result.fold(
      (Left) {
        return state = state.copyWith(
          status: BatchStatus.error,
          errorMessage: Left.message,
        );
      },
      (right) {
        state = state.copyWith(status: BatchStatus.loaded);
      },
    );
  }
}
