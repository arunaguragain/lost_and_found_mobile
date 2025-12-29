import 'package:hive/hive.dart';
import 'package:lost_and_found_mobile/core/constants/hive_table_constant.dart';
import 'package:lost_and_found_mobile/features/batch/domain/entities/batch_entity.dart';
import 'package:uuid/uuid.dart';

part 'batch_hive_model.g.dart';

//Box
//Adapter: binary lai object ma convert

@HiveType(typeId: HiveTableConstant.batchTypeId)
class BatchHiveModel extends HiveObject {
  @HiveField(0)
  final String? batchId;
  @HiveField(1)
  final String batchName;
  @HiveField(2)
  final String? status;

  //Constructor
  BatchHiveModel({String? batchId, required this.batchName, String? status})
    : batchId = batchId ?? Uuid().v4(),
      status = status ?? 'active';

  // ToEntity : tala bata mathi jada : get request
  BatchEntity toEntity() {
    return BatchEntity(
      batchId: batchId, 
      batchName: 'Kathmandu $batchName', 
      status: status);
  }


  //FromEntity
  factory BatchHiveModel.fromEntity(BatchEntity entity) {
    return BatchHiveModel(batchName:  entity.batchName);
  }

  //ToEntityList
  static List<BatchEntity> toEntityList(List<BatchHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
