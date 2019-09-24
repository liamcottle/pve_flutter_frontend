import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/events/pve_guest_id_selector_events.dart';
import 'package:pve_flutter_frontend/states/pve_guest_id_selector_states.dart';
import 'package:rxdart/rxdart.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

class PveGuestIdSelectorBloc {
  final proxclient.Client apiClient;
  final PublishSubject<PveGuestIdSelectorEvent> _eventSubject =
      PublishSubject<PveGuestIdSelectorEvent>();
  BehaviorSubject<PveGuestIdSelectorState> _stateSubject;

  StreamSink<PveGuestIdSelectorEvent> get events => _eventSubject.sink;
  Stream<PveGuestIdSelectorState> get state => _stateSubject.stream;

  PveGuestIdSelectorBloc({@required this.apiClient}) {
    _stateSubject = BehaviorSubject<PveGuestIdSelectorState>();
    _eventSubject
        .debounceTime(Duration(milliseconds: 250))
        .switchMap((event) => _eventToState(event))
        .forEach((PveGuestIdSelectorState state) {
      _stateSubject.add(state);
    });
  }

  Stream<PveGuestIdSelectorState> _eventToState(
      PveGuestIdSelectorEvent event) async* {
    print(event);

    if (event is LoadNextFreeId) {
      final id = await getNextFreeID();
      yield PveGuestIdSelectorState(id: id);
    }

    if (event is ValidateInput) {
      if (event.id == "") {
        yield PveGuestIdSelectorState(id: event.id, error: "Input required");
        return;
      }

      try {
        final id = await getNextFreeID(id: event.id);
        yield PveGuestIdSelectorState(id: id);
      } on proxclient.ProxmoxApiException catch (e) {
        if (e.details != null && e.details['vmid'] != null) {
          yield PveGuestIdSelectorState(id: event.id, error: e.details['vmid']);
        }
      }
    }
  }

  void dispose() {
    _eventSubject.close();
    _stateSubject.close();
  }

  Future<String> getNextFreeID({String id}) async {
    var url = Uri.parse(
        proxclient.getPlatformAwareOrigin() + '/api2/json/cluster/nextid');
    if (id != null) {
      url = url.resolveUri(Uri(queryParameters: {
        "vmid": id,
      }));
    }
    final response = await apiClient.get(url);
    apiClient.validateResponse(response, true);
    var jsonBody = json.decode(response.body);
    return jsonBody['data'];
  }
}
