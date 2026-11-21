# Feature Roadmap

## Phase 0 — audit and architecture (current)

- [x] Inspect repository structure, manifests, protocol core, app state, persistence, platform runners, CI and tests.
- [x] Establish the `feature/audit-stabilization` branch.
- [x] Record implementation status and interoperability boundary.
- [ ] Run baseline checks on a machine with the pinned Flutter and Rust toolchains.

## Phase 1 — stabilization foundations

- Add protocol fixture tests for v1 probing, v2 registration, upload, cancellation and TLS identity behavior.
- Add persistence repository interfaces and migration tests.
- Introduce device identity/trust records without changing auto-accept defaults.
- Add a transfer orchestration interface above the existing v2 client.

## Phase 2 — application shell and device management

- Add responsive navigation and design tokens while preserving existing transfer pages.
- Add device profiles, groups, last-seen observations and diagnostics.
- Add explicit trusted-device UI and policy review.

## Phase 3 — transfer orchestration and Smart Inbox

- Queue, prioritize, retry and schedule transfers without changing the standard wire protocol.
- Add durable transfer history and integrity outcomes.
- Add searchable received-file metadata and platform-aware file operations.

## Phase 4 — enhanced synchronization and backups

- Implement enhanced-peer capability negotiation.
- Add manifest/hash based one-way and two-way sync, conflict records, versions and offline queues.

## Phase 5 — rooms and clipboard

- Add local Drop Rooms with QR/invitation lifecycle and explicit participant permissions.
- Add opt-in, size-limited clipboard sharing with platform capability reporting.

## Phase 6 — automation and developer ecosystem

- Add authenticated, permission-scoped local API and CLI commands.
- Add event subscriptions, webhooks and a constrained plugin model.

## Phase 7 — optional AI and release hardening

- Add local-first optional classification/search assistance with explicit privacy controls.
- Benchmark large-file and multi-transfer paths; verify each supported platform and document limitations.
