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


class LoginWithCredentialsPressed extends PveLoginEvent {
  final String username;
  final String password;

  LoginWithCredentialsPressed({@required this.username, @required this.password});

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $username, password: $password }';
  }
}