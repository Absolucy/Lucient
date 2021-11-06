//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Combine

internal class DateSettings: ObservableObject, Codable, Equatable {
	@Published var usingFontSettings = false
	@Published var fontSettings = FontSettings()
	@Published var fontSize: Double = 24
	@Published var fmt = DateTimeFormatter(fmt: "E, MMM d")
	@Published var offset: Double = 0
	@Published var alignment = Alignment.left

	private var cancellables = Set<AnyCancellable>()
	private func setup() {
		fontSettings.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
		fmt.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
	}

	init() {
		setup()
	}

	// Encoding/decoding stuff //
	private enum CodingKeys: CodingKey {
		case usingFontSettings, fontSettings, fontSize, fmt, offset, alignment
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(usingFontSettings, forKey: .usingFontSettings)
		try container.encode(fontSettings, forKey: .fontSettings)
		try container.encode(fontSize, forKey: .fontSize)
		try container.encode(fmt, forKey: .fmt)
		try container.encode(offset, forKey: .offset)
		try container.encode(alignment, forKey: .alignment)
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		usingFontSettings = try container.decode(Bool.self, forKey: .usingFontSettings)
		fontSettings = try container.decode(FontSettings.self, forKey: .fontSettings)
		fontSize = try container.decode(Double.self, forKey: .fontSize)
		fmt = try container.decode(DateTimeFormatter.self, forKey: .fmt)
		offset = try container.decode(Double.self, forKey: .offset)
		alignment = try container.decode(Alignment.self, forKey: .alignment)
		setup()
	}

	static func == (lhs: DateSettings, rhs: DateSettings) -> Bool {
		lhs.usingFontSettings == rhs.usingFontSettings
			&& lhs.fontSettings == rhs.fontSettings
			&& lhs.fontSize == rhs.fontSize
			&& lhs.fmt == rhs.fmt
			&& lhs.offset == rhs.offset
			&& lhs.alignment == rhs.alignment
	}
}
