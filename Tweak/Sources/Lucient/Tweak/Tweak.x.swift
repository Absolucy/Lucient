import Foundation
import LucientC
import Orion

class Lucient: Tweak {
	required init() {
		if objc_getClass("TKOController") != nil {
			NSLog("[Lucient] TKOController found, activating Tako compat")
			TakoGroup().activate()
		}
		if objc_getClass("AXNManager") != nil {
			NSLog("[Lucient] AXNManager found, activating Axon compat")
			AxonGroup().activate()
		}
		if objc_getClass("LastLookManager") != nil {
			NSLog("[Lucient] LastLookManager found, activating LastLook compat")
			TakoGroup().activate()
		}
	}
}
