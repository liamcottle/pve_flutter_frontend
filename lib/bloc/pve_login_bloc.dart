import 'dart:async';

import 'package:pve_flutter_frontend/events/pve_login_events.dart';
import 'package:pve_flutter_frontend/states/pve_login_states.dart';
import 'package:pve_flutter_frontend/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

class PveLoginBloc {
  final PublishSubject<PveLoginEvent> _eventSubject =
      PublishSubject<PveLoginEvent>();

  BehaviorSubject<PveLoginState> _stateSubject;

  PveLoginState get initialState => PveLoginState.empty();
  StreamSink<PveLoginEvent> get events => _eventSubject.sink;
  Stream<PveLoginState> get state => _stateSubject.stream;

  PveLoginBloc() {
    _stateSubject = BehaviorSubject<PveLoginState>.seeded(initialState);

    _eventSubject
        .where((event) {
          return (event is! LoginWithCredentialsPressed);
        })
        .debounceTime(Duration(milliseconds: 250))
        .switchMap((event) => _eventToState(event))
        .forEach((PveLoginState state) {
          _stateSubject.add(state);
        });

    _eventSubject
        .where((event) {
          return (event is LoginWithCredentialsPressed);
        })
        .switchMap((event) => _eventToState(event))
        .forEach((PveLoginState state) {
          _stateSubject.add(state);
        });
  }

  Stream<PveLoginState> _eventToState(PveLoginEvent event) async* {
    if (event is UsernameChanged) {
      yield* _mapUsernameChangedToState(event.username);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        username: event.username,
        password: event.password,
      );
    }
  }

  Stream<PveLoginState> _mapUsernameChangedToState(String username) async* {
    //TODO implement username validator?
    yield _stateSubject.value.rebuild((b) => b..isUsernameValid = true);
  }

  Stream<PveLoginState> _mapPasswordChangedToState(String password) async* {
    //TODO implement password validator?
    yield _stateSubject.value.rebuild(
      (b) => b..isPasswordValid = true,
    );
  }

  Stream<PveLoginState> _mapLoginWithCredentialsPressedToState({
    String username,
    String password,
  }) async* {
    yield PveLoginState.loading();
    try {
      final client = await proxclient.authenticate(username, password);
      yield PveLoginState.success(apiClient: client);
    } catch (e, trace) {
      print("ERROR Login:$e");
      print(trace);
      yield PveLoginState.failure();
    }
  }

  void dispose() {
    _eventSubject.close();
    _stateSubject.close();
  }
}
