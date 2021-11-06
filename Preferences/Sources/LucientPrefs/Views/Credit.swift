//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

enum CreditProfile {
	case twitter(String)
	case github(String)
}

struct Credit: View {
	var name: String
	var role: String
	var profile: CreditProfile

	var body: some View {
		let pfpUrl: URL = {
			switch profile {
			case let .twitter(username):
				return URL(string: "https://unavatar.io/twitter/\(username)?fallback=false")!
			case let .github(username):
				return URL(string: "https://github.com/\(username).png")!
			}
		}()
		Button(action: {
			switch profile {
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
}
