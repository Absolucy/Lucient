//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Combine

internal enum ClockMode: String, Codable {
	case wide, tall
}

internal class TimeSettings: ObservableObject, Codable, Equatable {
	@Published var usingFontSettings = false
	@Published var fontSettings = FontSettings()
	@Published var smallFontSize: Double = 72
	@Published var bigFontSize: Double = 140
	@Published var bigSpacing: Double = 15
	@Published var bigOffset: Double = 0
	@Published var smallOffset: Double = 0
	@Published var is24hr = false
	@Published var mode = ClockMode.wide
	@Published var leftFmt = DateTimeFormatter(fmt: "hh:mm")
	@Published var rightFmt = DateTimeFormatter(fmt: "h mm")
	@Published var alwaysSmall = false
	@Published var alwaysSmallInAod = false

	private var cancellables = Set<AnyCancellable>()
	private func setup() {
		fontSettings.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
		leftFmt.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
		rightFmt.objectWillChange
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
		case usingFontSettings, fontSettings, smallFontSize, bigFontSize, bigSpacing, bigOffset, is24hr, showAmPm, side, mode,
		     leftFmt, rightFmt, alwaysSmall, smallOffset, alwaysSmallInAod
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(usingFontSettings, forKey: .usingFontSettings)
		try container.encode(fontSettings, forKey: .fontSettings)
		try container.encode(smallFontSize, forKey: .smallFontSize)
		try container.encode(bigFontSize, forKey: .bigFontSize)
		try container.encode(bigSpacing, forKey: .bigSpacing)
		try container.encode(smallOffset, forKey: .smallOffset)
		try container.encode(bigOffset, forKey: .bigOffset)
		try container.encode(is24hr, forKey: .is24hr)
		try container.encode(mode, forKey: .mode)
		try container.encode(leftFmt, forKey: .leftFmt)
		try container.encode(rightFmt, forKey: .rightFmt)
		try container.encode(alwaysSmall, forKey: .alwaysSmall)
		try container.encode(alwaysSmallInAod, forKey: .alwaysSmallInAod)
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		usingFontSettings = try container.decode(Bool.self, forKey: .usingFontSettings)
		fontSettings = try container.decode(FontSettings.self, forKey: .fontSettings)
		smallFontSize = try container.decode(Double.self, forKey: .smallFontSize)
		bigFontSize = try container.decode(Double.self, forKey: .bigFontSize)
		bigSpacing = try container.decode(Double.self, forKey: .bigSpacing)
		bigOffset = try container.decode(Double.self, forKey: .bigOffset)
		if let smallOffset = try? container.decode(Double.self, forKey: .smallOffset) {
			self.smallOffset = smallOffset
		}
		is24hr = try container.decode(Bool.self, forKey: .is24hr)
		if let mode = try? container.decode(ClockMode.self, forKey: .mode) {
			self.mode = mode
		} else if let side = try? container.decode(String.self, forKey: .side) {
			if side == "left" {
				mode = .wide
			} else if side == "right" {
				mode = .tall
			}
		}
		leftFmt = try container.decode(DateTimeFormatter.self, forKey: .leftFmt)
		rightFmt = try container.decode(DateTimeFormatter.self, forKey: .rightFmt)
		if let alwaysSmall = try? container.decode(Bool.self, forKey: .alwaysSmall) {
			self.alwaysSmall = alwaysSmall
		}
		if let alwaysSmallInAod = try? container.decode(Bool.self, forKey: .alwaysSmallInAod) {
			self.alwaysSmallInAod = alwaysSmallInAod
		}
		setup()
	}

	static func == (lhs: TimeSettings, rhs: TimeSettings) -> Bool {
		lhs.usingFontSettings == rhs.usingFontSettings
			&& lhs.fontSettings == rhs.fontSettings
			&& lhs.smallFontSize == rhs.smallFontSize
			&& lhs.bigFontSize == rhs.bigFontSize
			&& lhs.bigSpacing == rhs.bigSpacing
			&& lhs.bigOffset == rhs.bigOffset
			&& lhs.is24hr == rhs.is24hr
			&& lhs.mode == rhs.mode
			&& lhs.leftFmt == rhs.leftFmt
			&& lhs.rightFmt == rhs.rightFmt
			&& lhs.alwaysSmall == rhs.alwaysSmall
			&& lhs.alwaysSmallInAod == rhs.alwaysSmallInAod
	}
}
