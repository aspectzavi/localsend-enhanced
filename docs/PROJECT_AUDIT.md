# LocalSend Repository Audit

Date: 2026-11-21
Branch: `feature/audit-stabilization`
Baseline commit: `26cc8f99`

## Executive summary

This repository is a mature LocalSend implementation, not a prototype. It is a Flutter application backed by Rust networking and a Flutter-Rust-Bridge isolate package. The current tree already contains production paths for LocalSend protocol v2.2, legacy v1 probing, HTTPS/mTLS identity, multicast discovery, WebRTC signaling, browser web-share flows, CLI use, and platform packaging.

The requested ecosystem should therefore be built as additive application services and an independently versioned extension protocol. Replacing the transfer core or changing standard LocalSend routes would create unnecessary interoperability risk.

## Repository shape

| Area | Evidence | Assessment |
|---|---|---|
| Flutter app | `app/`, Refena providers, pages, native runners | FULLY IMPLEMENTED for current LocalSend UX |
| Dart isolate bridge | `packages/localsend_isolates/` | FULLY IMPLEMENTED for current networking integration |
| Rust protocol core | `packages/core/` | FULLY IMPLEMENTED for v2.2 HTTP, crypto, multicast and WebRTC feature set |
| CLI | `cli/` | PARTIALLY IMPLEMENTED as a standalone LocalSend client |
| Signaling server | `server/` | PARTIALLY IMPLEMENTED; WebRTC signaling only, not a general product backend |
| Persistence | SharedPreferences plus versioned migrations | PARTIALLY IMPLEMENTED; suitable for settings/favorites/history, not ecosystem-scale records |
| Platform integration | Android, iOS, macOS, Windows, Linux packaging/native code | PARTIALLY IMPLEMENTED per feature; current transfer functionality is platform-aware |
| Advanced ecosystem features | sync, rooms, clipboard sync, automation API, plugins, optional AI | NOT IMPLEMENTED in this clone |

## Existing strengths

- The Cargo and pub workspaces are explicit and dependency direction is documented in `AGENTS.md`.
- The Rust core streams transfer bodies and has bounded session handling, cancellation guards, checksum support, and dedicated integration tests.
- Discovery combines HTTP registration/probing with multicast and models IPv6 scope IDs for link-local addresses.
- TLS uses device certificates and client authentication for peer traffic; the web page flow is deliberately separate.
- The app keeps networking off the main isolate and uses Refena actions to communicate with child isolates.
- Existing tests cover server behavior, TLS pinning, discovery, multicast, cancellation resilience, path traversal, persistence providers, and UI slices.
- CI already encodes formatting, Dart analysis/tests, Rust clippy/tests/checks, packaging version consistency, and toolchain consistency.

## Architectural risks and gaps

1. `SharedPreferences` stores JSON lists for favorites and receive history. This is appropriate for small settings but will become fragile for transfer history, device activity, sync state, versions, and audit events.
2. A favorite device is not yet a full trusted-device identity/permission record. Auto-accept behavior must not be expanded by treating favorites as cryptographic trust.
3. The current Rust v2 session state intentionally allows one active upload session. Multiple simultaneous transfers need a separately designed scheduler or extension path; silently changing v2 semantics would be unsafe.
4. There is no negotiated extension capability model in the standard v2 DTOs. Enhanced peers need a new endpoint/namespace and explicit opt-in negotiation.
5. Cross-platform capabilities differ materially for background execution, clipboard access, storage providers, firewall configuration, and sandboxing. Feature status must be tracked per platform.
6. Full verification could not be executed in this environment because `fvm` and `cargo` are not installed or available on `PATH`. A direct Flutter SDK is present, but its Dart 3.9.2 toolchain is older than this repository's Dart 3.11.0 constraint. This is an environment limitation, not evidence of a code failure.

## Highest-priority improvements

1. Establish a compatibility regression suite and a documented extension boundary before adding new network behavior.
2. Introduce a versioned persistence abstraction for device records, trust decisions, transfer metadata, and migrations without replacing current settings storage prematurely.
3. Add a device/trust domain model that keeps display favorites separate from cryptographic authorization and auto-accept policy.
4. Add a transfer orchestration layer above the existing v2 client/server so queues, retries, priority, and history do not alter standard LocalSend wire behavior.
5. Add an enhanced-peer capability endpoint/namespace with conservative negotiation and no mandatory handshake for ordinary transfers.

## Recommended first milestone

The first implementation milestone is **compatibility and persistence foundations**: document and test the extension boundary, then add the domain interfaces needed for device trust and transfer metadata. Do not begin sync/rooms/AI before these foundations exist.
