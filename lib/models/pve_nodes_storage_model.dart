import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pve_nodes_storage_model.g.dart';

abstract class PveNodesStorageModel
    implements Built<PveNodesStorageModel, PveNodesStorageModelBuilder> {
  static Serializer<PveNodesStorageModel> get serializer => _$pveNodesStorageModelSerializer;

  @nullable
  bool get active;

  @BuiltValueField(wireName: 'avail')
  @nullable
  int get freeSpace;

  String get content;

  @nullable
  bool get enabled;

  @nullable
  bool get shared;

  @BuiltValueField(wireName: 'storage')
  String get id;

  @BuiltValueField(wireName: 'total')
  @nullable
  int get totalSpace;

  String get type;

  @BuiltValueField(wireName: 'used')
  @nullable
  int get usedSpace;

  @BuiltValueField(wireName: 'used_fraction')
  @nullable
  double get usedPercent;

  factory PveNodesStorageModel([void Function(PveNodesStorageModelBuilder) updates]) =
      _$PveNodesStorageModel;
  PveNodesStorageModel._();

}