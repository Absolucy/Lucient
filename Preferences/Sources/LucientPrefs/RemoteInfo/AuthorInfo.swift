//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

struct AuthorInfo: Decodable {
	var name: String
	var support: String
	var twitter: String
	var github: String
}

extension AuthorInfo {
	static let `default` = AuthorInfo(
		name: "Lucy",
		support: "support@absolucy.moe",
		twitter: "Absolucyyy",
		github: "Absolucy"
	)

	static func fetch(callback: @escaping (AuthorInfo) -> Void) {
		guard let url = URL(string: "https://absolucy.moe/~info/info.json") else { return }
		let delegateQueue = OperationQueue()
		delegateQueue.qualityOfService = .utility
		let urlSession = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: delegateQueue)
		urlSession.dataTask(with: url) { data, _, error in
			if let error = error {
				NSLog("Failed to fetch AuthorInfo: \(error.localizedDescription)")
				return
			}
			guard let data = data else {
				NSLog("Failed to fetch AuthorInfo: no data")
				return
			}
			do {
				callback(try JSONDecoder().decode(AuthorInfo.self, from: data))
			} catch {
				NSLog("Failed to parse AuthorInfo: \(error.localizedDescription)")
			}
		}.resume()
	}
}
