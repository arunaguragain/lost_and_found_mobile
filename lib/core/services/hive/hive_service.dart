import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lost_and_found_mobile/core/constants/hive_table_constant.dart';
import 'package:lost_and_found_mobile/features/auth/data/models/auth_hive_model.dart';
import 'package:lost_and_found_mobile/features/batch/data/models/batch_hive_model.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  //init
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapter();
    await openBoxes();
    await insertDummybatches();
  }

  Future<void> insertDummybatches() async {
    final box = await Hive.openBox<BatchHiveModel>(
      HiveTableConstant.batchTable,
    );

    if (box.isNotEmpty) return;

    final dummyBatches = [
      BatchHiveModel(batchName: '35-A'),
      BatchHiveModel(batchName: '35-B'),
      BatchHiveModel(batchName: '35-C'),
      BatchHiveModel(batchName: '35-D'),
      BatchHiveModel(batchName: '35-E'),
      BatchHiveModel(batchName: '35-F'),
    ];
    for (var batch in dummyBatches) {
      await box.put(batch.batchId, batch);
    }
    await box.close();
  }

  //Register Adapters
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.batchTypeId)) {
      Hive.registerAdapter(BatchHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  //Open Boxes
  Future<void> openBoxes() async {
    await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable);
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  //Close Boxes
  Future<void> close() async {
    await Hive.close();
  }

  // Queries
  Box<BatchHiveModel> get _batchBox =>
      Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);

  //create batch
  Future<BatchHiveModel> createBatch(BatchHiveModel model) async {
    await _batchBox.put(model.batchId, model);
    return model;
  }

  //getallbatch
  List<BatchHiveModel> getAllBatches() {
    return _batchBox.values.toList();
  }

  //update
  Future<void> updateBatch(BatchHiveModel model) async {
    await _batchBox.put(model.batchId, model);
  }

  //delete
  Future<void> deleteBatch(BatchHiveModel model) async {
    await _batchBox.delete(model.batchId);
  }

  //Queries of auth
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  //login
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  //logout
  Future<void> logoutUser() async {}

  //get current user
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  //is Email exists
  bool isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }
}
