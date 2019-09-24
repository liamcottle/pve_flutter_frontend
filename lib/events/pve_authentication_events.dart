import 'package:meta/meta.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

abstract class PveAuthenticationEvent {
}

class AppStarted extends PveAuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends PveAuthenticationEvent {
  final proxclient.Client apiClient;

  LoggedIn(this.apiClient);

  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends PveAuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}