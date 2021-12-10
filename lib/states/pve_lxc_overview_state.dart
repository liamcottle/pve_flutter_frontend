import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

part 'pve_lxc_overview_state.g.dart';

abstract class PveLxcOverviewState
    with PveBaseState
    implements Built<PveLxcOverviewState, PveLxcOverviewStateBuilder> {
  // Fields
  String get nodeID;
  PveNodesLxcStatusModel? get currentStatus;
  BuiltList<PveGuestRRDdataModel>? get rrdData;
  PveNodesLxcConfigModel? get config;

  PveLxcOverviewState._();

  factory PveLxcOverviewState(
          [void Function(PveLxcOverviewStateBuilder) updates]) =
      _$PveLxcOverviewState;

  factory PveLxcOverviewState.init(String nodeID) =>
      PveLxcOverviewState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
        //class
        ..nodeID = nodeID);
}
