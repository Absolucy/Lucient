//
//  File.swift
//
//
//  Created by Lucy on 6/18/21.
//

import CoreFoundation
import CoreGraphics
import CoreText
import Foundation
import SwiftUI

final class FontRegistration {
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
			NSLog("[Lucient] failed to read \(url)")
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
