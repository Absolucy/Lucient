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

	var wallpaperFd: Int32
	var wallpaperSource: DispatchSourceFileSystemObject

	var primary = Color.white
	var secondary = Color.white
	var background = Color.white
	var distinctive = Color.white

	init() {
		wallpaperFd = open("/var/mobile/Library/SpringBoard/LockBackground.cpbitmap", O_EVTONLY)
		wallpaperSource = DispatchSource.makeFileSystemObjectSource(
			fileDescriptor: wallpaperFd,
			eventMask: .all,
			queue: DispatchQueue.main
		)
		wallpaperSource.setEventHandler { [weak self] in
			NSLog("[Lucient] wallpaper updated, recalculating colors")
			self?.updateWallpaper()
		}
		wallpaperSource.setCancelHandler { [weak self] in
			NSLog("[Lucient] wallpaper monitor thingy canceled")
			if let fd = self?.wallpaperFd, fd != -1 {
				close(fd)
				self?.wallpaperFd = -1
			}
		}
		wallpaperSource.resume()
		updateWallpaper()
	}

	deinit {
		wallpaperSource.cancel()
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

	final func lockScreenWallpaper() -> UIImage? {
		var wallpaperData: Data
		if UITraitCollection.current.userInterfaceStyle == .dark,
		   FileManager.default.fileExists(atPath: "/var/mobile/Library/SpringBoard/LockBackgrounddark.cpbitmap")
		{
			do {
				wallpaperData =
					try Data(contentsOf: URL(fileURLWithPath: "/var/mobile/Library/SpringBoard/LockBackgrounddark.cpbitmap"))
			} catch {
				NSLog("[Lucient] failed to get LockBackgrounddark.cpbitmap: \(error.localizedDescription)")
				return nil
			}
		} else {
			do {
				wallpaperData =
					try Data(contentsOf: URL(fileURLWithPath: "/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"))
			} catch {
				NSLog("[Lucient] failed to get LockBackground.cpbitmap: \(error.localizedDescription)")
				return nil
			}
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
