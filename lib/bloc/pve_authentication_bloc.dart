import 'dart:async';

import 'package:pve_flutter_frontend/events/pve_authentication_events.dart';
import 'package:pve_flutter_frontend/states/pve_authentication_states.dart';
import 'package:rxdart/rxdart.dart';

class PveAuthenticationBloc {
  final PublishSubject<PveAuthenticationEvent> _eventSubject =
      PublishSubject<PveAuthenticationEvent>();

  BehaviorSubject<PveAuthenticationState> _stateSubject;

  PveAuthenticationState get initialState => Unauthenticated();
  StreamSink<PveAuthenticationEvent> get events => _eventSubject.sink;
  ValueObservable<PveAuthenticationState> get state => _stateSubject.stream;

  PveAuthenticationBloc() {
    _stateSubject =
        BehaviorSubject<PveAuthenticationState>.seeded(initialState);

    _eventSubject
        .switchMap((event) => _eventToState(event))
        .forEach((PveAuthenticationState state) {
      _stateSubject.add(state);
    });
  }

  Stream<PveAuthenticationState> _eventToState(
      PveAuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield Unauthenticated();
      //yield Authenticated();

    }
    if (event is LoggedIn) {
      yield Authenticated();
    }
    if (event is LoggedOut) {
      yield Unauthenticated();
    }
  }

  void dispose() {
    _eventSubject.close();
    _stateSubject.close();
  }
}
