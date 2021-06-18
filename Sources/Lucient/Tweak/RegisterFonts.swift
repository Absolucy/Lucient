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

final class FontRegistration {
	static let register: Void = {
		guard let data =
			try? Data(
				contentsOf: URL(fileURLWithPath: "/Library/Lucy/LucientResources.bundle/Roboto.ttf")
			) as NSData as CFData
		else {
			NSLog("[Lucient] failed to read /Library/Lucy/LucientResources.bundle/Roboto.ttf")
			return
		}
		var error: Unmanaged<CFError>?
		guard let provider = CGDataProvider(data: data) else {
			NSLog("[Lucient] failed to get CGDataProvider for Roboto.ttf")
			return
		}
		guard let font = CGFont(provider) else {
			NSLog("[Lucient] failed to get CGFont for Roboto.ttf")
			return
		}
		if !CTFontManagerRegisterGraphicsFont(font, &error) {
			NSLog("[Lucient] failed to register Roboto")
		}
		if let error = error?.takeRetainedValue() {
			guard let errorDescription = CFErrorCopyDescription(error) else { return }
			NSLog("[Lucient] registering Roboto font errored: \(errorDescription)")
		}
	}()
}
