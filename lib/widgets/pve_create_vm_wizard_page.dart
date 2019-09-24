import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_selector_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_node_selector_events.dart';
import 'package:pve_flutter_frontend/utils/proxmox_layout_builder.dart';
import 'package:pve_flutter_frontend/widgets/pve_node_selector_widget.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;
class PveCreateVmWizard extends StatelessWidget {
  static const routeName = '/qemu/create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Virtual Machine"),
      ),
      body: ProxmoxLayoutBuilder(
        builder: (context, layout) => layout != ProxmoxLayout.slim
            ? Stepper(
                type: StepperType.horizontal,
                currentStep: 0,
                steps: getSteps(),
              )
            : Stepper(
                type: StepperType.vertical,
                currentStep: 0,
                steps: getSteps(),
              ),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(title: Text("General"), content: _General()),
      Step(title: Text("OS"), content: Container()),
      Step(title: Text("System"), content: Container()),
      Step(title: Text("Disks"), content: Container()),
      Step(title: Text("CPU"), content: Container()),
      Step(title: Text("Memory"), content: Container()),
      Step(title: Text("Network"), content: Container()),
    ];
  }
}

class _General extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiClient = Provider.of<proxclient.Client>(context);
    return Form(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Provider<PveNodeSelectorBloc>(
                builder: (context) => PveNodeSelectorBloc(apiClient: apiClient)
                ..events.add(LoadNodesEvent()),
                dispose: (context, value) => value.dispose(),
                child: PveNodeSelector(),
              ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  errorText: 'todo',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
