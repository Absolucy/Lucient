//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

struct StockPreferences: View {
	@Binding var settings: StockSettings
	@Binding var showingRespringAlert: Bool

	var body: some View {
		Section(header: Text("Stock Elements")) {
			Toggle("Hide Quick Actions", isOn: $settings.hideQuickActions)
				.padding(.vertical, 5)
				.onChange(of: settings.hideQuickActions) { _ in
					showingRespringAlert = true
				}
				.onTapGesture(count: 2) {
					settings.hideQuickActions = true
				}
			Toggle("Hide Lock", isOn: $settings.hideLock)
				.padding(.vertical, 5)
				.onChange(of: settings.hideLock) { _ in
					showingRespringAlert = true
				}
				.onTapGesture(count: 2) {
					settings.hideLock = true
				}
		}
	}
}
