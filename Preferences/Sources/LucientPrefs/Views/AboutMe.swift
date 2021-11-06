//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

struct AboutMe: View {
	@State var info = AuthorInfo.default
	@State var donations = DonationInfo.default
	@State var fetched = false
	@State var donationPopup = false

	var body: some View {
		Section(header: Text("About Me")) {
			Credit(name: info.name, role: "Developer", profile: .twitter(info.twitter))
			Button(action: {
				if let url = URL(string: "mailto:\(info.support)") {
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
						Text(info.support)
							.font(.system(.caption, design: .rounded))
					}
				}
			}
			Button {
				donationPopup.toggle()
			} label: {
				HStack {
					Image(systemName: "suit.heart.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 29, height: 29)
						.rainbow()
						.padding(.vertical, 5)
						.padding(.horizontal, 11)
					Text("Donate")
						.font(.system(.body, design: .rounded))
				}
			}.sheet(isPresented: $donationPopup) {
				VStack {
					Text(
						"I don't take donations, but if you want to donate to me, why not donate to one of these amazing charities instead?"
					)
					.font(.system(.headline, design: .rounded))
					.multilineTextAlignment(.center)
					List {
						ForEach(donations, id: \.name) { donations in
							Button {
								UIApplication.shared.open(donations.url)
							} label: {
								Text(donations.name).font(.system(.title3, design: .rounded))
							}.padding()
						}
					}
					Spacer()
					Text("Swipe down to exit this sheet")
						.font(.caption)
				}.padding()
			}
		}
		.onAppear {
			if !fetched {
				fetched = true
				AuthorInfo.fetch { info in
					self.info = info
				}
				DonationInfo.fetch { info in
					self.donations = info
				}
			}
		}
	}
}
