enum TransferDirection { sent, received }

enum TransferOutcome { completed, failed, canceled }

/// Durable summary of a transfer. File contents and paths are intentionally
/// excluded so history does not become a second copy of user data.
class TransferRecord {
  final String id;
  final TransferDirection direction;
  final String peerFingerprint;
  final String peerAlias;
  final int fileCount;
  final int totalBytes;
  final DateTime startedAt;
  final DateTime completedAt;
  final TransferOutcome outcome;
  final String? errorMessage;

  const TransferRecord({
    required this.id,
    required this.direction,
    required this.peerFingerprint,
    required this.peerAlias,
    required this.fileCount,
    required this.totalBytes,
    required this.startedAt,
    required this.completedAt,
    required this.outcome,
    required this.errorMessage,
  });

  Map<String, Object?> toJson() => {
        'id': id,
        'direction': direction.name,
        'peerFingerprint': peerFingerprint,
        'peerAlias': peerAlias,
        'fileCount': fileCount,
        'totalBytes': totalBytes,
        'startedAt': startedAt.toUtc().toIso8601String(),
        'completedAt': completedAt.toUtc().toIso8601String(),
        'outcome': outcome.name,
        'errorMessage': errorMessage,
      };

  factory TransferRecord.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    final direction = json['direction'];
    final peerFingerprint = json['peerFingerprint'];
    final peerAlias = json['peerAlias'];
    final fileCount = json['fileCount'];
    final totalBytes = json['totalBytes'];
    final startedAt = json['startedAt'];
    final completedAt = json['completedAt'];
    final outcome = json['outcome'];
    final errorMessage = json['errorMessage'];
    if (id is! String || id.isEmpty ||
        direction is! String || peerFingerprint is! String || peerAlias is! String ||
        fileCount is! int || totalBytes is! int || startedAt is! String ||
        completedAt is! String || outcome is! String ||
        (errorMessage != null && errorMessage is! String)) {
      throw const FormatException('Invalid transfer record');
    }

    return TransferRecord(
      id: id,
      direction: TransferDirection.values.byName(direction),
      peerFingerprint: peerFingerprint,
      peerAlias: peerAlias,
      fileCount: fileCount,
      totalBytes: totalBytes,
      startedAt: DateTime.parse(startedAt).toUtc(),
      completedAt: DateTime.parse(completedAt).toUtc(),
      outcome: TransferOutcome.values.byName(outcome),
      errorMessage: errorMessage as String?,
    );
  }

  @override
  bool operator ==(Object other) => other is TransferRecord &&
      other.id == id &&
      other.direction == direction &&
      other.peerFingerprint == peerFingerprint &&
      other.peerAlias == peerAlias &&
      other.fileCount == fileCount &&
      other.totalBytes == totalBytes &&
      other.startedAt == startedAt &&
      other.completedAt == completedAt &&
      other.outcome == outcome &&
      other.errorMessage == errorMessage;

  @override
  int get hashCode => Object.hash(
        id,
        direction,
        peerFingerprint,
        peerAlias,
        fileCount,
        totalBytes,
        startedAt,
        completedAt,
        outcome,
        errorMessage,
      );
}
