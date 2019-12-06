import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pve_nodes_storage_content_model.g.dart';

enum PveStorageContentType { rootdir, images, vztmpl, iso, backup, snippets }

abstract class PveNodesStorageContentModel implements Built<PveNodesStorageContentModel, PveNodesStorageContentModelBuilder> {

  String get format;

  @nullable
  String get parent;

  int get size;

  @nullable
  int get used;

  @nullable
  int get vmid;

  String get volid;

  static Serializer<PveNodesStorageContentModel> get serializer => _$pveNodesStorageContentModelSerializer;

  PveNodesStorageContentModel._();
  factory PveNodesStorageContentModel([void Function(PveNodesStorageContentModelBuilder) updates]) = _$PveNodesStorageContentModel;

}