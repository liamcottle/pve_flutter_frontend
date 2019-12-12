import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
part 'pve_cluster_status_model.g.dart';

abstract class PveClusterStatusModel
    implements Built<PveClusterStatusModel, PveClusterStatusModelBuilder> {
  PveClusterStatusModel._();
  factory PveClusterStatusModel(
          [void Function(PveClusterStatusModelBuilder) updates]) =
      _$PveClusterStatusModel;
  static Serializer<PveClusterStatusModel> get serializer =>
      _$pveClusterStatusModelSerializer;

  String get id;
  String get name;
  String get type;
  @nullable
  String get ip;
  @nullable
  String get level;
  @nullable
  bool get local;
  @nullable
  int get nodeid;
  @nullable
  int get nodes;
  @nullable
  bool get online;
  @nullable
  bool get quorate;
  @nullable
  int get version;
}
