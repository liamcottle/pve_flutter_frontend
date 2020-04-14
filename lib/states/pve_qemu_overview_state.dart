import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';
part 'pve_qemu_overview_state.g.dart';

abstract class PveQemuOverviewState
    with PveBaseState
    implements Built<PveQemuOverviewState, PveQemuOverviewStateBuilder> {
  String get nodeID;
  @nullable
  PveQemuStatusModel get currentStatus;
  @nullable
  BuiltList<PveGuestRRDdataModel> get rrdData;
  @nullable
  PveNodesQemuConfigModel get config;

  PveQemuOverviewState._();

  factory PveQemuOverviewState(
          [void Function(PveQemuOverviewStateBuilder) updates]) =
      _$PveQemuOverviewState;

  factory PveQemuOverviewState.init(String nodeID) =>
      PveQemuOverviewState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
        //class
        ..nodeID = nodeID);
}
