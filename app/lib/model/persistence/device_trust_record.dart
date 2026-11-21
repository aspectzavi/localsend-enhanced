/// Persisted identity and policy for a device observed on the local network.
///
/// This is intentionally separate from [FavoriteDevice]. A favorite controls
/// presentation and known connection details; it is not cryptographic trust
/// and must not grant automatic acceptance by itself.
class DeviceTrustRecord {
  final String fingerprint;
  final String alias;
  final DateTime firstSeen;
  final DateTime lastSeen;
  final bool trusted;
  final bool autoAccept;

  const DeviceTrustRecord({
    required this.fingerprint,
    required this.alias,
    required this.firstSeen,
    required this.lastSeen,
    required this.trusted,
    required this.autoAccept,
  }) : assert(fingerprint != '', 'A device fingerprint is required');

  bool get canAutoAccept => trusted && autoAccept;

  DeviceTrustRecord copyWith({
    String? alias,
    DateTime? lastSeen,
    bool? trusted,
    bool? autoAccept,
  }) {
    return DeviceTrustRecord(
      fingerprint: fingerprint,
      alias: alias ?? this.alias,
      firstSeen: firstSeen,
      lastSeen: lastSeen ?? this.lastSeen,
      trusted: trusted ?? this.trusted,
      autoAccept: autoAccept ?? this.autoAccept,
    );
  }

  Map<String, Object?> toJson() => {
        'fingerprint': fingerprint,
        'alias': alias,
        'firstSeen': firstSeen.toUtc().toIso8601String(),
        'lastSeen': lastSeen.toUtc().toIso8601String(),
        'trusted': trusted,
        'autoAccept': autoAccept,
      };

  factory DeviceTrustRecord.fromJson(Map<String, Object?> json) {
    final fingerprint = json['fingerprint'];
    final alias = json['alias'];
    final firstSeen = json['firstSeen'];
    final lastSeen = json['lastSeen'];
    final trusted = json['trusted'];
    final autoAccept = json['autoAccept'];
    if (fingerprint is! String || fingerprint.isEmpty ||
        alias is! String || firstSeen is! String || lastSeen is! String ||
        trusted is! bool || autoAccept is! bool) {
      throw const FormatException('Invalid device trust record');
    }

    return DeviceTrustRecord(
      fingerprint: fingerprint,
      alias: alias,
      firstSeen: DateTime.parse(firstSeen).toUtc(),
      lastSeen: DateTime.parse(lastSeen).toUtc(),
      trusted: trusted,
      autoAccept: autoAccept,
    );
  }

  @override
  bool operator ==(Object other) => other is DeviceTrustRecord &&
      other.fingerprint == fingerprint &&
      other.alias == alias &&
      other.firstSeen == firstSeen &&
      other.lastSeen == lastSeen &&
      other.trusted == trusted &&
      other.autoAccept == autoAccept;

  @override
  int get hashCode => Object.hash(fingerprint, alias, firstSeen, lastSeen, trusted, autoAccept);
}
