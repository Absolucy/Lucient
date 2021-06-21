//
//  SwiftUIView.swift
//
//
//  Created by Lucy on 6/21/21.
//

import SwiftUI
import UniformTypeIdentifiers

let identifier = "moe.absolucy.lucient"

struct RootPreferences: View {
	@Preference("enabled", identifier: identifier) private var enabled = true
	@Preference("appearance", identifier: identifier) private var appearance = 2
	@Preference("customFont",
	            identifier: identifier) private var customFontPath = "/Library/Lucy/LucientResources.bundle/Roboto.ttf"
	@Preference("maxTimeSize", identifier: identifier) private var maxTimeSize: Double = 160
	@Preference("minTimeSize", identifier: identifier) private var minTimeSize: Double = 72
	@Preference("timeOffset", identifier: identifier) private var timeOffset: Double = 15
	@Preference("showWeather", identifier: identifier) private var showWeather = true
	@Preference("dateFontSize", identifier: identifier) private var dateFontSize: Double = 24
	@Preference("dateOffset", identifier: identifier) private var dateOffset: Double = 2
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

	@ViewBuilder
	func HeaderSection() -> some View {
		Header(
			"Lucient",
			icon: Image(systemName: "lock.square.stack").resizable().padding(16).aspectRatio(contentMode: .fit),
			subtitle: "by Lucy"
		)
		Section(header: Text("Enable/Disable")) {
			Toggle("Enable", isOn: $enabled)
		}
	}

	@ViewBuilder
	func StyleSection() -> some View {
		Section(header: Text("Style")) {
			Picker(selection: $appearance, label: EmptyView()) {
				Text("iOS").tag(0)
				Text("Android 12").tag(1)
				Text("Custom").tag(2)
			}.pickerStyle(SegmentedPickerStyle())
			if appearance == 2 {
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
				}
			}
		}
	}

	@ViewBuilder
	func SizeOption(name: String, option: Binding<Double>, min: Double, max: Double,
	                default defaultOption: Double) -> some View
	{
		VStack(spacing: 0) {
			Text(name).padding(.vertical, 5)
			HStack {
				Spacer()
				Text(String(format: "%.0f", option.wrappedValue))
					.font(.system(.footnote, design: .rounded))
				Spacer()
			}.padding(.vertical, 5)
			HStack {
				Text(String(format: "%.0f", min))
					.font(.caption2)
				Slider(value: option, in: min ... max, step: 1) { _ in }
				Text(String(format: "%.0f", max))
					.font(.caption2)
			}
		}
		.onTapGesture(count: 2) {
			option.wrappedValue = defaultOption
		}
	}

	@ViewBuilder
	func ClockCustomizationSection() -> some View {
		Section(header: Text("Clock")) {
			SizeOption(name: "Large Clock Size", option: $maxTimeSize, min: 64, max: 256, default: 160)
				.padding(.bottom, 4)
			SizeOption(name: "Large Clock Offset", option: $timeOffset, min: 0, max: 128, default: 15)
				.padding(.vertical, 4)
			SizeOption(name: "Small Clock Size", option: $minTimeSize, min: 32, max: 96, default: 72)
				.padding(.top, 4)
		}
	}

	@ViewBuilder
	func DateCustomizationSection() -> some View {
		Section(header: Text("Date / Weather")) {
			Toggle("Show Weather", isOn: $showWeather)
				.padding(.bottom, 4)
			SizeOption(name: "Font Size", option: $dateFontSize, min: 16, max: 64, default: 24)
				.padding(.vertical, 4)
			SizeOption(name: "Offset", option: $dateOffset, min: 0, max: 128, default: 2)
				.padding(.top, 4)
		}
	}

	@ViewBuilder
	func Credit(name: String, role: String, username: String) -> some View {
		HStack {
			AsyncImage(
				url: URL(string: "https://unavatar.now.sh/twitter/\(username)")!,
				placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle()) },
				image: { Image(uiImage: $0).resizable() }
			)
			.aspectRatio(contentMode: .fit)
			.frame(width: 58, height: 58)
			.clipShape(Capsule())
			.padding([.vertical, .trailing])
			VStack(alignment: .leading, spacing: 5) {
				Text(name)
					.font(.system(.title3, design: .rounded))
				Text(role)
					.font(.system(.caption, design: .rounded))
			}
		}
		.onTapGesture {
			let appURL = URL(string: "twitter://user?screen_name=\(username)")!
			let webURL = URL(string: "https://twitter.com/\(username)")!
			let application = UIApplication.shared
			if application.canOpenURL(appURL as URL) {
				application.open(appURL as URL)
			} else {
				application.open(webURL as URL)
			}
		}
	}

	@ViewBuilder
	func CreditsSection() -> some View {
		Section(header: Text("Credits")) {
			Credit(name: "Lucy", role: "Developer", username: "Absolucyyy")
			Credit(name: "Alpha", role: "Logo Designer", username: "Kutarin_")
			Credit(name: "Emma", role: "Tester", username: "emiyl0")
		}
	}

	var body: some View {
		Form {
			HeaderSection()
			if enabled {
				StyleSection()
				ClockCustomizationSection()
				DateCustomizationSection()
				CreditsSection()
			}
		}
	}
}

struct RootPreferences_Previews: PreviewProvider {
	static var previews: some View {
		RootPreferences()
			.preferredColorScheme(.dark)
	}
}
