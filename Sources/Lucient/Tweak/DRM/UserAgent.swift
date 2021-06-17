import Foundation
import LucientC

private func jailbreak() -> String {
	let paths = getList(JAILBREAK_INFO_PATHS)
	let jailbreaks = getList(JAILBREAK_INFO_NAMES)
	if FileManager.default.fileExists(atPath: String(paths[0])) {
		return String(jailbreaks[0])
	} else if FileManager.default.fileExists(atPath: String(paths[1])),
	          FileManager.default.fileExists(atPath: String(paths[2]))
	{
		return String(jailbreaks[1])
	} else if FileManager.default.fileExists(atPath: String(paths[1])) {
		return String(jailbreaks[2])
	} else if FileManager.default.fileExists(atPath: String(paths[3])) {
		return String(jailbreaks[3])
	} else if FileManager.default.fileExists(atPath: String(paths[4])) {
		return String(jailbreaks[4])
	}
	return String(jailbreaks[5])
}

private func iosVersion() -> String {
	let version = ProcessInfo.processInfo.operatingSystemVersion
	if version.patchVersion > 0 {
		return String(
			format: getStr(FORMATTING_IOS_X_X_X),
			version.majorVersion,
			version.minorVersion,
			version.patchVersion
		)
	} else {
		return String(format: getStr(FORMATTING_IOS_X_X), version.majorVersion, version.minorVersion)
	}
}

internal func userAgent() -> String {
	String(
		format: getStr(FORMATTING_USER_AGENT),
		getStr(TWEAK),
		getStr(VERSION),
		model(),
		jailbreak(),
		iosVersion()
	)
}
