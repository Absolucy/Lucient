//
//  ColorManager.swift
//
//
//  Created by Lucy on 6/22/21.
//

import Foundation
import LucientC
import SwiftUI

internal enum ColorMode: Int {
	case custom = 0
	case primary = 1
	case secondary = 2
	case background = 3
}

internal final class ColorManager {
	static var instance = ColorManager()

	var wallpaperModifiedDate: Date?
	var primary = Color.white
	var secondary = Color.white
	var background = Color.white

	init() {
		updateWallpaper()
		NotificationCenter.default.addObserver(
			forName: NSNotification.Name("moe.absolucy.lucient.wallpaper"),
			object: self,
			queue: OperationQueue.main
		) { _ in
			self.updateWallpaper()
		}
	}

	final func get(_ separated: Bool, mode: ColorMode, customMode: ColorMode, color: Color, customColor: Color) -> Color {
		switch separated ? customMode : mode {
		case .custom:
			return separated ? customColor : color
		case .primary:
			ColorManager.instance.updateWallpaper()
			return ColorManager.instance.primary
		case .secondary:
			ColorManager.instance.updateWallpaper()
			return ColorManager.instance.secondary
		case .background:
			ColorManager.instance.updateWallpaper()
			return ColorManager.instance.background
		}
	}

	final func updateWallpaper() {
		let url = URL(fileURLWithPath: "/var/mobile/Library/SpringBoard/LockBackground.cpbitmap")
		do {
			let values = try url.resourceValues(forKeys: [.contentModificationDateKey])
			guard let modified = values.contentModificationDate else { return }
			if wallpaperModifiedDate.map({ modified > $0 }) ?? true {
				NSLog("[Lucient] wallpaper has changed, recalculating colors")
				guard let wallpaper = lockScreenWallpaper() else { return }
				primary = Color(getColorFromImage(wallpaper, 1, 4, 1, 100))
				secondary = Color(getColorFromImage(wallpaper, 1, 9, 3, 90))
				background = Color(getColorFromImage(wallpaper, 0, 0, 0, 0))
			}
			wallpaperModifiedDate = modified
		} catch {
			NSLog("[Lucient] failed to recalculate wallpaper colors: \(error)")
		}
	}
}
