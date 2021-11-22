import Foundation
import LucientC
import Orion

struct TakoGroup: HookGroup {}

/*
 class TKOControllerHook: ClassHook<TKOController> {
 	typealias Group = TakoGroup

 	func insertNotificationRequest(req: Any) {
 		orig.insertNotificationRequest(req: req)
 		SharedData.global.updateTako(orig.target)
 	}

 	func removeNotificationRequest(req: Any) {
 		orig.removeNotificationRequest(req: req)
 		SharedData.global.updateTako(orig.target)
 	}

 	func removeAllNotifications() {
 		orig.removeAllNotifications()
 		SharedData.global.updateTako(orig.target)
 	}
 }

 class TKOGroupViewHook: ClassHook<TKOGroupView> {
 	typealias Group = TakoGroup

 	func show() {
 		orig.show()
 		//SharedData.global.updateTako(Dynamic("TKOController").as(type: TKOGroupWrapper.self).sharedInstance())
 	}

 	func hide() {
 		orig.hide()
 		//SharedData.global.updateTako(Dynamic("TKOController").as(type: TKOGroupWrapper.self).sharedInstance())
 	}

 	func update() {
 		orig.update()
 		//SharedData.global.updateTako(Dynamic("TKOController").as(type: TKOGroupWrapper.self).sharedInstance())
 	}
 }

 @objc protocol TKOGroupWrapper {
 	static func sharedInstance() -> TKOController
 }*/
