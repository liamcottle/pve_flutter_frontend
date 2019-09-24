import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

abstract class PveAuthenticationState{
}

class Uninitialized extends PveAuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends PveAuthenticationState {
  final proxclient.Client apiClient;

  Authenticated(this.apiClient);

  @override
  String toString() => 'Authenticated';
}

class Unauthenticated extends PveAuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}