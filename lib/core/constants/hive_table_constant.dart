class HiveTableConstant {
  //Private constructor to prevent instantiation
  HiveTableConstant._();

  //database name
  static const String dbName = 'lost_n_found_db';

  //Table name : Box names in Hive
  static const int batchTypeId = 0;
  static const String batchTable = 'batch_table';

  static const int authTypeId = 1;
  static const String authTable = 'auth_table';

  static const int itemTypeId = 2;
  static const String itemTable = 'item_table';

  static const int categoryTypeId = 3;
  static const String categoryTable = 'category_table';

  static const int commentsTypeId = 4;
  static const String commentsTable = 'comments_table';
}
