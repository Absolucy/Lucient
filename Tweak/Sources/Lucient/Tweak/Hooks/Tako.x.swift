import Foundation
import LucientC
import Orion

struct TakoGroup: HookGroup {}

class TKOControllerHook: ClassHook<NSObject> {
	typealias Group = TakoGroup
	static var targetName: String = "TKOController"

	func insertNotificationRequest(_ req: Any) {
		orig.insertNotificationRequest(req)
		SharedData.global.updateTako(Dynamic.convert(orig.target, to: TKOController.self))
	}

	func removeNotificationRequest(_ req: Any) {
		orig.removeNotificationRequest(req)
		SharedData.global.updateTako(Dynamic.convert(orig.target, to: TKOController.self))
	}

	func removeAllNotifications() {
		orig.removeAllNotifications()
		SharedData.global.updateTako(Dynamic.convert(orig.target, to: TKOController.self))
	}
}

class TKOGroupViewHook: ClassHook<UIView> {
	typealias Group = TakoGroup
	static var targetName: String = "TKOGroupView"

	func show() {
		orig.show()
		SharedData.global.updateTako(Dynamic("TKOController").as(interface: TKOController.self).sharedInstance())
	}

	func hide() {
		orig.hide()
		SharedData.global.updateTako(Dynamic("TKOController").as(interface: TKOController.self).sharedInstance())
	}

	func update() {
		orig.update()
		SharedData.global.updateTako(Dynamic("TKOController").as(interface: TKOController.self).sharedInstance())
	}
}

@objc protocol TKOController {
	var groupView: TKOGroupView? { get }
	var view: TKOView? { get }
	func sharedInstance() -> TKOController
	func insertNotificationRequest(_ req: Any?)
	func removeNotificationRequest(_ req: Any?)
	func removeAllNotifications()
	func hideAllNotifications()
}

@objc protocol TKOView {
	var cellsInfo: NSMutableArray { get }
}

@objc protocol TKOGroupView {
	var iconsView: NSMutableArray { get }
	var isVisible: Bool { get }
}
