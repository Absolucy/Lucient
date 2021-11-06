//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


import EventKit
import Foundation
import SwiftUI
import UIKit

internal final class EventHandler: ObservableObject {
	internal static var instance = EventHandler()

	/// Event/calender handler
	private let ekStore = EKEventStore()
	/// The currently available events.
	@Published internal var events: [EKEvent] = []
	/// Gets every event that will occur within the next day.
	internal final func getEvents() {
		let calendar = Calendar.current
		var dayComponents = DateComponents()
		dayComponents.day = 0
		let today = calendar.date(byAdding: dayComponents, to: Date())

		var tomorrowComponents = DateComponents()
		tomorrowComponents.day = 1
		let tomorrow = calendar.date(byAdding: tomorrowComponents, to: Date())

		var predicate: NSPredicate?
		if let aToday = today, let aTomorrow = tomorrow {
			predicate = ekStore.predicateForEvents(withStart: aToday, end: aTomorrow, calendars: nil)
		}

		var events: [EKEvent]?
		if let aPredicate = predicate {
			events = ekStore.events(matching: aPredicate)
		}

		if let events = events {
			self.events = events.filter { $0.startDate > Date() && $0.startDate <= Date().addingTimeInterval(86400) }
				.sorted { $0.startDate < $1.startDate }
		}
	}

	init() {
		ekStore.requestAccess(to: .event) { _, error in
			if let error = error {
				NSLog("[Lucient] failed to get access to events: \(error)")
			}
		}
		getEvents()
	}
}
