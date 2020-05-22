import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_qemu_overview_state.dart';

class PveQemuOverviewBloc
    extends ProxmoxBaseBloc<PveQemuOverviewEvent, PveQemuOverviewState> {
  final ProxmoxApiClient apiClient;
  final String guestID;
  final PveQemuOverviewState init;
  Timer updateTimer;

  PveQemuOverviewState get initialState => init;

  PveQemuOverviewBloc({
    @required this.guestID,
    @required this.apiClient,
    @required this.init,
  });

  @override
  void doOnListen() {
    updateTimer = Timer.periodic(
        Duration(seconds: 4), (timer) => events.add(UpdateQemuStatus()));
  }

  @override
  void doOnCancel() {
    if (!hasListener) {
      updateTimer?.cancel();
    }
  }

  Stream<PveQemuOverviewState> processEvents(
      PveQemuOverviewEvent event) async* {
    if (event is UpdateQemuStatus) {
      final status =
          await apiClient.getQemuStatusCurrent(latestState.nodeID, guestID);
      yield latestState.rebuild((b) => b..currentStatus.replace(status));
      final config = await apiClient.getQemuConfig(latestState.nodeID, guestID,
          current: true);
      yield latestState.rebuild((b) => b..config.replace(config));
      final rrdData = await _preProcessRRDdata();
      yield latestState.rebuild((b) => b..rrdData.replace(rrdData));
    }
    if (event is PerformQemuAction) {
      var param = <String, String>{};
      if (event.action == PveClusterResourceAction.hibernate) {
        param['todisk'] = '1';
        await apiClient.doResourceAction(latestState.nodeID, guestID, 'qemu',
            PveClusterResourceAction.suspend,
            parameters: param);
      } else {
        await apiClient.doResourceAction(
            latestState.nodeID, guestID, 'qemu', event.action,
            parameters: param);
      }
      yield latestState;
    }
    if (event is Migration) {
      if (!event.inProgress) {
        yield latestState.rebuild((b) => b..nodeID = event.newNodeID);
      }
    }

    if (event is UpdateQemuConfigBool) {
      final node = latestState.nodeID;
      final digest = latestState.config.digest;

      try {
        (await apiClient.putRequest('/nodes/$node/qemu/$guestID/config',
                {event.cField: event.paraValue, 'digest': digest}))
            .validate(false);
        events.add(UpdateQemuStatus());
      } on ProxmoxApiException catch (e) {
        yield latestState.rebuild((b) => b..errorMessage = e.message);
        yield latestState.rebuild((b) => b..errorMessage = '');
      }
    }

    if (event is RevertPendingQemuConfig) {
      final node = latestState.nodeID;
      final digest = latestState.config.digest;
      try {
        (await apiClient.putRequest('/nodes/$node/qemu/$guestID/config',
                {'revert': event.cField, 'digest': digest}))
            .validate(false);
        events.add(UpdateQemuStatus());
      } on ProxmoxApiException catch (e) {
        yield latestState.rebuild((b) => b..errorMessage = e.message);
        yield latestState.rebuild((b) => b..errorMessage = '');
      }
    }
  }

  Future<List<PveGuestRRDdataModel>> _preProcessRRDdata() async {
    final rrddata = (await apiClient.getNodeQemuRRDdata(
            latestState.nodeID, guestID, PveRRDTimeframeType.hour))
        .map((element) => element.cpu != null
            ? element.rebuild((e) => e..cpu = e.cpu * 100)
            : element)
        .toList();
    return rrddata;
  }
}

abstract class PveQemuOverviewEvent {}

class UpdateQemuStatus extends PveQemuOverviewEvent {}

class PerformQemuAction extends PveQemuOverviewEvent {
  final PveClusterResourceAction action;

  PerformQemuAction(this.action);
}

class Migration extends PveQemuOverviewEvent {
  final bool inProgress;
  final String newNodeID;

  Migration(this.inProgress, this.newNodeID);
}

class UpdateQemuConfigBool extends PveQemuOverviewEvent {
  final String cField;
  final bool value;
  String get paraValue => value ? '1' : '0';
  UpdateQemuConfigBool(this.cField, this.value);
}

class RevertPendingQemuConfig extends PveQemuOverviewEvent {
  final cField;

  RevertPendingQemuConfig(this.cField);
}
