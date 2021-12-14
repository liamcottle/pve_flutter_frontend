import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_global_error_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart' show ValueStreamExtensions;

abstract class ProxmoxBaseBloc<E, S> {
  final PublishSubject<E> _eventSubject = PublishSubject<E>();

  late final BehaviorSubject<S> _stateSubject;

  StreamSink<E> get events => _eventSubject.sink;

  ValueStream<S> get state => _stateSubject.stream;

  bool get hasListener => _stateSubject.hasListener;

  S get latestState => _stateSubject.stream.value;
  S get initialState;

  S? penultimate;

  void doOnListen() {}
  void doOnCancel() {}

  ProxmoxBaseBloc() {
    _stateSubject = BehaviorSubject<S>.seeded(
      initialState,
      onCancel: doOnCancel,
      onListen: doOnListen,
    );
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
    eventPipe(_eventSubject, (event) {
      // can happen if request returns after user navigated somewhere else
      if (_eventSubject.isClosed) return Stream.empty();
      return processEvents(event).handleError(_errorHandler);
    }).forEach((S state) {
      penultimate = latestState;
      if (_stateSubject.isClosed) return;
      _stateSubject.add(state);
    });
  }

  void _errorHandler(Object error, [StackTrace? stacktrace]) {
    ProxmoxGlobalErrorBloc().addError(error);
    print(error);
    print(stacktrace);
  }

  @mustCallSuper
  void dispose() {
    _eventSubject.close();
    _stateSubject.close();
  }
}
