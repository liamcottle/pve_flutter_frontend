import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_login_events.dart';
import 'package:pve_flutter_frontend/states/pve_login_state.dart';

import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;
import 'package:pve_flutter_frontend/utils/validators.dart';

class PveLoginBloc extends ProxmoxBaseBloc<PveLoginEvent, PveLoginState> {
  final PveLoginState init;

  PveLoginBloc({@required this.init});
  PveLoginState get initialState => init;

  @override
  Stream<PveLoginState> processEvents(PveLoginEvent event) async* {
    yield latestState.rebuild((b) => b..errorMessage = "");

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

    if (event is LoadOrigin) {
      final origin = await proxclient.getPlatformAwareOrigin();
      yield latestState.rebuild((b) => b
        ..origin = origin ?? ''
        ..isBlank = false);
    }
  }

  Stream<PveLoginState> _mapUsernameChangedToState(String username) async* {
//TODO implement username validator?
  }

  Stream<PveLoginState> _mapPasswordChangedToState(String password) async* {
//TODO implement password validator?
  }

  Stream<PveLoginState> _mapOriginChangedToState(String origin) async* {
    if (origin.isNotEmpty) {
      try {
        var uri = Uri.parse(origin);
        print(uri.pathSegments.length);
        if (uri.pathSegments.length < 3 &&
            (Validators.isValidDnsName(origin) ||
                Validators.isValidIPV4(origin))) {
          uri = uri.replace(host: origin);
        }
        if (!uri.hasPort) {
          uri = uri.replace(port: 8006);
        }
        if (!uri.hasScheme) {
          uri = uri.replace(scheme: 'https');
        }
        print(uri.origin);
        yield latestState.rebuild((b) => b
          ..originFieldError = ''
          ..origin = uri.origin);
        await proxclient.storePlatformAwareOrigin(uri.origin);
      } on StateError catch (e) {
        yield latestState.rebuild((b) => b..originFieldError = e.message);
      } catch (e) {
        yield latestState
            .rebuild((b) => b..originFieldError = 'Please check input');
      }
    }
  }

  Stream<PveLoginState> _mapLoginWithCredentialsPressedToState(
      {String username, String password, String hostname}) async* {
    yield latestState.rebuild((b) => b..isLoading = true);
    try {
      final client = await proxclient.authenticate(username, password);

      yield latestState.rebuild((b) => b
        ..apiClient = client
        ..isLoading = false
        ..isSuccess = true);
    } on proxclient.ProxmoxApiException catch (e) {
      yield latestState.rebuild((b) => b
        ..errorMessage = e.message
        ..isLoading = false);
    } catch (e, trace) {
      yield latestState.rebuild((b) => b
        ..errorMessage = e.toString()
        ..isLoading = false);
      print(e);
      print(trace);
    }
  }
}
