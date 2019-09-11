abstract class PveAuthenticationState{
}

class Uninitialized extends PveAuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends PveAuthenticationState {

  @override
  String toString() => 'Authenticated';
}

class Unauthenticated extends PveAuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}