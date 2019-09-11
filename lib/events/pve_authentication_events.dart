import 'package:meta/meta.dart';


abstract class PveAuthenticationEvent {
}

class AppStarted extends PveAuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends PveAuthenticationEvent {
  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends PveAuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}