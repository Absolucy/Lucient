//
//  ProgressBar.swift
//  LucientUITest
//
//  Created by Lucy on 6/17/21.
//

import Foundation
import SwiftUI

enum ProgressStatus {
	case neutral, good, bad
}

struct ProgressBar: View {
	@State var saturation = 1.0
	@Binding var value: Float
	var status: ProgressStatus

	func color() -> Color {
		switch status {
		case .neutral:
			return Color(UIColor.systemBlue)
		case .good:
			return Color(UIColor.systemGreen)
		case .bad:
			return Color(UIColor.systemRed)
		}
	}

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
					.opacity(0.3)
					.foregroundColor(color())
					.saturation(0.6)

				Rectangle()
					.frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
					.foregroundColor(color())
					.animation(.linear)
					.saturation(saturation)
					.onAppear {
						withAnimation(.easeInOut.speed(0.25).repeatForever()) {
							saturation = 0.7
						}
					}
			}.cornerRadius(45.0)
		}
	}
}
