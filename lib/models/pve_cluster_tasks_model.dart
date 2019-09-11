import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';


part 'pve_cluster_tasks_model.g.dart';

abstract class PveClusterTasksModel
    implements Built<PveClusterTasksModel, PveClusterTasksModelBuilder> {
  static Serializer<PveClusterTasksModel> get serializer => _$pveClusterTasksModelSerializer;

  @BuiltValueField(wireName: 'starttime')
  DateTime get startTime;

  @BuiltValueField(wireName: 'endtime')
  @nullable
  DateTime get endTime;

  @nullable
  String get status;

  String get type;
  String get upid;
  String get user;
  String get node;

  factory PveClusterTasksModel([void Function(PveClusterTasksModelBuilder) updates]) =
      _$PveClusterTasksModel;
  PveClusterTasksModel._();

}
