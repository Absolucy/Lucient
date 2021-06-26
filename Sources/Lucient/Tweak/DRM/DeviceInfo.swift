import Foundation
import LucientC

internal final class DeviceInfo {
	static let instance = DeviceInfo()

	@inline(never)
	final func udid() -> String {
		LucientC.udid()
	}

	@inline(never)
	final func model() -> String {
		LucientC.model()
	}

	@inline(never)
	final func jailbreak() -> String {
		if FileManager.default.fileExists(atPath: "/taurine/jailbreakd") {
			return "Taurine"
		} else if FileManager.default.fileExists(atPath: "/usr/libexec/libhooker/pspawn_payload.dylib") {
			if FileManager.default.fileExists(atPath: "/.procursus_strapped") {
				return "odysseyra1n"
			} else {
				return "unknown libhooker jb"
			}
		} else if FileManager.default.fileExists(atPath: "/var/checkra1n.dmg") {
			return "checkra1n"
		} else if FileManager.default.fileExists(atPath: "/usr/lib/substitute-loader.dylib")
			|| FileManager.default.fileExists(atPath: "/usr/libexec/substrated")
		{
			return "unc0ver"
		}
		return "unknown"
	}

	@inline(never)
	final func firmware() -> String {
		let version = ProcessInfo.processInfo.operatingSystemVersion
		if version.patchVersion > 0 {
			return String(
				format: "%d.%d.%d",
				version.majorVersion,
				version.minorVersion,
				version.patchVersion
			)
		} else {
			return String(format: "%d.%d", version.majorVersion, version.minorVersion)
		}
	}

	@inline(never)
	final func userAgent() -> String {
		String(
			format: getStr(FORMATTING_USER_AGENT),
			getStr(INFO_TWEAK),
			getStr(INFO_VERSION),
			model(),
			jailbreak(),
			firmware()
		)
	}

	@inline(never)
	final func headers() -> [String: String] {
		[
			"User-Agent": userAgent(),
			"Tweak": getStr(INFO_TWEAK),
			"Version": getStr(INFO_VERSION),
			"Build": getStr(INFO_BUILD_ID),
			"Device": model(),
			"Firmware": firmware(),
			"Jailbreak": jailbreak(),
			"Unique-Id": udid(),
		]
	}
}
