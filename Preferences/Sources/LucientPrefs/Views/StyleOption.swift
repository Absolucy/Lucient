//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI
import UniformTypeIdentifiers

struct StyleOption: View {
	@Binding var fontSettings: FontSettings
	@State private var showFontPicker = false

	func getFontLabel() -> String {
		let customFont = fontSettings.customFont
		if customFont.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			return "Unset"
		}
		var isDir: ObjCBool = false
		if !FileManager.default.fileExists(atPath: customFont, isDirectory: &isDir) || isDir.boolValue {
			return "Invalid"
		}
		let url = URL(fileURLWithPath: customFont)
		guard let filename = url.pathComponents.last else { return "Unset" }
		if filename.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			return "Unset"
		}
		return filename
	}

	var body: some View {
		Picker(selection: $fontSettings.style, label: EmptyView()) {
			Text("iOS").tag(FontStyle.ios)
			Text("Android 12").tag(FontStyle.android)
			Text("Custom").tag(FontStyle.custom)
		}.pickerStyle(SegmentedPickerStyle()).padding(.vertical, 4)
		if fontSettings.style == .custom {
			HStack {
				Button(action: { showFontPicker.toggle() }) {
					Image(systemName: "textformat")
						.padding([.trailing, .vertical])
				}.documentPicker(
					isPresented: $showFontPicker,
					contentTypes: [UTType(filenameExtension: "ttf")!],
					onCancel: {
						showFontPicker = false
					},
					onDocumentsPicked: { urls in
						showFontPicker = false
						guard let url = urls.first else { return }
						fontSettings.customFont = url.path
					}
				)
				Spacer()
				Text(getFontLabel())
					.font(.system(.callout, design: .monospaced))
			}.padding(.vertical, 4)
		}
		Picker(selection: $fontSettings.colorMode, label: Text("Color")) {
			Text("Custom").tag(ColorMode.custom)
			Text("Distinctive Color").tag(ColorMode.distinctive)
			Text("Background Primary").tag(ColorMode.primary)
			Text("Background Secondary").tag(ColorMode.secondary)
			Text("Background Color").tag(ColorMode.background)
		}.padding(.vertical, 4)
		if fontSettings.colorMode == .custom {
			ColorPicker("Custom Color", selection: $fontSettings.customColor)
				.padding(.vertical, 4)
		}
	}
}
