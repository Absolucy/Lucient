//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


import CoreFoundation
import CoreGraphics
import CoreText
import Foundation
import SwiftUI

internal enum FontStyle: String, Codable {
	case ios
	case android
	case custom

	init(old: Int) {
		switch old {
		case 0:
			self = .ios
		case 1:
			self = .android
		default:
			self = .custom
		}
	}
}

enum FontRegistration {
	static let register: Void = {
		_ = register(url: URL(fileURLWithPath: "/Library/Lucy/LucientResources.bundle/Roboto.ttf"))
	}()

	static var registered: [URL: String] = [:]

	static func font(size: Double, style: FontStyle, custom: String) -> Font {
		switch style {
		case .android:
			_ = register
			return Font.custom("Roboto-Regular", size: CGFloat(size))
		case .custom:
			if let fontName = register(url: URL(fileURLWithPath: custom)) {
				return Font.custom(fontName, size: CGFloat(size))
			}
		default:
			break
		}
		return Font.system(size: CGFloat(size), weight: .thin, design: .rounded)
	}

	static func register(url: URL) -> String? {
		if let fontName = registered[url] {
			return fontName
		}

		guard let data =
			try? Data(
				contentsOf: url
			) as NSData as CFData
		else {
			return nil
		}
		var error: Unmanaged<CFError>?
		guard let provider = CGDataProvider(data: data) else {
			NSLog("[Lucient] failed to get CGDataProvider for \(url)")
			return nil
		}
		guard let font = CGFont(provider) else {
			NSLog("[Lucient] failed to get CGFont for \(url)")
			return nil
		}
		guard let fontName = font.postScriptName as String? else { return nil }
		if !CTFontManagerRegisterGraphicsFont(font, &error) {
			NSLog("[Lucient] failed to register '\(fontName)'")
		}
		if let error = error?.takeRetainedValue() {
			guard let errorDescription = CFErrorCopyDescription(error) else { return nil }
			NSLog("[Lucient] registering '\(fontName)' font errored: \(errorDescription)")
			return nil
		} else {
			NSLog("[Lucient] registered '\(fontName)' from \(url)")
			registered[url] = fontName
			return fontName
		}
	}
}
