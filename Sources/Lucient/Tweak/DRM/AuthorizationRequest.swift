import Foundation
import LucientC

internal struct AuthorizationRequest: Encodable {
	// device udid
	var u: String
	// device model
	var m: String
	// tweak name
	var t: String
	// tweak version
	var v: String
}

internal extension AuthorizationRequest {
	init() {
		u = udid()
		m = model()
		t = getStr(INFO_TWEAK)
		v = getStr(INFO_VERSION)
	}
}
