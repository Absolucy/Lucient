//
//  SwiftUIView.swift
//
//
//  Created by Lucy on 6/21/21.
//

import LucientPrefsC
import SwiftUI
import UniformTypeIdentifiers

let identifier = "moe.absolucy.lucient"

enum Credit {
	case twitter(String)
	case github(String)
}

struct RootPreferences: View {
	@Preference("enabled", identifier: identifier) private var enabled = true
	@Preference("fontStyle", identifier: identifier) private var fontStyle = FontStyle.ios
	@Preference("customFont",
	            identifier: identifier) private var customFontPath = "/Library/Lucy/LucientResources.bundle/Roboto.ttf"
	@Preference("colorMode", identifier: identifier) private var colorMode = ColorMode.secondary
	@Preference("color", identifier: identifier) private var color = Color.primary
	@Preference("separatedColors", identifier: identifier) private var separatedColors = false

	// Time
	@Preference("maxTimeSize", identifier: identifier) private var maxTimeSize: Double = 160
	@Preference("minTimeSize", identifier: identifier) private var minTimeSize: Double = 72
	@Preference("timeOffset", identifier: identifier) private var timeOffset: Double = 15
	@Preference("timeOnTheRight", identifier: identifier) private var timeOnTheRight = false
	@Preference("timeColorMode", identifier: identifier) private var timeColorMode = ColorMode.secondary
	@Preference("timeColor", identifier: identifier) private var timeColor = Color.primary
	@Preference("time24hr", identifier: identifier) var time24Hour = false

	// Date/Weather
	@Preference("showWeather", identifier: identifier) private var showWeather = true
	@Preference("dateFontSize", identifier: identifier) private var dateFontSize: Double = 24
	@Preference("dateOffset", identifier: identifier) private var dateOffset: Double = 0
	@Preference("dateColorMode", identifier: identifier) private var dateColorMode = ColorMode.secondary
	@Preference("dateColor", identifier: identifier) private var dateColor = Color.primary
	@State private var showFontPicker = false
	@State private var showingRespringAlert = false

	private let logo: Image? = {
		if let logo = UIImage(contentsOfFile: "/Library/Lucy/LucientResources.bundle/logo.png") {
			return Image(uiImage: logo)
		} else {
			return nil
		}
	}()

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
		if let logo = logo {
			Header(
				"Lucient",
				icon: logo.resizable().padding(16).aspectRatio(contentMode: .fit),
				subtitle: "by Lucy"
			)
		} else {
			Header(
				"Lucient",
				icon: Image(systemName: "lock.square.stack").resizable().padding(16).aspectRatio(contentMode: .fit),
				subtitle: "by Lucy"
			)
		}
		Section(header: Text("Enable/Disable")) {
			Toggle("Enable", isOn: $enabled)
				.onTapGesture {
					showingRespringAlert = true
				}
				.alert(isPresented: $showingRespringAlert) {
					Alert(
						title: Text("Lucient"),
						message: Text("In order to enable or disable Lucient, you need to respring.\nWould you like to do so now?"),
						primaryButton: .destructive(Text("Respring")) {
							let task = NSTask()
							task.setLaunchPath("/usr/bin/sbreload")
							task.launch()
							DispatchQueue.main.asyncAfter(deadline: .now() + 5, qos: .userInteractive) {
								let task = NSTask()
								task.setLaunchPath("/usr/bin/killall")
								task.setArguments(["-9", "SpringBoard"])
								task.launch()
							}
						},
						secondaryButton: .cancel(Text("Later"))
					)
				}
		}
	}

	@ViewBuilder
	func StyleSection() -> some View {
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
		.onLongPressGesture {
			option.wrappedValue = defaultOption
		}
	}

	@ViewBuilder
	func ClockCustomizationSection() -> some View {
		Section(header: Text("Clock")) {
			Toggle(time24Hour ? "24-hour time" : "12-hour time", isOn: $time24Hour)
			VStack(spacing: 0) {
				Text("Small Clock Position").padding(.vertical, 5)
				Picker(selection: $timeOnTheRight, label: EmptyView()) {
					Text("Left").tag(false)
					Text("Right").tag(true)
				}.pickerStyle(SegmentedPickerStyle()).padding(.bottom, 4)
			}
			if separatedColors {
				Picker(selection: $timeColorMode, label: Text("Color")) {
					Text("Custom").tag(ColorMode.custom)
					Text("Background Primary").tag(ColorMode.primary)
					Text("Background Secondary").tag(ColorMode.secondary)
					Text("Background Color").tag(ColorMode.background)
				}.padding(.vertical, 4)
				if timeColorMode == .custom {
					ColorPicker("Custom Color", selection: $timeColor).padding(.vertical, 4)
				}
			}
			SizeOption(name: "Large Clock Size", option: $maxTimeSize, min: 64, max: 256, default: 160)
				.padding(.vertical, 4)
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
			if separatedColors {
				Picker(selection: $dateColorMode, label: Text("Color")) {
					Text("Custom").tag(ColorMode.custom)
					Text("Background Primary").tag(ColorMode.primary)
					Text("Background Secondary").tag(ColorMode.secondary)
					Text("Background Color").tag(ColorMode.background)
				}.padding(.vertical, 4)
				if dateColorMode == .custom {
					ColorPicker("Custom Color", selection: $dateColor).padding(.vertical, 4)
				}
			}
			SizeOption(name: "Font Size", option: $dateFontSize, min: 16, max: 64, default: 24)
				.padding(.vertical, 4)
			SizeOption(name: "Offset", option: $dateOffset, min: 0, max: 128, default: 2)
				.padding(.top, 4)
		}
	}

	@ViewBuilder
	func Credit(name: String, role: String, username: Credit) -> some View {
		let pfpUrl: URL = {
			switch username {
			case let .twitter(username):
				return URL(string: "https://unavatar.now.sh/twitter/\(username)")!
			case let .github(username):
				return URL(string: "https://github.com/\(username).png")!
			}
		}()
		Button(action: {
			switch username {
			case let .twitter(username):
				let appURL = URL(string: "twitter://user?screen_name=\(username)")!
				let webURL = URL(string: "https://twitter.com/\(username)")!
				let application = UIApplication.shared
				if application.canOpenURL(appURL as URL) {
					application.open(appURL as URL)
				} else {
					application.open(webURL as URL)
				}
			case let .github(username):
				let url = URL(string: "https://github.com/\(username)")!
				UIApplication.shared.open(url)
			}
		}, label: {
			HStack {
				AsyncImage(
					url: pfpUrl,
					placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle()) },
					image: { Image(uiImage: $0).resizable() }
				)
				.aspectRatio(contentMode: .fit)
				.frame(width: 58, height: 58)
				.clipShape(Capsule())
				.padding(.trailing)
				.padding(.vertical, 5)
				VStack(alignment: .leading, spacing: 5) {
					Text(name)
						.font(.system(.title3, design: .rounded))
					Text(role)
						.font(.system(.caption, design: .rounded))
				}
			}
		})
	}

	@ViewBuilder
	func TweakAdvertisement(name: String, description: String, package: String, image: Image) -> some View {
		Button(action: {
			openPackage(name: name, package: package)
		}) {
			HStack {
				image
					.resizable()
					.frame(width: 48, height: 48)
					.clipShape(Capsule())
					.padding([.vertical, .trailing], 5)
				VStack(alignment: .leading, spacing: 5) {
					Text("Buy \(name)")
						.font(.system(.body, design: .rounded))
					Text(description)
						.font(.system(.caption, design: .rounded))
				}
			}
		}
	}

	@ViewBuilder
	func AboutMeSection() -> some View {
		Section(header: Text("About Me")) {
			Credit(name: "Lucy", role: "Developer", username: .twitter("Absolucyyy"))
			Button(action: {
				if let url = URL(string: "mailto:support@absolucy.moe") {
					UIApplication.shared.open(url)
				}
			}) {
				HStack {
					Image(systemName: "envelope.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 29, height: 29)
						.padding(.vertical, 5)
						.padding(.horizontal, 11)
					VStack(alignment: .leading, spacing: 5) {
						Text("Support Email")
							.font(.system(.body, design: .rounded))
						Text("support@absolucy.moe")
							.font(.system(.caption, design: .rounded))
					}
				}
			}
			TweakAdvertisement(
				name: "Xenon",
				description: "Easily share files between iOS and a PC over your network!",
				package: "me.aspenuwu.xenon",
				image: UIImage(contentsOfFile: "/Library/Lucy/LucientResources.bundle/xenon.png")
					.map(Image.init) ?? Image(systemName: "externaldrive.fill.badge.wifi")
			)
			TweakAdvertisement(
				name: "Zinnia",
				description: "Who doesn't love neon? Why not put it on your lockscreen?",
				package: "me.aspenuwu.zinnia",
				image: UIImage(contentsOfFile: "/Library/Lucy/LucientResources.bundle/zinnia.png")
					.map(Image.init) ?? Image(systemName: "lightbulb.fill")
			)
		}
	}

	@ViewBuilder
	func CreditsSection() -> some View {
		Section(header: Text("Credits")) {
			Credit(name: "Alpha", role: "Logo Designer", username: .twitter("Kutarin_"))
			Credit(name: "Emma", role: "Tester", username: .twitter("emiyl0"))
			Credit(name: "Emy", role: "Tester", username: .github("Emy"))
			Credit(name: "Litten", role: "libkitten developer", username: .twitter("schneelittchen"))
		}
	}

	var body: some View {
		VStack {
			Form {
				HeaderSection()
				if enabled {
					StyleSection()
					ClockCustomizationSection()
					DateCustomizationSection()
					AboutMeSection()
					CreditsSection()
				}
			}
			Text("Some options can be reset to default by long-pressing!")
				.font(.system(.caption2, design: .rounded))
				.fontWeight(.light)
				.padding()
		}
	}
}

private func openPackage(name: String, package: String) {
	if let sileoUrl = URL(string: "sileo://package/\(package)") {
		if UIApplication.shared.canOpenURL(sileoUrl) {
			UIApplication.shared.open(sileoUrl)
			return
		}
	}
	if let zebraUrl = URL(string: "zbra://packages/\(package)?source=https://repo.chariz.com") {
		if UIApplication.shared.canOpenURL(zebraUrl) {
			UIApplication.shared.open(zebraUrl)
			return
		}
	}
	if let installerUrl =
		URL(string: "installer://show/shared=Installer&name=\(package)&bundleid=\(package)&repo=https://repo.chariz.com")
	{
		if UIApplication.shared.canOpenURL(installerUrl) {
			UIApplication.shared.open(installerUrl)
			return
		}
	}
	if let cydiaUrl =
		URL(string: "cydia://url/https://cydia.saurik.com/api/share#?source=https://repo.chariz.com&package=\(package)")
	{
		if UIApplication.shared.canOpenURL(cydiaUrl) {
			UIApplication.shared.open(cydiaUrl)
			return
		}
	}
	if let url = URL(string: "https://chariz.com/buy/\(name.lowercased())") {
		UIApplication.shared.open(url)
	}
}

struct RootPreferences_Previews: PreviewProvider {
	static var previews: some View {
		RootPreferences()
			.preferredColorScheme(.dark)
	}
}
