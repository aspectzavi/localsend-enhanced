# Interoperability Contract

## Compatibility promise

An enhanced build must continue to communicate with unmodified LocalSend clients using the existing discovery and transfer behavior. The standard protocol remains the default path.

## Preserved surfaces

- HTTP discovery and registration routes, including legacy v1 probing.
- LocalSend v2 registration, prepare-upload, upload, cancel, info and web-share routes.
- Existing JSON field names, status behavior, PIN flow, checksum behavior and file naming rules.
- Existing certificate identity and peer verification behavior.
- Multicast announcement behavior and IPv6 scope handling.
- QR-code address/token flows.

## Extension rules

1. Enhanced features use an independently versioned namespace and schemas.
2. Capability discovery is optional and must time out safely.
3. No custom handshake is required for a standard transfer.
4. Unsupported peers receive the existing behavior, not an error caused by an extension attempt.
5. New auto-accept or trust behavior is opt-in and must not weaken unknown-device protections.
6. Extension payloads are bounded, authenticated, validated, and scoped to the negotiated feature.

## Test matrix

| Scenario | Required result |
|---|---|
| Enhanced app to original client | Standard LocalSend discovery and transfer succeed |
| Original client to enhanced app | Standard registration and transfer succeed |
| Enhanced app to enhanced app | Standard transfer succeeds; enhanced features only after negotiation |
| Extension endpoint absent | Client falls back without changing standard transfer behavior |
| Extension version unsupported | Capability is ignored or downgraded safely |
| Certificate fingerprint mismatch | Peer action is rejected; no upload body is accepted |
| Unknown sender with auto-accept enabled | Existing explicit policy rules still decide; unknown sender is not silently trusted |
