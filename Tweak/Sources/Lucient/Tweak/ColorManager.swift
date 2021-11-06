//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


import Foundation
import LucientC
import SwiftUI

internal enum ColorMode: String, Codable {
	case custom
	case distinctive
	case primary
	case secondary
	case background

	internal init(old: Int) {
		switch old {
		case 0:
			self = .custom
		case 2:
			self = .primary
		case 3:
			self = .secondary
		case 4:
			self = .background
		default:
			self = .distinctive
		}
	}
}

internal final class ColorManager {
	static var instance = ColorManager()

	var wallpaperFd: Int32 = -1
	var wallpaperSource: DispatchSourceFileSystemObject?

	var primary = Color.white
	var secondary = Color.white
	var background = Color.white
	var distinctive = Color.white

	init() {
		updateWallpaper()
		setupWallpaperMonitor()
	}

	final func setupWallpaperMonitor() {
		wallpaperSource?.cancel()
		wallpaperSource = nil
		wallpaperFd = open(wallpaperPath(), O_EVTONLY)
		if wallpaperFd == -1 {
			return
		}
		let source = DispatchSource.makeFileSystemObjectSource(
			fileDescriptor: wallpaperFd,
			eventMask: .all,
			queue: DispatchQueue.main
		)
		source.setEventHandler {
			NSLog("[Lucient] wallpaper updated, recalculating colors")
			self.updateWallpaper()
		}
		source.setCancelHandler {
			NSLog("[Lucient] wallpaper monitor canceled")
			if self.wallpaperFd != -1 {
				close(self.wallpaperFd)
				self.wallpaperFd = -1
			}
		}
		source.resume()
		wallpaperSource = source
	}

	final func get(_ separated: Bool, mode: ColorMode, customMode: ColorMode, color: Color, customColor: Color) -> Color {
		switch separated ? customMode : mode {
		case .custom:
			return separated ? customColor : color
		case .primary:
			return primary
		case .secondary:
			return secondary
		case .background:
			return background
		case .distinctive:
			return distinctive
		}
	}

	final func updateWallpaper() {
		guard let wallpaper = lockScreenWallpaper() else { return }
		primary = Color(getColorFromImage(wallpaper, 1, 4, 1, 100))
		secondary = Color(getColorFromImage(wallpaper, 1, 9, 3, 90))
		background = Color(getColorFromImage(wallpaper, 0, 0, 0, 0))
		if isDarkImage(wallpaper) {
			distinctive = Color.white
		} else {
			distinctive = Color.black
		}
	}

	final func wallpaperPath() -> String {
		if UITraitCollection.current.userInterfaceStyle == .dark,
		   FileManager.default.fileExists(atPath: "/var/mobile/Library/SpringBoard/LockBackgrounddark.cpbitmap")
		{
			return "/var/mobile/Library/SpringBoard/LockBackgrounddark.cpbitmap"
		} else {
			return "/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"
		}
	}

	final func lockScreenWallpaper() -> UIImage? {
		var wallpaperData: Data
		do {
			wallpaperData =
				try Data(contentsOf: URL(fileURLWithPath: wallpaperPath()))
		} catch {
			NSLog("[Lucient] failed to get wallpaper: \(error.localizedDescription)")
			return nil
		}
		guard let imageArray = CPBitmapCreateImagesFromData(wallpaperData as CFData, nil, 1, nil)?
			.takeRetainedValue() as? [CGImage]
		else {
			NSLog("[Lucient] failed to parse wallpaper cpbitmap")
			return nil
		}
		return UIImage(cgImage: imageArray[0])
	}
}
