import 'dart:async';

import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

class PveAuthenticationBloc
    extends ProxmoxBaseBloc<PveAuthenticationEvent, PveAuthenticationState> {
  @override
  PveAuthenticationState get initialState => Unauthenticated();

  PveAuthenticationBloc();

  @override
  Stream<PveAuthenticationState> processEvents(
      PveAuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield Uninitialized();
    }
    if (event is LoggedIn) {
      yield Authenticated(event.apiClient);
    }
    if (event is LoggedOut) {
      await storeTicket('');
      yield Unauthenticated();
    }
  }
}

abstract class PveAuthenticationEvent {}

class AppStarted extends PveAuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends PveAuthenticationEvent {
  final ProxmoxApiClient apiClient;

  LoggedIn(this.apiClient);

  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends PveAuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}

abstract class PveAuthenticationState {}

class Uninitialized extends PveAuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends PveAuthenticationState {
  final ProxmoxApiClient apiClient;

  Authenticated(this.apiClient);

  @override
  String toString() => 'Authenticated';
}

class Unauthenticated extends PveAuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}
