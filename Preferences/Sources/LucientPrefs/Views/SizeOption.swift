//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

struct SizeOption: View {
	var format: String = "%.0f"
	var name: String
	var option: Binding<Double>
	var min: Double
	var max: Double
	var defaultOption: Double

	var body: some View {
		VStack(spacing: 0) {
			Text(name).padding(.bottom, 5)
			HStack {
				Spacer()
				Text(String(format: format, option.wrappedValue))
					.font(.system(.footnote, design: .rounded))
				Spacer()
			}.padding(.vertical, 5)
			HStack {
				Text(String(format: format, min))
					.font(.caption2)
				Slider(value: option, in: min ... max, step: 1) { _ in }
				Text(String(format: format, max))
					.font(.caption2)
			}.padding(.top, 5)
		}
		.onTapGesture(count: 2) {
			option.wrappedValue = defaultOption
		}
	}
}
