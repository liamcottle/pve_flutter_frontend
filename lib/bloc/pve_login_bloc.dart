import 'dart:async';

import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_login_events.dart';
import 'package:pve_flutter_frontend/states/pve_login_states.dart';
import 'package:pve_flutter_frontend/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

class PveLoginBloc extends ProxmoxBaseBloc<PveLoginEvent, PveLoginState> {
  PveLoginState get initialState => PveLoginState.empty();

  @override
  Stream<PveLoginState> processEvents(PveLoginEvent event) async* {
    if (event is UsernameChanged) {
      yield* _mapUsernameChangedToState(event.username);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is OriginChanged) {
      yield* _mapOriginChangedToState(event.origin);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          username: event.username,
          password: event.password,
          hostname: event.origin);
    }
  }

  Stream<PveLoginState> _mapUsernameChangedToState(String username) async* {
//TODO implement username validator?
    yield latestState.rebuild((b) => b
      ..isUsernameValid = true
      ..errorMessage = "");
  }

  Stream<PveLoginState> _mapPasswordChangedToState(String password) async* {
//TODO implement password validator?
    yield latestState.rebuild((b) => b
      ..isPasswordValid = true
      ..errorMessage = "");
  }

  Stream<PveLoginState> _mapOriginChangedToState(String origin) async* {
    proxclient.storePlatformAwareOrigin(origin);
//TODO implement origin validator?
    yield latestState.rebuild((b) => b
      ..errorMessage = "");
  }

  Stream<PveLoginState> _mapLoginWithCredentialsPressedToState(
      {String username, String password, String hostname}) async* {
    yield PveLoginState.loading();
    try {
      final client = await proxclient.authenticate(username, password);
      yield PveLoginState.success(apiClient: client);
    } on proxclient.ProxmoxApiException catch (e) {
      yield PveLoginState.failure(e.message);
    } catch (e, trace) {
      print(e);
      print(trace);
      yield PveLoginState.failure("An error occured");
    }
  }
}
