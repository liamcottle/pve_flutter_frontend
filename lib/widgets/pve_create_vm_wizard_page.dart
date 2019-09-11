import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/utils/proxmox_layout_builder.dart';
import 'package:pve_flutter_frontend/widgets/pve_node_selector_widget.dart';

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
    return Form(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              PveNodeSelector(),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'VM ID',
                  errorText: 'todo',
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
