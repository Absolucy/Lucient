import Foundation
import LucientC
import Orion
import SwiftUI

class UIViewControllerHook: ClassHook<UIViewController> {
	func _canShowWhileLocked() -> Bool {
		true
	}
}

class CSCombinedListViewControllerHook: ClassHook<UIViewController> {
	static var targetName: String = "CSCombinedListViewController"

	func _listViewDefaultContentInsets() -> UIEdgeInsets {
		var ret = orig._listViewDefaultContentInsets()
		if isStupidTinyPhone() {
			ret.top = UIScreen.main.bounds.size.height / 2
		} else {
			ret.top = UIScreen.main.bounds.size.height / 3
		}
		return ret
	}
}

class CSQuickActionsButtonHook: ClassHook<UIView> {
	static var targetName: String = "CSQuickActionsButton"

	func didMoveToWindow() {
		target.isHidden = UserDefaults.lucientSettings.stockSettings.hideQuickActions
		orig.didMoveToWindow()
	}
}

class CSTeachableMomentsContainerViewHook: ClassHook<UIView> {
	static var targetName: String = "CSTeachableMomentsContainerView"

	func didMoveToWindow() {
		target.removeFromSuperview()
		orig.didMoveToWindow()
	}
}

class NCNotificationListSectionRevealHintViewHook: ClassHook<UIView> {
	static var targetName: String = "NCNotificationListSectionRevealHintView"

	func initWithFrame(_: CGRect) -> Target? {
		nil
	}
}

class NCNotificationMasterListHook: ClassHook<NCNotificationMasterList> {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		orig.scrollViewDidScroll(scrollView)
		SharedData.global.offset = scrollView.contentOffset.y + scrollView.contentInset.top
	}
}

class NCNotificationStructuredListViewControllerHook: ClassHook<NCNotificationStructuredListViewController> {
	func hasVisibleContent() -> Bool {
		let ret = orig.hasVisibleContent()
		SharedData.global.notifsVisible = ret
		SharedData.global.updateVisibility()
		return ret
	}
}

class SBBacklightControllerHook: ClassHook<SBBacklightController> {
	func turnOnScreenFullyWithBacklightSource(_ arg1: Int64) {
		SharedData.global.updateScreen(true)
		orig.turnOnScreenFullyWithBacklightSource(arg1)
	}
}

class SBFLockScreenDateSubtitleDateViewHook: ClassHook<UIView> {
	static var targetName: String = "SBFLockScreenDateSubtitleDateView"

	func didMoveToWindow() {
		if let lunarLabel = target.value(forKey: "_alternateDateLabel") as? UIView {
			lunarLabel.removeFromSuperview()
		}
		orig.didMoveToWindow()
	}
}

class SBFLockScreenDateSubtitleViewHook: ClassHook<UIView> {
	static var targetName: String = "SBFLockScreenDateSubtitleView"

	func didMoveToWindow() {
		if let lunarLabel = target.value(forKey: "_label") as? UIView {
			lunarLabel.removeFromSuperview()
		}
		orig.didMoveToWindow()
	}
}

class SBFLockScreenDateViewHook: ClassHook<UIView> {
	static var targetName: String = "SBFLockScreenDateView"

	func didMoveToWindow() {
		target.removeFromSuperview()
		orig.didMoveToWindow()
	}
}

class SBLockScreenManagerHook: ClassHook<SBLockScreenManager> {
	func lockUIFromSource(_ arg1: Int, withOptions options: Any?) {
		SharedData.global.updateScreen(false)
		orig.lockUIFromSource(arg1, withOptions: options)
	}
}

class SBMediaControllerHook: ClassHook<SBMediaController> {
	func setNowPlayingInfo(_ arg: Any?) {
		orig.setNowPlayingInfo(arg)
		MRMediaRemoteGetNowPlayingInfo(.main) { info in
			SharedData.global.musicVisible = info != nil
			SharedData.global.updateVisibility()
		}
	}
}

class SBUICallToActionLabelHook: ClassHook<UIView> {
	static var targetName: String = "SBUICallToActionLabel"

	func initWithFrame(_: CGRect) -> Target? {
		nil
	}
}

class SBUIProudLockIconViewHook: ClassHook<UIView> {
	static var targetName: String = "SBUIProudLockIconView"

	func didMoveToWindow() {
		target.superview?.isHidden = UserDefaults.lucientSettings.stockSettings.hideLock
		orig.didMoveToWindow()
	}
}

class CSCoverSheetViewControllerHook: ClassHook<UIViewController> {
	static var targetName: String = "CSCoverSheetViewController"
	static var lucientView = LockScreen()
	static var batteryView = BatteryView()

	func viewWillAppear(_: Bool) {
		SharedData.global.updateScreen(true)

		let lucientHost = UIHostingController(rootView: CSCoverSheetViewControllerHook.lucientView)
		lucientHost.view.backgroundColor = .clear
		lucientHost.view.isUserInteractionEnabled = false
		lucientHost.view.translatesAutoresizingMaskIntoConstraints = false
		lucientHost.view.frame = target.view.frame
		// Add subview
		target.addChild(lucientHost)
		target.view.addSubview(lucientHost.view)
		// Constrain it
		let half = (UIScreen.main.bounds.size.height / 3) * 2
		NSLayoutConstraint.activate([
			lucientHost.view.leftAnchor.constraint(equalTo: target.view.leftAnchor),
			lucientHost.view.topAnchor.constraint(equalTo: target.view.topAnchor),
			lucientHost.view.rightAnchor.constraint(equalTo: target.view.rightAnchor),
			lucientHost.view.heightAnchor.constraint(equalToConstant: half),
		])

		// Set up battery
		let batteryHost = UIHostingController(rootView: CSCoverSheetViewControllerHook.batteryView)
		batteryHost.view.backgroundColor = .clear
		batteryHost.view.isUserInteractionEnabled = false
		batteryHost.view.translatesAutoresizingMaskIntoConstraints = false
		batteryHost.view.frame = target.view.frame
		// Add subview
		target.addChild(batteryHost)
		target.view.addSubview(batteryHost.view)
		// Constrain it
		NSLayoutConstraint.activate([
			batteryHost.view.bottomAnchor.constraint(equalTo: target.view.bottomAnchor),
			batteryHost.view.centerXAnchor.constraint(equalTo: target.view.centerXAnchor),
		])
	}
}
