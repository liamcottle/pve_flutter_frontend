import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_global_error_bloc.dart';
import 'package:rxdart/rxdart.dart';

abstract class ProxmoxBaseBloc<E, S> {
  final PublishSubject<E> _eventSubject = PublishSubject<E>();

  BehaviorSubject<S> _stateSubject;

  StreamSink<E> get events => _eventSubject.sink;

  ValueStream<S> get state => _stateSubject.stream;

  bool get hasListener => _stateSubject.hasListener;

  S get latestState => _stateSubject.stream.value;

  S get initialState;

  void doOnListen() {}
  void doOnCancel() {}

  ProxmoxBaseBloc() {
    _stateSubject = BehaviorSubject<S>.seeded(initialState,
        onCancel: doOnCancel, onListen: doOnListen);
    _initEventPipe();
  }

  Stream<S> processEvents(E event);

  Stream<S> eventPipe(
    PublishSubject<E> events,
    Stream<S> pipeInto(E event),
  ) {
    return events.asyncExpand(pipeInto);
  }

  void _initEventPipe() {
    eventPipe(_eventSubject,
            (event) => processEvents(event).handleError(_errorHandler))
        .forEach((S state) {
      if (_stateSubject.isClosed) return;
      _stateSubject.add(state);
    });
  }

  void _errorHandler(Object error, [StackTrace stacktrace]) {
    ProxmoxGlobalErrorBloc().addError(error);
    print(error);
    print(stacktrace);
  }

  @mustCallSuper
  void dispose() {
    _eventSubject?.close();
    _stateSubject?.close();
  }
}
