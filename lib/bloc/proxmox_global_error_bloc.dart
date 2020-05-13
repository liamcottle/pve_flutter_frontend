import 'package:rxdart/rxdart.dart';

class ProxmoxGlobalErrorBloc {
  static final ProxmoxGlobalErrorBloc _singleton =
      ProxmoxGlobalErrorBloc._internal();

  final PublishSubject<Object> _errorEventController = PublishSubject<Object>();
  Function(Object) get addError => _errorEventController.sink.add;
  Stream<Object> get onError => _errorEventController.stream;

  bool dialogVisible = false;

  factory ProxmoxGlobalErrorBloc() {
    return _singleton;
  }

  ProxmoxGlobalErrorBloc._internal();
}
