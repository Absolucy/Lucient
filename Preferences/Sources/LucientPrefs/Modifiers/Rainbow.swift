//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

struct Rainbow: ViewModifier {
	let hueColors = stride(from: 0, to: 1, by: 0.1).map {
		Color(hue: $0, saturation: 1, brightness: 1)
	}

	func body(content: Content) -> some View {
		content
			.overlay(GeometryReader { (proxy: GeometryProxy) in
				ZStack {
					LinearGradient(gradient: Gradient(colors: self.hueColors),
					               startPoint: .leading,
					               endPoint: .trailing)
						.frame(width: proxy.size.width, height: proxy.size.height)
				}
			})
			.mask(content)
	}
}

extension View {
	func rainbow() -> some View {
		modifier(Rainbow())
	}
}
