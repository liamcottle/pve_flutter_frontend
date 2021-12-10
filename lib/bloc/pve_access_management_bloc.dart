import 'package:built_collection/built_collection.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_access_management_state.dart';

abstract class PveAccessManagementEvent {}

class PveAccessManagementBloc extends ProxmoxBaseBloc<PveAccessManagementEvent,
    PveAccessManagementState> {
  late final ProxmoxApiClient apiClient;
  late final PveAccessManagementState init;

  PveAccessManagementBloc(
      {required this.apiClient, required this.init});
  @override
  PveAccessManagementState get initialState => init;

  @override
  Stream<PveAccessManagementState> processEvents(
      PveAccessManagementEvent event) async* {
    if (event is LoadUsers) {
      final users = await apiClient.getAccessUsersList(full: true);
      final apiTokens = getTokensFromUserList(users);
      yield latestState.rebuild((b) => b
        ..users.replace(users)
        ..tokens.replace(apiTokens));
      final groups = await apiClient.getAccessGroupsList();
      yield latestState.rebuild((b) => b..groups.replace(groups));
      final roles = await apiClient.getAccessRolesList();
      yield latestState.rebuild((b) => b..roles.replace(roles));
      final domains = await apiClient.getAccessDomainsList();
      yield latestState.rebuild((b) => b..domains.replace(domains));
    }
  }

  BuiltList<PveAccessUserTokenModel> getTokensFromUserList(
      List<PveAccessUserModel > users) {
    final tokens = [];
    users.forEach((user) {
      if (user.tokens?.isNotEmpty ?? false) {
        user.tokens!.forEach((t) {
          tokens.add(t.rebuild((tb) => tb..userid = user.userid));
        });
      }
    });
    return BuiltList.from(tokens);
  }
}

class LoadUsers extends PveAccessManagementEvent {}
