//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import LucientPrefsC
import SwiftUI
import UniformTypeIdentifiers

let identifier = "moe.absolucy.lucient"

struct Preferences: View {
	@Preference("settings", identifier: "moe.absolucy.lucient") var settings = Settings()
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
			icon: logo.resizable().frame(width: 95, height: 123),
			subtitle: "by Lucy"
		)
		Section(header: Text("Enable/Disable")) {
			Toggle("Enable", isOn: $settings.enabled)
				.onChange(of: settings.enabled) { _ in
					showingRespringAlert = true
				}
		}
	}

	@ViewBuilder
	func GlobalSection() -> some View {
		Section(header: Text("Global")) {
			Picker(selection: $settings.dateSettings.alignment, label: EmptyView()) {
				Text("Left").tag(Alignment.left)
				Text("Center").tag(Alignment.center)
				Text("Right").tag(Alignment.right)
			}.pickerStyle(SegmentedPickerStyle()).padding(.vertical, 4)
			StyleOption(fontSettings: $settings.globalFontSettings)
				.padding(.vertical, 5)
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
				if settings.enabled {
					GlobalSection()
					ClockPreferences(timeSettings: $settings.timeSettings)
					DatePreferences(dateSettings: $settings.dateSettings, miscSettings: $settings.miscSettings)
					BatteryPreferences(batterySettings: $settings.batterySettings)
					StockPreferences(settings: $settings.stockSettings, showingRespringAlert: $showingRespringAlert)
					CompatPreferences(miscSettings: $settings.miscSettings)
					ImportExport(settings: $settings)
					AboutMe()
					CreditsSection()
				}
			}
			Text("Some options can be reset to default by double-tapping!")
				.font(.system(.caption2, design: .rounded))
				.fontWeight(.light)
				.padding()
		}
		.alert(isPresented: $showingRespringAlert) {
			Alert(
				title: Text("Lucient"),
				message: Text("In order to change this setting, you need to respring.\nWould you like to do so now?"),
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
		.onChange(of: settings) { newValue in
			UserDefaults.lucientSettings = newValue
		}
		.navigationBarTitle("Lucient")
		.navigationBarTitleDisplayMode(.inline)
	}
}
