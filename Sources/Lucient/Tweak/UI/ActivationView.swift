//
//  ActivationView.swift
//  LucientUITest
//
//  Created by Lucy on 6/17/21.
//

import LucientC
import SwiftUI

internal enum ActivationUpdate {
	case progress(Float), progressOver(Float, Double), status(Status)
}

enum Status {
	case fetching, success, error, failure
}

struct ActivationView: View {
	private let observer = NotificationCenter.default
		.publisher(for: NSNotification.Name(getStr(UI_DRM_ACTIVATION_OBSERVER)))
		.receive(on: RunLoop.main)

	var window: UIWindow
	@State var progress: Float = 0.0
	@State var status = Status.fetching

	static func setup() {
		let width = UIScreen.main.bounds.width * 0.8
		let height = UIScreen.main.bounds.height * 0.5
		let x = (UIScreen.main.bounds.width / 2) - (width / 2)
		let y = (UIScreen.main.bounds.height / 2) - (height / 2)
		let window = UIWindow(frame: CGRect(x: x, y: y, width: width, height: height))
		window.backgroundColor = UIColor.clear
		window.windowLevel = UIWindow.Level.statusBar + 1000
		window.clipsToBounds = false
		window.isUserInteractionEnabled = true
		window.isOpaque = false
		if !UIAccessibility.isReduceTransparencyEnabled {
			let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
			blur.frame = CGRect(x: -x, y: -y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
			blur.layer.masksToBounds = false
			window.addSubview(blur)
		}
		let view = ActivationView(window: window)
		window.rootViewController = UIHostingController(rootView: view)
		window.rootViewController?.view?.backgroundColor = UIColor.clear
		window.makeKeyAndVisible()
	}

	func close() {
		window.rootViewController?.view.removeFromSuperview()
		window.rootViewController?.removeFromParent()
		window.rootViewController = nil
		window.isHidden = true
		window.removeFromSuperview()
		window.resignKey()
	}

	@ViewBuilder
	func FetchView() -> some View {
		VStack {
			Text("Lucient")
				.font(.largeTitle)
				.padding()
			Text(getStr(UI_DRM_FETCHING))
				.font(.body)
				.multilineTextAlignment(.center)
			ProgressBar(value: $progress, status: .neutral)
				.frame(height: 20)
				.padding(.horizontal)
		}
	}

	@ViewBuilder
	func SuccessView() -> some View {
		VStack {
			Text("Lucient")
				.font(.largeTitle)
				.padding()
			Text(getStr(UI_DRM_SUCCESS))
				.font(.body)
				.multilineTextAlignment(.center)
			ProgressBar(value: $progress, status: .good)
				.frame(height: 20)
				.padding([.horizontal, .bottom])
		}
	}

	@ViewBuilder
	func ErrorView() -> some View {
		VStack {
			Text("Lucient")
				.font(.largeTitle)
				.padding()
			Text(getStr(UI_DRM_ERROR))
				.font(.body)
				.multilineTextAlignment(.center)
				.padding(5)
			ProgressBar(value: $progress, status: .bad)
				.frame(height: 20)
				.padding([.horizontal, .bottom])
			Button(getStr(UI_DRM_BUTTONS_CONTINUE)) {
				close()
			}.padding(.top, 5)
			Divider().padding(.horizontal).padding(.vertical, 5)
			Button(getStr(UI_DRM_BUTTONS_TRY_AGAIN)) {
				respring()
			}.padding(.bottom, 5)
		}
	}

	@ViewBuilder
	func FailureView() -> some View {
		VStack {
			Text("Lucient")
				.font(.largeTitle)
				.padding()
			Text(getStr(UI_DRM_PIRATED))
				.font(.body)
				.multilineTextAlignment(.center)
				.padding(5)
			ProgressBar(value: $progress, status: .bad)
				.frame(height: 20)
				.padding([.horizontal, .bottom])
			Button(getStr(UI_DRM_BUTTONS_CONTINUE)) {
				close()
			}.padding(.top, 5)
			Divider().padding(.horizontal).padding(.vertical, 5)
			Button(getStr(UI_DRM_BUTTONS_TRY_AGAIN)) {
				respring()
			}.padding(.bottom, 5)
		}
	}

	@ViewBuilder
	func BuildView() -> some View {
		switch status {
		case .fetching:
			FetchView()
		case .success:
			SuccessView()
		case .error:
			ErrorView()
		case .failure:
			FailureView()
		}
	}

	var body: some View {
		let width = UIScreen.main.bounds.width * 0.8
		let height = UIScreen.main.bounds.height * 0.5
		RoundedRectangle(cornerRadius: 32)
			.foregroundColor(Color(UIColor.tertiarySystemBackground))
			.overlay(BuildView().padding(5))
			.frame(width: width, height: height)
			.onReceive(observer) { update in
				guard let update = update.object as? ActivationUpdate else { return }
				switch update {
				case let .progress(progress):
					withAnimation(.linear(duration: 1)) {
						self.progress = progress
					}
				case let .progressOver(progress, duration):
					withAnimation(.linear(duration: duration)) {
						self.progress = progress
					}
				case let .status(status):
					self.status = status
				}
			}
	}
}
