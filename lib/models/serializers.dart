import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:pve_flutter_frontend/models/pve_bool_serializer.dart';
import 'package:pve_flutter_frontend/models/pve_cluster_resources_model.dart';
import 'package:pve_flutter_frontend/models/pve_cluster_tasks_model.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_model.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_network_model.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_qemu_create_model.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_storage_content_model.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_storage_model.dart';


part 'serializers.g.dart';

@SerializersFor([
  PveClusterResourcesModel,
  PveClusterTasksModel,
  PveNodesModel,
  PveNodesStorageModel,
  PveNodesStorageContentModel,
  PveNodeNetworkReadModel,
  PveNodeQemuCreateModel
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())..add(PveBoolSerializer())).build();

