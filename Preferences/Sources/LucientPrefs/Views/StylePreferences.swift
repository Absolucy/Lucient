//
//  SwiftUIView.swift
//
//
//  Created by Lucy on 6/24/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct StylePreferences: View {
	@Preference("fontStyle", identifier: identifier) private var fontStyle = FontStyle.ios
	@Preference("customFont",
	            identifier: identifier) private var customFontPath = "/Library/Lucy/LucientResources.bundle/Roboto.ttf"
	@Preference("colorMode", identifier: identifier) private var colorMode = ColorMode.distinctive
	@Preference("color", identifier: identifier) private var color = Color.primary
	@Binding var separatedColors: Bool
	@State private var showFontPicker = false

	func getFontLabel() -> String {
		if customFontPath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			return "Unset"
		}
		var isDir: ObjCBool = false
		if !FileManager.default.fileExists(atPath: customFontPath, isDirectory: &isDir) || isDir.boolValue {
			return "Invalid"
		}
		let url = URL(fileURLWithPath: customFontPath)
		guard let filename = url.pathComponents.last else { return "Unset" }
		if filename.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			return "Unset"
		}
		return filename
	}

	var body: some View {
		Section(header: Text("Style")) {
			Picker(selection: $fontStyle, label: EmptyView()) {
				Text("iOS").tag(FontStyle.ios)
				Text("Android 12").tag(FontStyle.android)
				Text("Custom").tag(FontStyle.custom)
			}.pickerStyle(SegmentedPickerStyle()).padding(.bottom, 4)
			if fontStyle == .custom {
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
							customFontPath = url.path
						}
					)
					Spacer()
					Text(getFontLabel())
						.font(.system(.callout, design: .monospaced))
				}.padding(.vertical, 4)
			}
			if separatedColors {
				Toggle("Separate Colors", isOn: $separatedColors)
					.padding(.top, 4)
			} else {
				Toggle("Separate Colors", isOn: $separatedColors)
					.padding(.vertical, 4)
				Picker(selection: $colorMode, label: Text("Color")) {
					Text("Custom").tag(ColorMode.custom)
					Text("Distinctive Color").tag(ColorMode.distinctive)
					Text("Background Primary").tag(ColorMode.primary)
					Text("Background Secondary").tag(ColorMode.secondary)
					Text("Background Color").tag(ColorMode.background)
				}
				if colorMode == .custom {
					ColorPicker("Custom Color", selection: $color)
				}
			}
		}
	}
}
