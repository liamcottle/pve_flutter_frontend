// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pve_nodes_qemu_create_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProcessorArch _$x86_64 = const ProcessorArch._('x86_64');
const ProcessorArch _$aarch64 = const ProcessorArch._('aarch64');

ProcessorArch _$paValueOf(String name) {
  switch (name) {
    case 'x86_64':
      return _$x86_64;
    case 'aarch64':
      return _$aarch64;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ProcessorArch> _$paValues =
    new BuiltSet<ProcessorArch>(const <ProcessorArch>[
  _$x86_64,
  _$aarch64,
]);

const Bios _$seabios = const Bios._('seabios');
const Bios _$ovmf = const Bios._('ovmf');

Bios _$biValueOf(String name) {
  switch (name) {
    case 'seabios':
      return _$seabios;
    case 'ovmf':
      return _$ovmf;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<Bios> _$biValues = new BuiltSet<Bios>(const <Bios>[
  _$seabios,
  _$ovmf,
]);

const OSType _$other = const OSType._('other');
const OSType _$wxp = const OSType._('wxp');
const OSType _$w2k = const OSType._('w2k');
const OSType _$w2k3 = const OSType._('w2k3');
const OSType _$w2k8 = const OSType._('w2k8');
const OSType _$wvista = const OSType._('wvista');
const OSType _$win7 = const OSType._('win7');
const OSType _$win8 = const OSType._('win8');
const OSType _$win10 = const OSType._('win10');
const OSType _$l24 = const OSType._('l24');
const OSType _$l26 = const OSType._('l26');
const OSType _$solaris = const OSType._('solaris');

OSType _$osValueOf(String name) {
  switch (name) {
    case 'other':
      return _$other;
    case 'wxp':
      return _$wxp;
    case 'w2k':
      return _$w2k;
    case 'w2k3':
      return _$w2k3;
    case 'w2k8':
      return _$w2k8;
    case 'wvista':
      return _$wvista;
    case 'win7':
      return _$win7;
    case 'win8':
      return _$win8;
    case 'win10':
      return _$win10;
    case 'l24':
      return _$l24;
    case 'l26':
      return _$l26;
    case 'solaris':
      return _$solaris;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<OSType> _$osValues = new BuiltSet<OSType>(const <OSType>[
  _$other,
  _$wxp,
  _$w2k,
  _$w2k3,
  _$w2k8,
  _$wvista,
  _$win7,
  _$win8,
  _$win10,
  _$l24,
  _$l26,
  _$solaris,
]);

const ScsiControllerModel _$lsi = const ScsiControllerModel._('lsi');
const ScsiControllerModel _$lsi53c810 =
    const ScsiControllerModel._('lsi53c810');
const ScsiControllerModel _$virtioScsiPci =
    const ScsiControllerModel._('virtioScsiPci');
const ScsiControllerModel _$virtioScsiSingle =
    const ScsiControllerModel._('virtioScsiSingle');
const ScsiControllerModel _$megasas = const ScsiControllerModel._('megasas');
const ScsiControllerModel _$pvscsi = const ScsiControllerModel._('pvscsi');

ScsiControllerModel _$scValueOf(String name) {
  switch (name) {
    case 'lsi':
      return _$lsi;
    case 'lsi53c810':
      return _$lsi53c810;
    case 'virtioScsiPci':
      return _$virtioScsiPci;
    case 'virtioScsiSingle':
      return _$virtioScsiSingle;
    case 'megasas':
      return _$megasas;
    case 'pvscsi':
      return _$pvscsi;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ScsiControllerModel> _$scValues =
    new BuiltSet<ScsiControllerModel>(const <ScsiControllerModel>[
  _$lsi,
  _$lsi53c810,
  _$virtioScsiPci,
  _$virtioScsiSingle,
  _$megasas,
  _$pvscsi,
]);

const CdType _$iso = const CdType._('iso');
const CdType _$cdrom = const CdType._('cdrom');
const CdType _$none = const CdType._('none');

CdType _$valueOf(String name) {
  switch (name) {
    case 'iso':
      return _$iso;
    case 'cdrom':
      return _$cdrom;
    case 'none':
      return _$none;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CdType> _$values = new BuiltSet<CdType>(const <CdType>[
  _$iso,
  _$cdrom,
  _$none,
]);

Serializer<PveNodeQemuCreateModel> _$pveNodeQemuCreateModelSerializer =
    new _$PveNodeQemuCreateModelSerializer();
Serializer<ProcessorArch> _$processorArchSerializer =
    new _$ProcessorArchSerializer();
Serializer<Bios> _$biosSerializer = new _$BiosSerializer();
Serializer<OSType> _$oSTypeSerializer = new _$OSTypeSerializer();
Serializer<ScsiControllerModel> _$scsiControllerModelSerializer =
    new _$ScsiControllerModelSerializer();
Serializer<CdType> _$cdTypeSerializer = new _$CdTypeSerializer();

class _$PveNodeQemuCreateModelSerializer
    implements StructuredSerializer<PveNodeQemuCreateModel> {
  @override
  final Iterable<Type> types = const [
    PveNodeQemuCreateModel,
    _$PveNodeQemuCreateModel
  ];
  @override
  final String wireName = 'PveNodeQemuCreateModel';

  @override
  Iterable<Object> serialize(
      Serializers serializers, PveNodeQemuCreateModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'node',
      serializers.serialize(object.node, specifiedType: const FullType(String)),
      'vmid',
      serializers.serialize(object.vmid, specifiedType: const FullType(int)),
    ];
    if (object.acpi != null) {
      result
        ..add('acpi')
        ..add(serializers.serialize(object.acpi,
            specifiedType: const FullType(bool)));
    }
    if (object.arch != null) {
      result
        ..add('arch')
        ..add(serializers.serialize(object.arch,
            specifiedType: const FullType(ProcessorArch)));
    }
    if (object.archive != null) {
      result
        ..add('archive')
        ..add(serializers.serialize(object.archive,
            specifiedType: const FullType(String)));
    }
    if (object.autostart != null) {
      result
        ..add('autostart')
        ..add(serializers.serialize(object.autostart,
            specifiedType: const FullType(bool)));
    }
    if (object.balloon != null) {
      result
        ..add('balloon')
        ..add(serializers.serialize(object.balloon,
            specifiedType: const FullType(int)));
    }
    if (object.bios != null) {
      result
        ..add('bios')
        ..add(serializers.serialize(object.bios,
            specifiedType: const FullType(Bios)));
    }
    if (object.boot != null) {
      result
        ..add('boot')
        ..add(serializers.serialize(object.boot,
            specifiedType: const FullType(String)));
    }
    if (object.bootdisk != null) {
      result
        ..add('bootdisk')
        ..add(serializers.serialize(object.bootdisk,
            specifiedType: const FullType(String)));
    }
    if (object.bewlimit != null) {
      result
        ..add('bewlimit')
        ..add(serializers.serialize(object.bewlimit,
            specifiedType: const FullType(int)));
    }
    if (object.cdrom != null) {
      result
        ..add('cdrom')
        ..add(serializers.serialize(object.cdrom,
            specifiedType: const FullType(String)));
    }
    if (object.media != null) {
      result
        ..add('media')
        ..add(serializers.serialize(object.media,
            specifiedType: const FullType(CdType)));
    }
    if (object.cores != null) {
      result
        ..add('cores')
        ..add(serializers.serialize(object.cores,
            specifiedType: const FullType(int)));
    }
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description,
            specifiedType: const FullType(String)));
    }
    if (object.memory != null) {
      result
        ..add('memory')
        ..add(serializers.serialize(object.memory,
            specifiedType: const FullType(int)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.net0 != null) {
      result
        ..add('net0')
        ..add(serializers.serialize(object.net0,
            specifiedType: const FullType(String)));
    }
    if (object.ostype != null) {
      result
        ..add('ostype')
        ..add(serializers.serialize(object.ostype,
            specifiedType: const FullType(OSType)));
    }
    if (object.scsi0 != null) {
      result
        ..add('scsi0')
        ..add(serializers.serialize(object.scsi0,
            specifiedType: const FullType(String)));
    }
    if (object.scsihw != null) {
      result
        ..add('scsihw')
        ..add(serializers.serialize(object.scsihw,
            specifiedType: const FullType(ScsiControllerModel)));
    }
    if (object.sockets != null) {
      result
        ..add('sockets')
        ..add(serializers.serialize(object.sockets,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  PveNodeQemuCreateModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PveNodeQemuCreateModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'node':
          result.node = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'vmid':
          result.vmid = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'acpi':
          result.acpi = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'arch':
          result.arch = serializers.deserialize(value,
              specifiedType: const FullType(ProcessorArch)) as ProcessorArch;
          break;
        case 'archive':
          result.archive = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'autostart':
          result.autostart = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'balloon':
          result.balloon = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'bios':
          result.bios = serializers.deserialize(value,
              specifiedType: const FullType(Bios)) as Bios;
          break;
        case 'boot':
          result.boot = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'bootdisk':
          result.bootdisk = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'bewlimit':
          result.bewlimit = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'cdrom':
          result.cdrom = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'media':
          result.media = serializers.deserialize(value,
              specifiedType: const FullType(CdType)) as CdType;
          break;
        case 'cores':
          result.cores = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'memory':
          result.memory = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'net0':
          result.net0 = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'ostype':
          result.ostype = serializers.deserialize(value,
              specifiedType: const FullType(OSType)) as OSType;
          break;
        case 'scsi0':
          result.scsi0 = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'scsihw':
          result.scsihw = serializers.deserialize(value,
                  specifiedType: const FullType(ScsiControllerModel))
              as ScsiControllerModel;
          break;
        case 'sockets':
          result.sockets = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$ProcessorArchSerializer implements PrimitiveSerializer<ProcessorArch> {
  @override
  final Iterable<Type> types = const <Type>[ProcessorArch];
  @override
  final String wireName = 'arch';

  @override
  Object serialize(Serializers serializers, ProcessorArch object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  ProcessorArch deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProcessorArch.valueOf(serialized as String);
}

class _$BiosSerializer implements PrimitiveSerializer<Bios> {
  @override
  final Iterable<Type> types = const <Type>[Bios];
  @override
  final String wireName = 'bios';

  @override
  Object serialize(Serializers serializers, Bios object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  Bios deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      Bios.valueOf(serialized as String);
}

class _$OSTypeSerializer implements PrimitiveSerializer<OSType> {
  @override
  final Iterable<Type> types = const <Type>[OSType];
  @override
  final String wireName = 'ostype';

  @override
  Object serialize(Serializers serializers, OSType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  OSType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OSType.valueOf(serialized as String);
}

class _$ScsiControllerModelSerializer
    implements PrimitiveSerializer<ScsiControllerModel> {
  @override
  final Iterable<Type> types = const <Type>[ScsiControllerModel];
  @override
  final String wireName = 'scsihw';

  @override
  Object serialize(Serializers serializers, ScsiControllerModel object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  ScsiControllerModel deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ScsiControllerModel.valueOf(serialized as String);
}

class _$CdTypeSerializer implements PrimitiveSerializer<CdType> {
  @override
  final Iterable<Type> types = const <Type>[CdType];
  @override
  final String wireName = 'CdType';

  @override
  Object serialize(Serializers serializers, CdType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  CdType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CdType.valueOf(serialized as String);
}

class _$PveNodeQemuCreateModel extends PveNodeQemuCreateModel {
  @override
  final String node;
  @override
  final int vmid;
  @override
  final bool acpi;
  @override
  final ProcessorArch arch;
  @override
  final String archive;
  @override
  final bool autostart;
  @override
  final int balloon;
  @override
  final Bios bios;
  @override
  final String boot;
  @override
  final String bootdisk;
  @override
  final int bewlimit;
  @override
  final String cdrom;
  @override
  final CdType media;
  @override
  final int cores;
  @override
  final String description;
  @override
  final int memory;
  @override
  final String name;
  @override
  final String net0;
  @override
  final OSType ostype;
  @override
  final String scsi0;
  @override
  final ScsiControllerModel scsihw;
  @override
  final int sockets;

  factory _$PveNodeQemuCreateModel(
          [void Function(PveNodeQemuCreateModelBuilder) updates]) =>
      (new PveNodeQemuCreateModelBuilder()..update(updates)).build();

  _$PveNodeQemuCreateModel._(
      {this.node,
      this.vmid,
      this.acpi,
      this.arch,
      this.archive,
      this.autostart,
      this.balloon,
      this.bios,
      this.boot,
      this.bootdisk,
      this.bewlimit,
      this.cdrom,
      this.media,
      this.cores,
      this.description,
      this.memory,
      this.name,
      this.net0,
      this.ostype,
      this.scsi0,
      this.scsihw,
      this.sockets})
      : super._() {
    if (node == null) {
      throw new BuiltValueNullFieldError('PveNodeQemuCreateModel', 'node');
    }
    if (vmid == null) {
      throw new BuiltValueNullFieldError('PveNodeQemuCreateModel', 'vmid');
    }
  }

  @override
  PveNodeQemuCreateModel rebuild(
          void Function(PveNodeQemuCreateModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PveNodeQemuCreateModelBuilder toBuilder() =>
      new PveNodeQemuCreateModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PveNodeQemuCreateModel &&
        node == other.node &&
        vmid == other.vmid &&
        acpi == other.acpi &&
        arch == other.arch &&
        archive == other.archive &&
        autostart == other.autostart &&
        balloon == other.balloon &&
        bios == other.bios &&
        boot == other.boot &&
        bootdisk == other.bootdisk &&
        bewlimit == other.bewlimit &&
        cdrom == other.cdrom &&
        media == other.media &&
        cores == other.cores &&
        description == other.description &&
        memory == other.memory &&
        name == other.name &&
        net0 == other.net0 &&
        ostype == other.ostype &&
        scsi0 == other.scsi0 &&
        scsihw == other.scsihw &&
        sockets == other.sockets;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc($jc($jc($jc(0, node.hashCode), vmid.hashCode), acpi.hashCode),
                                                                                arch.hashCode),
                                                                            archive.hashCode),
                                                                        autostart.hashCode),
                                                                    balloon.hashCode),
                                                                bios.hashCode),
                                                            boot.hashCode),
                                                        bootdisk.hashCode),
                                                    bewlimit.hashCode),
                                                cdrom.hashCode),
                                            media.hashCode),
                                        cores.hashCode),
                                    description.hashCode),
                                memory.hashCode),
                            name.hashCode),
                        net0.hashCode),
                    ostype.hashCode),
                scsi0.hashCode),
            scsihw.hashCode),
        sockets.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PveNodeQemuCreateModel')
          ..add('node', node)
          ..add('vmid', vmid)
          ..add('acpi', acpi)
          ..add('arch', arch)
          ..add('archive', archive)
          ..add('autostart', autostart)
          ..add('balloon', balloon)
          ..add('bios', bios)
          ..add('boot', boot)
          ..add('bootdisk', bootdisk)
          ..add('bewlimit', bewlimit)
          ..add('cdrom', cdrom)
          ..add('media', media)
          ..add('cores', cores)
          ..add('description', description)
          ..add('memory', memory)
          ..add('name', name)
          ..add('net0', net0)
          ..add('ostype', ostype)
          ..add('scsi0', scsi0)
          ..add('scsihw', scsihw)
          ..add('sockets', sockets))
        .toString();
  }
}

class PveNodeQemuCreateModelBuilder
    implements Builder<PveNodeQemuCreateModel, PveNodeQemuCreateModelBuilder> {
  _$PveNodeQemuCreateModel _$v;

  String _node;
  String get node => _$this._node;
  set node(String node) => _$this._node = node;

  int _vmid;
  int get vmid => _$this._vmid;
  set vmid(int vmid) => _$this._vmid = vmid;

  bool _acpi;
  bool get acpi => _$this._acpi;
  set acpi(bool acpi) => _$this._acpi = acpi;

  ProcessorArch _arch;
  ProcessorArch get arch => _$this._arch;
  set arch(ProcessorArch arch) => _$this._arch = arch;

  String _archive;
  String get archive => _$this._archive;
  set archive(String archive) => _$this._archive = archive;

  bool _autostart;
  bool get autostart => _$this._autostart;
  set autostart(bool autostart) => _$this._autostart = autostart;

  int _balloon;
  int get balloon => _$this._balloon;
  set balloon(int balloon) => _$this._balloon = balloon;

  Bios _bios;
  Bios get bios => _$this._bios;
  set bios(Bios bios) => _$this._bios = bios;

  String _boot;
  String get boot => _$this._boot;
  set boot(String boot) => _$this._boot = boot;

  String _bootdisk;
  String get bootdisk => _$this._bootdisk;
  set bootdisk(String bootdisk) => _$this._bootdisk = bootdisk;

  int _bewlimit;
  int get bewlimit => _$this._bewlimit;
  set bewlimit(int bewlimit) => _$this._bewlimit = bewlimit;

  String _cdrom;
  String get cdrom => _$this._cdrom;
  set cdrom(String cdrom) => _$this._cdrom = cdrom;

  CdType _media;
  CdType get media => _$this._media;
  set media(CdType media) => _$this._media = media;

  int _cores;
  int get cores => _$this._cores;
  set cores(int cores) => _$this._cores = cores;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  int _memory;
  int get memory => _$this._memory;
  set memory(int memory) => _$this._memory = memory;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _net0;
  String get net0 => _$this._net0;
  set net0(String net0) => _$this._net0 = net0;

  OSType _ostype;
  OSType get ostype => _$this._ostype;
  set ostype(OSType ostype) => _$this._ostype = ostype;

  String _scsi0;
  String get scsi0 => _$this._scsi0;
  set scsi0(String scsi0) => _$this._scsi0 = scsi0;

  ScsiControllerModel _scsihw;
  ScsiControllerModel get scsihw => _$this._scsihw;
  set scsihw(ScsiControllerModel scsihw) => _$this._scsihw = scsihw;

  int _sockets;
  int get sockets => _$this._sockets;
  set sockets(int sockets) => _$this._sockets = sockets;

  PveNodeQemuCreateModelBuilder();

  PveNodeQemuCreateModelBuilder get _$this {
    if (_$v != null) {
      _node = _$v.node;
      _vmid = _$v.vmid;
      _acpi = _$v.acpi;
      _arch = _$v.arch;
      _archive = _$v.archive;
      _autostart = _$v.autostart;
      _balloon = _$v.balloon;
      _bios = _$v.bios;
      _boot = _$v.boot;
      _bootdisk = _$v.bootdisk;
      _bewlimit = _$v.bewlimit;
      _cdrom = _$v.cdrom;
      _media = _$v.media;
      _cores = _$v.cores;
      _description = _$v.description;
      _memory = _$v.memory;
      _name = _$v.name;
      _net0 = _$v.net0;
      _ostype = _$v.ostype;
      _scsi0 = _$v.scsi0;
      _scsihw = _$v.scsihw;
      _sockets = _$v.sockets;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PveNodeQemuCreateModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PveNodeQemuCreateModel;
  }

  @override
  void update(void Function(PveNodeQemuCreateModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PveNodeQemuCreateModel build() {
    final _$result = _$v ??
        new _$PveNodeQemuCreateModel._(
            node: node,
            vmid: vmid,
            acpi: acpi,
            arch: arch,
            archive: archive,
            autostart: autostart,
            balloon: balloon,
            bios: bios,
            boot: boot,
            bootdisk: bootdisk,
            bewlimit: bewlimit,
            cdrom: cdrom,
            media: media,
            cores: cores,
            description: description,
            memory: memory,
            name: name,
            net0: net0,
            ostype: ostype,
            scsi0: scsi0,
            scsihw: scsihw,
            sockets: sockets);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
