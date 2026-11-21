# Architecture Assessment and Target Direction

## Current runtime

```text
Flutter UI
  -> Refena providers/controllers
  -> localsend_isolates parent actions
  -> child isolates
  -> flutter_rust_bridge
  -> Rust core (HTTP v2, discovery, multicast, crypto, WebRTC)
  -> local network peers
```

The app owns presentation, settings, persistence orchestration, save-target decisions, and transfer event handling. Rust owns protocol parsing, TLS, streaming I/O, discovery transport, and session safety. This boundary is sound and should be preserved.

## Target modules

Add these modules above the current transport without coupling them to Flutter widgets:

- `domain/devices`: device identity, display profile, last-seen observations, groups, trust and policy.
- `domain/transfers`: transfer intent, queue item, retry policy, progress, history and integrity result.
- `domain/sync`: folder manifests, content hashes, conflict decisions and version records.
- `domain/rooms`: local room lifecycle, invitations, participants and permissions.
- `domain/automation`: scoped rules and event subscriptions.
- `storage`: versioned repository interfaces with platform-specific secure secret storage.
- `extensions`: capability negotiation and enhanced-peer protocol clients/servers.

Each service should depend on interfaces, not directly on widgets or shared preference keys. The current v2 client/server remains the compatibility transport.

## Extension boundary

Standard LocalSend endpoints and DTOs remain unchanged. Enhanced functionality should use a separately versioned namespace and be attempted only after capability discovery. A peer that does not answer the extension endpoint must continue through the existing v2 path.

The extension layer must never make a normal transfer depend on a custom handshake, cloud service, or AI service.

## Persistence direction

Keep current settings migration intact. Introduce a separate repository for growing collections first, with explicit schema versioning and atomic writes. Migrate only the collections that need querying or concurrency; do not perform a broad storage rewrite as part of the first feature.

## Security direction

Separate these concepts:

- identity: certificate fingerprint and observed device information;
- trust: an explicit user decision tied to an identity;
- policy: whether a trusted identity may auto-accept a specific operation;
- authorization: a session-level check performed by the receiving service.

Favorites are UI convenience data and must not automatically become cryptographic trust.
