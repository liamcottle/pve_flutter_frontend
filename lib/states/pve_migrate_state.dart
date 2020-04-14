import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

part 'pve_migrate_state.g.dart';

abstract class PveMigrateState
    with PveBaseState
    implements Built<PveMigrateState, PveMigrateStateBuilder> {
  // Fields

  String get nodeID;
  String get guestType;
  bool get withLocalDisks;
  bool get hasLocalResources;
  bool get overwriteLocalResourceCheck;
  bool get inProgress;

  PveMigrationMode get mode {
    switch (guestType) {
      case 'qemu':
        return qemuPreconditions?.running ?? false
            ? PveMigrationMode.online
            : PveMigrationMode.offline;
        break;
      case 'lxc':
        return PveMigrationMode.offline;
        break;
      default:
        return PveMigrationMode.offline;
    }
  }

  @nullable
  String get targetNodeID;

  @nullable
  String get taskUPID;

  @nullable
  PveNodesQemuMigrate get qemuPreconditions;

  PveMigrateState._();

  factory PveMigrateState([void Function(PveMigrateStateBuilder) updates]) =
      _$PveMigrateState;

  factory PveMigrateState.init(String nodeID, String guestType) =>
      PveMigrateState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
        //class
        ..nodeID = nodeID
        ..guestType = guestType
        ..hasLocalResources = false
        ..withLocalDisks = false
        ..overwriteLocalResourceCheck = false
        ..inProgress = false);
}

class PveMigrationMode extends EnumClass {
  static const PveMigrationMode online = _$online;
  static const PveMigrationMode offline = _$offline;
  static const PveMigrationMode restart = _$restart;

  const PveMigrationMode._(String name) : super(name);

  static BuiltSet<PveMigrationMode> get values => _$values;
  static PveMigrationMode valueOf(String name) => _$valueOf(name);
}
