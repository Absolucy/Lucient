//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


import LucientC
import SwiftUI

struct LockScreen: View {
	@Environment(\.colorScheme) private var colorScheme
	@ObservedObject private var shared = SharedData.global
	@ObservedObject private var eventHandler = EventHandler.instance
	@Preference("settings", identifier: "moe.absolucy.lucient") private var settings = Settings()
	@Namespace private var timeTransition

	@ViewBuilder
	private func TimeView() -> some View {
		switch settings.timeSettings.mode {
		case .wide:
			LittleTimeView(date: $shared.date)
		case .tall:
			TopRightTimeView(date: $shared.date)
		}
	}

	private func shouldTimeBeSmall() -> Bool {
		if settings.timeSettings.alwaysSmall {
			return settings.timeSettings.alwaysSmallInAod || !shared.aodOn
		}
		return shared.timeMinimized
	}

	var body: some View {
		let event = eventHandler.events.first
		let smallTime = shouldTimeBeSmall()
		ZStack {
			if !smallTime {
				VStack {
					Spacer()
					BigTimeView(date: $shared.date)
						.offset(x: 0, y: CGFloat(settings.timeSettings.bigOffset))
						.matchedGeometryEffect(id: "time", in: timeTransition, anchor: .topLeading)
						.if(!UIAccessibility.isReduceMotionEnabled) { view in
							view.transition(.scale)
						}
				}.align(alignment: .center)
			}
			VStack(alignment: .leading, spacing: 0) {
				Spacer()
				if smallTime {
					TimeView()
						.align(alignment: settings.dateSettings.alignment)
						.offset(x: 0, y: CGFloat(settings.timeSettings.smallOffset))
						.matchedGeometryEffect(id: "time", in: timeTransition, anchor: .topLeading)
						.if(!UIAccessibility.isReduceMotionEnabled) { view in
							view.transition(.scale)
						}
				}
				DateView(date: $shared.date)
					.align(alignment: settings.dateSettings.alignment)
				if settings.miscSettings.remindersEnabled, shared.showingReminders, let event = event {
					EventView(event: event)
						.if(!UIAccessibility.isReduceTransparencyEnabled && !UIAccessibility
							.isReduceMotionEnabled) { view in
								view.transition(.opacity)
						}
						.align(alignment: settings.dateSettings.alignment)
				} else if settings.miscSettings.weatherEnabled {
					WeatherView()
						.if(!UIAccessibility.isReduceTransparencyEnabled && !UIAccessibility
							.isReduceMotionEnabled) { view in
								view.transition(.opacity)
						}
						.align(alignment: settings.dateSettings.alignment)
				}
				Spacer()
			}
			.align(alignment: settings.dateSettings.alignment)
			.padding(.horizontal)
			.offset(x: 0, y: CGFloat(settings.dateSettings.offset) - (UIScreen.main.bounds.size.height / 8))
		}
		.offset(x: 0, y: CGFloat(shared.offset))
		.onChange(of: colorScheme) { _ in
			DispatchQueue.main.async(qos: .userInteractive) {
				NSLog("[Lucient] color scheme changed, re-calculating wallpaper")
				ColorManager.instance.updateWallpaper()
				ColorManager.instance.setupWallpaperMonitor()
			}
		}
		.onChange(of: settings.miscSettings.reminderFlipTimer) { _ in
			shared.startTimers()
		}
		.onChange(of: settings.miscSettings.weatherRefreshTimer) { _ in
			shared.startTimers()
		}
		.environmentObject(settings)
	}
}

@_cdecl("makeLsView")
internal func makeLsView() -> UIViewController! {
	UIHostingController(rootView: LockScreen())
}
