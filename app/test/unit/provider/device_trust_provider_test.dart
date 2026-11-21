import 'package:localsend_app/model/persistence/device_trust_record.dart';
import 'package:localsend_app/provider/device_trust_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:test/test.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockPersistenceService persistence;
  late DeviceTrustRecord record;

  setUp(() {
    persistence = MockPersistenceService();
    record = DeviceTrustRecord(
      fingerprint: 'ABC123',
      alias: 'Laptop',
      firstSeen: DateTime.utc(2026, 1, 1),
      lastSeen: DateTime.utc(2026, 1, 2),
      trusted: false,
      autoAccept: false,
    );
  });

  test('upsert replaces by certificate fingerprint', () async {
    final service = ReduxNotifier.test(redux: DeviceTrustService(persistence));

    await service.dispatchAsync(UpsertDeviceTrustAction(record));
    await service.dispatchAsync(UpsertDeviceTrustAction(record.copyWith(alias: 'Renamed')));

    expect(service.state, hasLength(1));
    expect(service.state.single.alias, 'Renamed');
    verify(persistence.setDeviceTrustRecords(any)).called(2);
  });

  test('trust and auto-accept are independently persisted', () async {
    final service = ReduxNotifier.test(
      redux: DeviceTrustService(persistence),
      initialState: [record],
    );

    await service.dispatchAsync(SetDeviceAutoAcceptAction(fingerprint: 'ABC123', autoAccept: true));
    expect(service.state.single.canAutoAccept, isFalse);

    await service.dispatchAsync(SetDeviceTrustAction(fingerprint: 'ABC123', trusted: true));
    expect(service.state.single.canAutoAccept, isTrue);
  });

  test('removing an unknown device does not write storage', () async {
    final service = ReduxNotifier.test(
      redux: DeviceTrustService(persistence),
      initialState: [record],
    );

    await service.dispatchAsync(RemoveDeviceTrustAction(fingerprint: 'UNKNOWN'));

    expect(service.state, [record]);
    verifyNever(persistence.setDeviceTrustRecords(any));
  });
}
