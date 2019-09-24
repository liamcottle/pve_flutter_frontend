import 'package:built_value/built_value.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

part 'pve_login_states.g.dart';

abstract class PveLoginState
    implements Built<PveLoginState, PveLoginStateBuilder> {
  bool get isUsernameValid;
  bool get isPasswordValid;
  bool get isSubmitting;
  bool get isSuccess;
  bool get isFailure;
  @nullable
  proxclient.Client get apiClient;


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
      ..isFailure = false);
  }

  factory PveLoginState.loading() {
    return PveLoginState((b) => b
      ..isUsernameValid = true
      ..isPasswordValid = true
      ..isSubmitting = true
      ..isSuccess = false
      ..isFailure = false);
  }

  factory PveLoginState.failure() {
    return PveLoginState((b) => b
      ..isUsernameValid = true
      ..isPasswordValid = true
      ..isSubmitting = false
      ..isSuccess = false
      ..isFailure = true);
  }

  factory PveLoginState.success({apiClient: proxclient.Client}) {
    return PveLoginState((b) => b
      ..isUsernameValid = true
      ..isPasswordValid = true
      ..isSubmitting = false
      ..isSuccess = true
      ..isFailure = false
      ..apiClient = apiClient);
  }
}
