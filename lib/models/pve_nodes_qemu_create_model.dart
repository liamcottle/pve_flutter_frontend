import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pve_nodes_qemu_create_model.g.dart';

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

abstract class PveNodeQemuCreateModel implements Built<PveNodeQemuCreateModel, PveNodeQemuCreateModelBuilder> {
  PveNodeQemuCreateModel._();
  factory PveNodeQemuCreateModel([void Function(PveNodeQemuCreateModelBuilder) updates]) = _$PveNodeQemuCreateModel;

  static Serializer<PveNodeQemuCreateModel> get serializer => _$pveNodeQemuCreateModelSerializer;

  String get node;

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
@BuiltValueEnum(wireName: 'arch')
class ProcessorArch extends EnumClass {
  static Serializer<ProcessorArch> get serializer => _$processorArchSerializer;

  static const ProcessorArch x86_64 = _$x86_64;
  static const ProcessorArch aarch64 = _$aarch64;

  const ProcessorArch._(String name) : super(name);

  static BuiltSet<ProcessorArch> get values => _$paValues;
  static ProcessorArch valueOf(String name) => _$paValueOf(name);
}

@BuiltValueEnum(wireName: 'bios')
class Bios extends EnumClass {
  static Serializer<Bios> get serializer => _$biosSerializer;

  static const Bios seabios = _$seabios;
  static const Bios ovmf = _$ovmf;

  const Bios._(String name) : super(name);

  static BuiltSet<Bios> get values => _$biValues;
  static Bios valueOf(String name) => _$biValueOf(name);
}

@BuiltValueEnum(wireName: 'ostype')
class OSType extends EnumClass {
  static Serializer<OSType> get serializer => _$oSTypeSerializer;

  static const OSType other = _$other;
  static const OSType wxp = _$wxp;
  static const OSType w2k = _$w2k;
  static const OSType w2k3 = _$w2k3;
  static const OSType w2k8 = _$w2k8;
  static const OSType wvista = _$wvista;
  static const OSType win7 = _$win7;
  static const OSType win8 = _$win8;
  static const OSType win10 = _$win10;
  static const OSType l24 = _$l24;
  static const OSType l26 = _$l26;
  static const OSType solaris = _$solaris;

  const OSType._(String name) : super(name);

  static BuiltSet<OSType> get values => _$osValues;
  static OSType valueOf(String name) => _$osValueOf(name);
}

@BuiltValueEnum(wireName: 'scsihw')
class ScsiControllerModel extends EnumClass {
  static Serializer<ScsiControllerModel> get serializer => _$scsiControllerModelSerializer;

  static const ScsiControllerModel lsi = _$lsi;
  static const ScsiControllerModel lsi53c810 = _$lsi53c810;
  @BuiltValueField(wireName: 'virtio-scsi-pci')
  static const ScsiControllerModel virtioScsiPci = _$virtioScsiPci;
  @BuiltValueField(wireName: 'virtio-scsi-single')
  static const ScsiControllerModel virtioScsiSingle = _$virtioScsiSingle;
  static const ScsiControllerModel megasas = _$megasas;
  static const ScsiControllerModel pvscsi = _$pvscsi;


  const ScsiControllerModel._(String name) : super(name);

  static BuiltSet<ScsiControllerModel> get values => _$scValues;
  static ScsiControllerModel valueOf(String name) => _$scValueOf(name);
}

class CdType extends EnumClass {
  static Serializer<CdType> get serializer => _$cdTypeSerializer;

  static const CdType iso = _$iso;
  static const CdType cdrom = _$cdrom;
  static const CdType none = _$none;

  const CdType._(String name) : super(name);

  static BuiltSet<CdType> get values => _$values;
  static CdType valueOf(String name) => _$valueOf(name);
}