import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/proxmox_form_field_state.dart';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

class PveGuestIdSelectorBloc
    extends ProxmoxBaseBloc<PveGuestIdSelectorEvent, GuestIdSelectorState> {
  final proxclient.Client apiClient;

  @override
  GuestIdSelectorState get initialState => GuestIdSelectorState();

  PveGuestIdSelectorBloc({@required this.apiClient});

  @override
  Stream<GuestIdSelectorState> eventPipe(
    PublishSubject<PveGuestIdSelectorEvent> events,
    Stream<GuestIdSelectorState> pipeInto(PveGuestIdSelectorEvent event),
  ) {
    return events.debounceTime(Duration(milliseconds: 150)).switchMap(pipeInto);
  }

  @override
  Stream<GuestIdSelectorState> processEvents(
      PveGuestIdSelectorEvent event) async* {
    if (event is PrefetchId) {
      try {
        final id = await getNextFreeID();
        yield GuestIdSelectorState(value: id);
      } on proxclient.ProxmoxApiException catch (e) {
        yield GuestIdSelectorState(value: null, errorText: "Could not load ID");
      }
    }
    if (event is OnChanged) {
      if (event.id == "") {
        yield GuestIdSelectorState(
            value: event.id, errorText: "Input required");
        return;
      }

      try {
        final id = await getNextFreeID(id: event.id);
        yield GuestIdSelectorState(value: id);
      } on proxclient.ProxmoxApiException catch (e) {
        if (e.details != null && e.details['vmid'] != null) {
          yield GuestIdSelectorState(
              value: event.id, errorText: e.details['vmid']);
        }
      }
    }
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

abstract class PveGuestIdSelectorEvent {}

class PrefetchId extends PveGuestIdSelectorEvent {}

class OnChanged extends PveGuestIdSelectorEvent {
  final String id;

  OnChanged(this.id);
}

class GuestIdSelectorState extends PveFormFieldState<String> {
  GuestIdSelectorState({String value, String errorText})
      : super(value: value, errorText: errorText);
}
