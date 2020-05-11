import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

part 'pve_access_management_state.g.dart';

abstract class PveAccessManagementState
    with PveBaseState
    implements
        Built<PveAccessManagementState, PveAccessManagementStateBuilder> {
  // Fields
  BuiltList<PveAccessUserModel> get users;
  BuiltList<PveAccessUserTokenModel> get tokens;
  BuiltList<PveAccessGroupModel> get groups;
  BuiltList<PveAccessRoleModel> get roles;
  BuiltList<PveAccessDomainModel> get domains;

  String get apiUser;

  PveAccessManagementState._();

  factory PveAccessManagementState(
          [void Function(PveAccessManagementStateBuilder) updates]) =
      _$PveAccessManagementState;
  factory PveAccessManagementState.init(String apiUser) =>
      PveAccessManagementState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
        //class
        ..apiUser = apiUser);
}
