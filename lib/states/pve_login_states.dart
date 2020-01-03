import 'package:built_value/built_value.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

part 'pve_login_states.g.dart';

abstract class PveLoginState
    implements Built<PveLoginState, PveLoginStateBuilder> {
  bool get isUsernameValid;
  bool get isPasswordValid;
  bool get isSubmitting;
  bool get isSuccess;
  String get errorMessage;
  bool get isFailure => errorMessage != null && errorMessage.isNotEmpty;
  @nullable
  ProxmoxApiClient get apiClient;

  bool get isFormValid => isUsernameValid && isPasswordValid;

  factory PveLoginState([void Function(PveLoginStateBuilder) updates]) =
      _$PveLoginState;
  PveLoginState._();

  factory PveLoginState.empty() {
    return PveLoginState((b) => b
      ..isUsernameValid = true
      ..isPasswordValid = true
      ..isSubmitting = false
      ..isSuccess = false
      ..errorMessage = "");
  }

  factory PveLoginState.loading() {
    return PveLoginState((b) => b
      ..isUsernameValid = true
      ..isPasswordValid = true
      ..isSubmitting = true
      ..isSuccess = false
      ..errorMessage = "");
  }

  factory PveLoginState.failure(String errorMessage) {
    return PveLoginState((b) => b
      ..isUsernameValid = true
      ..isPasswordValid = true
      ..isSubmitting = false
      ..isSuccess = false
      ..errorMessage = errorMessage);
  }

  factory PveLoginState.success({apiClient: ProxmoxApiClient}) {
    return PveLoginState((b) => b
      ..isUsernameValid = true
      ..isPasswordValid = true
      ..isSubmitting = false
      ..isSuccess = true
      ..errorMessage = ""
      ..apiClient = apiClient);
  }
}
