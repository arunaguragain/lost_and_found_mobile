import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lost_and_found_mobile/core/constants/hive_table_constant.dart';
import 'package:lost_and_found_mobile/features/auth/data/models/auth_hive_model.dart';
import 'package:lost_and_found_mobile/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_and_found_mobile/features/category/data/models/category_hive_model.dart';
import 'package:lost_and_found_mobile/features/item/data/models/item_hive_model.dart';
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

   Future<void> insertCategoryDummyData() async {
    final categoryBox = Hive.box<CategoryHiveModel>(
      HiveTableConstant.categoryTable,
    );

    if (categoryBox.isNotEmpty) {
      return;
    }

    final dummyCategories = [
      CategoryHiveModel(
        name: 'Electronics',
        description: 'Phones, laptops, tablets, etc.',
      ),
      CategoryHiveModel(name: 'Personal', description: 'Personal belongings'),
      CategoryHiveModel(
        name: 'Accessories',
        description: 'Watches, jewelry, etc.',
      ),
      CategoryHiveModel(
        name: 'Documents',
        description: 'IDs, certificates, papers',
      ),
      CategoryHiveModel(
        name: 'Keys',
        description: 'House keys, car keys, etc.',
      ),
      CategoryHiveModel(
        name: 'Bags',
        description: 'Backpacks, handbags, wallets',
      ),
      CategoryHiveModel(name: 'Other', description: 'Miscellaneous items'),
    ];

    for (var category in dummyCategories) {
      await categoryBox.put(category.categoryId, category);
    }
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
  Future<AuthHiveModel?> login(String email, String password) async {
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

  
  Box<ItemHiveModel> get _itemBox =>
      Hive.box<ItemHiveModel>(HiveTableConstant.itemTable);

  Future<ItemHiveModel> createItem(ItemHiveModel item) async {
    await _itemBox.put(item.itemId, item);
    return item;
  }

  List<ItemHiveModel> getAllItems() {
    return _itemBox.values.toList();
  }

  ItemHiveModel? getItemById(String itemId) {
    return _itemBox.get(itemId);
  }

  List<ItemHiveModel> getItemsByUser(String userId) {
    return _itemBox.values.where((item) => item.reportedBy == userId).toList();
  }

  List<ItemHiveModel> getLostItems() {
    return _itemBox.values.where((item) => item.type == 'lost').toList();
  }

  List<ItemHiveModel> getFoundItems() {
    return _itemBox.values.where((item) => item.type == 'found').toList();
  }

  List<ItemHiveModel> getItemsByCategory(String categoryId) {
    return _itemBox.values
        .where((item) => item.categoryId == categoryId)
        .toList();
  }

  Future<bool> updateItem(ItemHiveModel item) async {
    if (_itemBox.containsKey(item.itemId)) {
      await _itemBox.put(item.itemId, item);
      return true;
    }
    return false;
  }

  Future<void> deleteItem(String itemId) async {
    await _itemBox.delete(itemId);
  }

  // ======================= Category Queries =========================

  Box<CategoryHiveModel> get _categoryBox =>
      Hive.box<CategoryHiveModel>(HiveTableConstant.categoryTable);

  Future<CategoryHiveModel> createCategory(CategoryHiveModel category) async {
    await _categoryBox.put(category.categoryId, category);
    return category;
  }

  List<CategoryHiveModel> getAllCategories() {
    return _categoryBox.values.toList();
  }

  CategoryHiveModel? getCategoryById(String categoryId) {
    return _categoryBox.get(categoryId);
  }

  Future<bool> updateCategory(CategoryHiveModel category) async {
    if (_categoryBox.containsKey(category.categoryId)) {
      await _categoryBox.put(category.categoryId, category);
      return true;
    }
    return false;
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoryBox.delete(categoryId);
  }
}
