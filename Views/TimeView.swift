//
//  12TimeView.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import SwiftUI
import UIKit

struct TimeView: View {
	private static var formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "h\nmm"
		return formatter
	}()

	@State private var size: CGFloat = 96

	var body: some View {
		Text(TimeView.formatter.string(from: Date()))
			.font(.system(size: size, weight: .thin, design: .rounded))
			.multilineTextAlignment(.center)
	}
}

@_cdecl("makeTimeView")
public dynamic func makeTimeView() -> UIViewController? {
	UIHostingController(rootView: TimeView())
}

struct TimeView_Previews: PreviewProvider {
	static var previews: some View {
		TimeView()
			.previewDevice("iPhone 11")
	}
}
