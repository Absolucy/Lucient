//
//  TweakAdvertisement.swift
//
//
//  Created by Lucy on 6/24/21.
//

import SwiftUI

struct TweakAdvertisement: View {
	var name: String
	var description: String
	var package: String
	var image: Image

	private func openPackage() {
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

	var body: some View {
		Button(action: {
			openPackage()
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
}
