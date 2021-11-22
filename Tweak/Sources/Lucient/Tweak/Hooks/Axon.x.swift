import Foundation
import LucientC
import Orion

struct AxonGroup: HookGroup {}

/*
 class AXNManagerHook: ClassHook<AXNManager> {
 	typealias Group = AxonGroup

 	func insertNotificationRequest(req: Any) {
 		orig.insertNotificationRequest(req: req)
 		SharedData.global.updateAxon(orig.target)
 	}

 	func removeNotificationRequest(req: Any) {
 		orig.removeNotificationRequest(req: req)
 		SharedData.global.updateAxon(orig.target)
 	}

 	func clearAll() {
 		orig.clearAll()
 		SharedData.global.updateAxon(orig.target)
 	}

 	func clearAll(_ bundleIdentifier: String) {
 		orig.clearAll(bundleIdentifier)
 		SharedData.global.updateAxon(orig.target)
 	}
 }
 */
