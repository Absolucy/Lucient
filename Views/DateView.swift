//
//  DateView.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import SwiftUI

struct DateView: View {
	private static var formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "E, MMM d"
		return formatter
	}()

	var body: some View {
		Text(DateView.formatter.string(from: Date()))
			.font(.system(size: 24, weight: .light, design: .rounded))
	}
}

@_cdecl("makeDateView")
public dynamic func makeDateView() -> UIViewController? {
	UIHostingController(rootView: DateView())
}

struct DateView_Previews: PreviewProvider {
	static var previews: some View {
		DateView()
	}
}
