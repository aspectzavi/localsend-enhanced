import 'package:localsend_app/model/persistence/device_trust_record.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:refena_flutter/refena_flutter.dart';

/// Stores explicit trust and auto-accept policy by certificate fingerprint.
///
/// This provider deliberately does not infer trust from favorites. Callers
/// must dispatch [UpsertDeviceTrustAction] with an explicit policy.
final deviceTrustProvider = ReduxProvider<DeviceTrustService, List<DeviceTrustRecord>>((ref) {
  return DeviceTrustService(ref.read(persistenceProvider));
});

class DeviceTrustService extends ReduxNotifier<List<DeviceTrustRecord>> {
  final PersistenceService _persistence;

  DeviceTrustService(this._persistence);

  @override
  List<DeviceTrustRecord> init() => List.unmodifiable(_persistence.getDeviceTrustRecords());
}

class UpsertDeviceTrustAction extends AsyncReduxAction<DeviceTrustService, List<DeviceTrustRecord>> {
  final DeviceTrustRecord record;

  UpsertDeviceTrustAction(this.record);

  @override
  Future<List<DeviceTrustRecord>> reduce() async {
    final updated = [...state];
    final index = updated.indexWhere((entry) => entry.fingerprint == record.fingerprint);
    if (index == -1) {
      updated.add(record);
    } else {
      updated[index] = record;
    }
    final result = List<DeviceTrustRecord>.unmodifiable(updated);
    await notifier._persistence.setDeviceTrustRecords(result);
    return result;
  }
}

class SetDeviceTrustAction extends AsyncReduxAction<DeviceTrustService, List<DeviceTrustRecord>> {
  final String fingerprint;
  final bool trusted;

  SetDeviceTrustAction({required this.fingerprint, required this.trusted});

  @override
  Future<List<DeviceTrustRecord>> reduce() async {
    final index = state.indexWhere((entry) => entry.fingerprint == fingerprint);
    if (index == -1) return state;
    final updated = [...state];
    updated[index] = updated[index].copyWith(trusted: trusted);
    final result = List<DeviceTrustRecord>.unmodifiable(updated);
    await notifier._persistence.setDeviceTrustRecords(result);
    return result;
  }
}

class SetDeviceAutoAcceptAction extends AsyncReduxAction<DeviceTrustService, List<DeviceTrustRecord>> {
  final String fingerprint;
  final bool autoAccept;

  SetDeviceAutoAcceptAction({required this.fingerprint, required this.autoAccept});

  @override
  Future<List<DeviceTrustRecord>> reduce() async {
    final index = state.indexWhere((entry) => entry.fingerprint == fingerprint);
    if (index == -1) return state;
    final updated = [...state];
    updated[index] = updated[index].copyWith(autoAccept: autoAccept);
    final result = List<DeviceTrustRecord>.unmodifiable(updated);
    await notifier._persistence.setDeviceTrustRecords(result);
    return result;
  }
}

class RemoveDeviceTrustAction extends AsyncReduxAction<DeviceTrustService, List<DeviceTrustRecord>> {
  final String fingerprint;

  RemoveDeviceTrustAction({required this.fingerprint});

  @override
  Future<List<DeviceTrustRecord>> reduce() async {
    final result = List<DeviceTrustRecord>.unmodifiable(
      state.where((entry) => entry.fingerprint != fingerprint),
    );
    if (result.length == state.length) return state;
    await notifier._persistence.setDeviceTrustRecords(result);
    return result;
  }
}
