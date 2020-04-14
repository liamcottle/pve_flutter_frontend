import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
part 'pve_qemu_create_wizard_state.g.dart';

// vmid: 100
// ide2: nfs:iso/alpine-standard-3.10.2-x86_64.iso,media=cdrom
// ostype: l26
// scsihw: virtio-scsi-pci
// scsi0: local-lvm:32
// sockets: 1
// cores: 1
// numa: 0
// memory: 512
// net0: virtio,bridge=vmbr0,firewall=1

abstract class PveQemuCreateWizardState
    implements
        Built<PveQemuCreateWizardState, PveQemuCreateWizardStateBuilder> {
  PveQemuCreateWizardState._();
  factory PveQemuCreateWizardState(
          [void Function(PveQemuCreateWizardStateBuilder) updates]) =
      _$PveQemuCreateWizardState;

  int get currentStep;
  @nullable
  String get node;
  @nullable
  int get vmid;

  @nullable
  bool get acpi;

  @nullable
  ProcessorArch get arch;

  @nullable
  String get archive;

  @nullable
  bool get autostart;

  @nullable
  int get balloon;

  @nullable
  Bios get bios;

  @nullable
  String get boot;

  @nullable
  String get bootdisk;

  @nullable
  int get bewlimit;

  @nullable
  String get cdrom;

  @nullable
  CdType get media;

  @nullable
  int get cores;

  @nullable
  String get description;

  @nullable
  int get memory;

  @nullable
  String get name;

  //TODO add generator
  @nullable
  String get net0;

  @nullable
  OSType get ostype;

  //TODO add generator
  @nullable
  String get scsi0;

  @nullable
  ScsiControllerModel get scsihw;

  @nullable
  int get sockets;
}