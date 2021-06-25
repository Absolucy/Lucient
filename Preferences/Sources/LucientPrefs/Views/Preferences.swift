//
//  Preferences.swift
//
//
//  Created by Lucy on 6/21/21.
//

import LucientPrefsC
import SwiftUI
import UniformTypeIdentifiers

let identifier = "moe.absolucy.lucient"

struct Preferences: View {
	@Preference("enabled", identifier: identifier) private var enabled = true
	@Preference("separatedColors", identifier: identifier) private var separatedColors = false
	@State private var showFontPicker = false
	@State private var showingRespringAlert = false

	private let logo: Image = {
		if let logo = UIImage(contentsOfFile: "/Library/Lucy/LucientResources.bundle/logo.png") {
			return Image(uiImage: logo)
		} else {
			return Image(systemName: "lock.square.stack")
		}
	}()

	@ViewBuilder
	func HeaderSection() -> some View {
		Header(
			"Lucient",
			icon: logo.resizable().padding(16).aspectRatio(contentMode: .fit),
			subtitle: "by Lucy"
		)
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
	func CreditsSection() -> some View {
		Section(header: Text("Credits")) {
			Credit(name: "Alpha", role: "Logo Designer", profile: .twitter("Kutarin_"))
			Credit(name: "Emma", role: "Tester", profile: .twitter("emiyl0"))
			Credit(name: "Emy", role: "Tester", profile: .github("Emy"))
			Credit(name: "Litten", role: "libkitten developer", profile: .twitter("schneelittchen"))
		}
	}

	var body: some View {
		VStack {
			Form {
				HeaderSection()
				if enabled {
					StylePreferences(separatedColors: $separatedColors)
					ClockPreferences(separatedColors: $separatedColors)
					DatePreferences(separatedColors: $separatedColors)
					ImportExport()
					AboutMe()
					CreditsSection()
				}
			}
			Text("Some options can be reset to default by double-tapping!")
				.font(.system(.caption2, design: .rounded))
				.fontWeight(.light)
				.padding()
		}
	}
}

struct Preferences_Previews: PreviewProvider {
	static var previews: some View {
		Preferences()
			.preferredColorScheme(.dark)
	}
}
