//
//  ActivationView.swift
//  LucientUITest
//
//  Created by Lucy on 6/17/21.
//

import LucientC
import SwiftUI

enum Status {
	case fetching, success, error, failure
}

struct ActivationView: View {
	private let observer = NotificationCenter.default
		.publisher(for: NSNotification.Name(getStr(UI_DRM_ACTIVATION_OBSERVER)))
		.receive(on: RunLoop.main)

	@State var window: UIWindow?
	@State var blurView: UIVisualEffectView?
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
		var blurView: UIVisualEffectView?
		if !UIAccessibility.isReduceTransparencyEnabled {
			let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
			blur.frame = CGRect(x: -x, y: -y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
			blur.layer.masksToBounds = false
			window.addSubview(blur)
			blurView = blur
		}
		let view = ActivationView(window: window, blurView: blurView)
		window.rootViewController = UIHostingController(rootView: view)
		window.rootViewController?.view?.backgroundColor = UIColor.clear
		window.makeKeyAndVisible()
	}

	func close() {
		blurView?.removeFromSuperview()
		blurView = nil
		window?.rootViewController?.view.removeFromSuperview()
		window?.rootViewController?.removeFromParent()
		window?.rootViewController = nil
		window?.isHidden = true
		window?.removeFromSuperview()
		window?.resignKey()
		window = nil
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
			ProgressView()
				.padding()
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
			Image(systemName: "face.smiling")
				.resizable()
				.renderingMode(.template)
				.scaledToFit()
				.foregroundColor(Color.green)
				.frame(width: 48, height: 48)
				.padding()
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
			Image(systemName: "wifi.exclamationmark")
				.resizable()
				.renderingMode(.template)
				.scaledToFit()
				.foregroundColor(Color.red)
				.frame(width: 48, height: 48)
				.padding()
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
			Image(systemName: "person.crop.circle.badge.exclamationmark")
				.resizable()
				.renderingMode(.template)
				.scaledToFit()
				.foregroundColor(Color.red)
				.frame(width: 48, height: 48)
				.padding()
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
				guard let status = update.object as? Status else { return }
				self.status = status
			}
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 90, qos: .background) {
					if let window = self.window, !window.isHidden,
					   self.status == .fetching || self.status == .success
					{
						fatalError("Activation prompt seems to have hung; crashing so the device will enter safe mode!")
					}
				}
			}
	}
}
