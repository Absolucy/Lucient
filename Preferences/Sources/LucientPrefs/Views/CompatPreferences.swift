//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

struct CompatPreferences: View {
	@Binding var miscSettings: MiscSettings

	var body: some View {
		Section(header: Text("Compatibility")) {
			Toggle("Axon", isOn: $miscSettings.axonCompat)
				.disabled(!FileManager.default
					.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/Axon.dylib"))
				.padding(.vertical, 4)
			Toggle("Tako", isOn: $miscSettings.takoCompat)
				.disabled(!FileManager.default
					.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/Tako.dylib"))
				.padding(.vertical, 4)
		}
	}
}
