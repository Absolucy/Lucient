import Foundation
import LucientC
import Orion

struct LastLookGroup: HookGroup {}

class LastLookManagerHook: ClassHook<NSObject> {
	typealias Group = LastLookGroup
	static var targetName: String = "LastLookManager"

	func setIsActive(_ isActive: Bool) {
		SharedData.global.updateAod(isActive)
		orig.setIsActive(isActive)
	}
}

@objc protocol LastLookManager {
	func sharedInstance() -> Self
	func isActive() -> Bool
}
