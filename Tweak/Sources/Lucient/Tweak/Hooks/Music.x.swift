import Foundation
import LucientC
import Orion

class MRUNowPlayingViewHook: ClassHook<MRUNowPlayingView> {
	func showSuggestionsView() -> Bool {
		let ret = orig.showSuggestionsView()
		if NSStringFromClass(type(of: target.superview?.superview ?? UIView())) == "CSMediaControlsView" {
			SharedData.global.musicSuggestionsVisible = ret
			SharedData.global.mruNowPlayingView = target
			SharedData.global.updateVisibility()
		}
		return ret
	}

	func setShowSuggestionsView(_ value: Bool) {
		orig.setShowSuggestionsView(value)
		if NSStringFromClass(type(of: target.superview?.superview ?? UIView())) == "CSMediaControlsView" {
			SharedData.global.musicSuggestionsVisible = value
			SharedData.global.mruNowPlayingView = target
			SharedData.global.updateVisibility()
		}
	}
}
