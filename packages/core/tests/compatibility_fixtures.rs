//! Wire fixtures representing an unmodified LocalSend v2 client.
//!
//! These tests intentionally exercise only the standard DTOs. Enhanced
//! capabilities must remain outside this payload and outside the standard
//! transfer handshake.

use localsend::http::dto_v2::RegisterDtoV2;
use localsend::model::discovery::{DeviceType, ProtocolType};

#[test]
fn original_v2_register_fixture_is_accepted() {
    let fixture = r#"{
        "alias": "Original LocalSend",
        "version": "2.2",
        "deviceModel": "Desktop",
        "deviceType": "desktop",
        "fingerprint": "0123456789ABCDEF",
        "port": 53317,
        "protocol": "https",
        "download": false
    }"#;

    let register: RegisterDtoV2 = serde_json::from_str(fixture).expect("standard v2 fixture must decode");
    assert_eq!(register.alias, "Original LocalSend");
    assert_eq!(register.version, "2.2");
    assert_eq!(register.device_model.as_deref(), Some("Desktop"));
    assert_eq!(register.device_type, Some(DeviceType::Desktop));
    assert_eq!(register.fingerprint, "0123456789ABCDEF");
    assert_eq!(register.port, 53317);
    assert_eq!(register.protocol, ProtocolType::Https);
    assert!(!register.download);
}
