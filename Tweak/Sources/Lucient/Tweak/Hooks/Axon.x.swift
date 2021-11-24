import Foundation
import LucientC
import Orion

struct AxonGroup: HookGroup {}

class AXNManagerHook: ClassHook<NSObject> {
	typealias Group = AxonGroup
	static var targetName: String = "AXNManager"

	func insertNotificationRequest(req: Any) {
		orig.insertNotificationRequest(req: req)
		SharedData.global.updateAxon(Dynamic.convert(orig.target, to: AXNManager.self))
	}

	func removeNotificationRequest(req: Any) {
		orig.removeNotificationRequest(req: req)
		SharedData.global.updateAxon(Dynamic.convert(orig.target, to: AXNManager.self))
	}

	func clearAll() {
		orig.clearAll()
		SharedData.global.updateAxon(Dynamic.convert(orig.target, to: AXNManager.self))
	}

	func clearAll(_ bundleIdentifier: String) {
		orig.clearAll(bundleIdentifier)
		SharedData.global.updateAxon(Dynamic.convert(orig.target, to: AXNManager.self))
	}
}

@objc protocol AXNManager {
	var view: AXNView? { get }
	func sharedInstance() -> Self
	func insertNotificationRequest(_ req: Any?)
	func removeNotificationRequest(_ req: Any?)
	func clearAll(_ bundleIdentifier: NSString)
	func clearAll()
}

@objc protocol AXNView {
	var list: NSMutableArray { get }
}
