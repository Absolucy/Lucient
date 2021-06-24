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
	case distinctive = 1
	case primary = 2
	case secondary = 3
	case background = 4
}

internal final class ColorManager {
	static var instance = ColorManager()

	var wallpaperModifiedDate: Date?
	var primary = Color.white
	var secondary = Color.white
	var background = Color.white
	var distinctive = Color.white

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
			updateWallpaper()
			return primary
		case .secondary:
			updateWallpaper()
			return secondary
		case .background:
			updateWallpaper()
			return background
		case .distinctive:
			updateWallpaper()
			return distinctive
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
				let (r, g, b, _) = background.components
				let y = 0.2126 * pow(r, 2.2) + 0.7151 * pow(g, 2.2) + 0.0721 * pow(b, 2.2)
				distinctive = y <= 0.18 ? Color.white : Color.black
			}
			wallpaperModifiedDate = modified
		} catch {
			NSLog("[Lucient] failed to recalculate wallpaper colors: \(error)")
		}
	}
}
