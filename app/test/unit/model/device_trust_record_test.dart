import 'package:localsend_app/model/persistence/device_trust_record.dart';
import 'package:test/test.dart';

void main() {
  test('round-trips identity and explicit trust policy', () {
    final record = DeviceTrustRecord(
      fingerprint: 'ABC123',
      alias: 'Work laptop',
      firstSeen: DateTime.utc(2026, 1, 2, 3, 4),
      lastSeen: DateTime.utc(2026, 1, 3, 4, 5),
      trusted: true,
      autoAccept: true,
    );

    expect(DeviceTrustRecord.fromJson(record.toJson()), record);
    expect(record.canAutoAccept, isTrue);
  });

  test('auto-accept is never effective without trust', () {
    final record = DeviceTrustRecord(
      fingerprint: 'ABC123',
      alias: 'Unknown laptop',
      firstSeen: DateTime.utc(2026),
      lastSeen: DateTime.utc(2026),
      trusted: false,
      autoAccept: true,
    );

    expect(record.canAutoAccept, isFalse);
  });

  test('rejects malformed records', () {
    expect(
      () => DeviceTrustRecord.fromJson({'fingerprint': 'ABC123'}),
      throwsA(isA<FormatException>()),
    );
  });
}
