import Foundation
import LucientC
import Orion

class Lucient: Tweak {
	required init() {
		if objc_getClass("TKOController") != nil {
			TakoGroup().activate()
		}
		if objc_getClass("AXNManager") != nil {
			AxonGroup().activate()
		}
		if objc_getClass("LastLookManager") != nil {
			TakoGroup().activate()
		}
	}
}
