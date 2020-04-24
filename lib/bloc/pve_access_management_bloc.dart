import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_access_management_state.dart';

abstract class PveAccessManagementEvent {}

class PveAccessManagementBloc extends ProxmoxBaseBloc<PveAccessManagementEvent,
    PveAccessManagementState> {
  final ProxmoxApiClient apiClient;
  final PveAccessManagementState init;

  PveAccessManagementBloc({this.apiClient, this.init});
  @override
  PveAccessManagementState get initialState => init;

  @override
  Stream<PveAccessManagementState> processEvents(
      PveAccessManagementEvent event) async* {
    if (event is LoadUsers) {
      final users = await apiClient.getAccessUsersList();
      yield latestState.rebuild((b) => b..users.replace(users));
      final groups = await apiClient.getAccessGroupsList();
      yield latestState.rebuild((b) => b..groups.replace(groups));
      final roles = await apiClient.getAccessRolesList();
      yield latestState.rebuild((b) => b..roles.replace(roles));
      final domains = await apiClient.getAccessDomainsList();
      yield latestState.rebuild((b) => b..domains.replace(domains));
    }
  }
}

class LoadUsers extends PveAccessManagementEvent {}
