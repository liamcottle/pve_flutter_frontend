import 'package:built_value/built_value.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

part 'pve_login_state.g.dart';

abstract class PveLoginState
    with PveBaseState
    implements Built<PveLoginState, PveLoginStateBuilder> {
  String get userNameFieldError;
  String get passwordFieldError;
  String get originFieldError;
  String get origin;

  bool get isUsernameValid => userNameFieldError.isEmpty;
  bool get isPasswordValid => passwordFieldError.isEmpty;
  bool get isOriginValid => originFieldError.isEmpty;

  bool get showTfa;

  @nullable
  ProxmoxApiClient get apiClient;

  bool get isFormValid => isUsernameValid && isPasswordValid && isOriginValid;

  factory PveLoginState([void Function(PveLoginStateBuilder) updates]) =
      _$PveLoginState;
  PveLoginState._();

  factory PveLoginState.init(String origin) {
    return PveLoginState((b) => b
      //base
      ..errorMessage = ''
      ..isBlank = true
      ..isLoading = false
      ..isSuccess = false
      //class
      ..userNameFieldError = ''
      ..passwordFieldError = ''
      ..originFieldError = ''
      ..origin = origin
      ..showTfa = false);
  }
}
