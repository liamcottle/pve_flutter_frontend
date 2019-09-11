import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pve_cluster_resources_model.g.dart';

abstract class PveClusterResourcesModel
    implements
        Built<PveClusterResourcesModel, PveClusterResourcesModelBuilder> {
  static Serializer<PveClusterResourcesModel> get serializer =>
      _$pveClusterResourcesModelSerializer;

  @BuiltValueField(wireName: 'cpu')
  @nullable
  double get cpu;
  @BuiltValueField(wireName: 'disk')
  @nullable
  String get disk;
  @BuiltValueField(wireName: 'hastate')
  @nullable
  String get hastate;
  @BuiltValueField(wireName: 'id')
  String get id;
  @BuiltValueField(wireName: 'level')
  @nullable
  String get level;
  @BuiltValueField(wireName: 'maxcpu')
  @nullable
  double get maxcpu;
  @BuiltValueField(wireName: 'maxdisk')
  @nullable
  int get maxdisk;
  @BuiltValueField(wireName: 'maxmem')
  @nullable
  int get maxmem;
  @BuiltValueField(wireName: 'mem')
  @nullable
  int get mem;
  @BuiltValueField(wireName: 'node')
  @nullable
  String get node;
  @BuiltValueField(wireName: 'pool')
  @nullable
  String get pool;
  @BuiltValueField(wireName: 'status')
  @nullable
  String get status;
  @BuiltValueField(wireName: 'storage')
  @nullable
  String get storage;
  @BuiltValueField(wireName: 'type')
  String get type;
  @BuiltValueField(wireName: 'uptime')
  @nullable
  int get uptime;

  factory PveClusterResourcesModel(
          [void Function(PveClusterResourcesModelBuilder) updates]) =
      _$PveClusterResourcesModel;
  PveClusterResourcesModel._();
}
