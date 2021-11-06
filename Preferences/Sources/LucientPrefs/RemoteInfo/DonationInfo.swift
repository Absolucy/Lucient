//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

struct DonationInfo: Decodable {
	var name: String
	var url: URL
}

extension DonationInfo {
	static let `default` = [
		DonationInfo(name: "National Center for Transgender Equality", url: URL(string: "https://transequality.org")!),
		DonationInfo(name: "Autistic Women & Nonbinary Network", url: URL(string: "https://awnnetwork.org")!),
		DonationInfo(name: "Doctors Without Borders", url: URL(string: "https://www.doctorswithoutborders.org")!),
		DonationInfo(name: "Trevor Project", url: URL(string: "https://www.thetrevorproject.org")!),
		DonationInfo(name: "Electronic Frontier Foundation", url: URL(string: "https://www.eff.org")!),
		DonationInfo(name: "American Civil Liberties Union", url: URL(string: "https://www.aclu.org")!),
	]

	static func fetch(callback: @escaping ([DonationInfo]) -> Void) {
		guard let url = URL(string: "https://absolucy.moe/~info/donations.json") else { return }
		let delegateQueue = OperationQueue()
		delegateQueue.qualityOfService = .utility
		let urlSession = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: delegateQueue)
		urlSession.dataTask(with: url) { data, _, error in
			if let error = error {
				NSLog("Failed to fetch DonationInfo: \(error.localizedDescription)")
				return
			}
			guard let data = data else {
				NSLog("Failed to fetch DonationInfo: no data")
				return
			}
			do {
				callback(try JSONDecoder().decode([DonationInfo].self, from: data))
			} catch {
				NSLog("Failed to parse DonationInfo: \(error.localizedDescription)")
			}
		}.resume()
	}
}
