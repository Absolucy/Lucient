//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal class DateTimeFormatter: ObservableObject, Codable, Equatable {
	private var dateFormatter = DateFormatter()
	@Published var format = "" {
		didSet {
			dateFormatter.dateFormat = format
			objectWillChange.send()
		}
	}

	func string(from date: Date) -> String {
		dateFormatter.string(from: date)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(format)
	}

	init(fmt: String) {
		format = fmt
		dateFormatter.dateFormat = fmt
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		format = try container.decode(String.self)
		dateFormatter.dateFormat = format
	}

	static func == (lhs: DateTimeFormatter, rhs: DateTimeFormatter) -> Bool {
		lhs.format == rhs.format
	}
}
