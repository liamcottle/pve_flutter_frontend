import 'package:meta/meta.dart';

abstract class PveLoginEvent {}

class UsernameChanged extends PveLoginEvent {
  final String username;

  UsernameChanged({@required this.username});

  @override
  String toString() => 'UsernameChanged { email :$username }';
}

class PasswordChanged extends PveLoginEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class OriginChanged extends PveLoginEvent {
  final String origin;

  OriginChanged({@required this.origin});

  @override
  String toString() => 'HostnameChanged { password: $origin }';
}

class LoginWithCredentialsPressed extends PveLoginEvent {
  final String username;
  final String password;
  final String origin;

  LoginWithCredentialsPressed({@required this.username, @required this.password, this.origin});

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $username, password: $password, hostname: $origin }';
  }
}