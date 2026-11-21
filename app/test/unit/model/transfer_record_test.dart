import 'package:localsend_app/model/persistence/transfer_record.dart';
import 'package:test/test.dart';

void main() {
  test('round-trips transfer metadata without file paths', () {
    final record = TransferRecord(
      id: 'session-1',
      direction: TransferDirection.sent,
      peerFingerprint: 'ABC123',
      peerAlias: 'Laptop',
      fileCount: 2,
      totalBytes: 4096,
      startedAt: DateTime.utc(2026, 1, 1, 3),
      completedAt: DateTime.utc(2026, 1, 1, 4),
      outcome: TransferOutcome.completed,
      errorMessage: null,
    );

    final json = record.toJson();
    expect(json, isNot(contains('path')));
    expect(TransferRecord.fromJson(json), record);
  });

  test('rejects unknown enum values', () {
    expect(
      () => TransferRecord.fromJson({
        'id': 'session-1',
        'direction': 'sideways',
        'peerFingerprint': 'ABC123',
        'peerAlias': 'Laptop',
        'fileCount': 1,
        'totalBytes': 1,
        'startedAt': '2026-01-01T00:00:00Z',
        'completedAt': '2026-01-01T00:00:01Z',
        'outcome': 'completed',
        'errorMessage': null,
      }),
      throwsA(isA<ArgumentError>()),
    );
  });
}
