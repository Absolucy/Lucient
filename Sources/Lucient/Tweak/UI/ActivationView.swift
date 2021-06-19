//
//  ActivationView.swift
//  LucientUITest
//
//  Created by Lucy on 6/17/21.
//

import SwiftUI

internal enum ActivationUpdate {
	case progress(Float), progressOver(Float, Double), status(Status)
}

enum Status {
	case fetching, success, error, failure
}

struct ActivationView: View {
	private let observer = NotificationCenter.default.publisher(for: NSNotification.Name("moe.absolucy.lucient.activ")).receive(on: RunLoop.main)

	var window: UIWindow
	@State var progress: Float = 0.0
	@State var status = Status.fetching

	static func setup() {
		let width = UIScreen.main.bounds.width * 0.8
		let height = UIScreen.main.bounds.height * 0.5
		let x = (UIScreen.main.bounds.width / 2) - (width / 2)
		let y = (UIScreen.main.bounds.height / 2) - (height / 2)
		let window = UIWindow(frame: CGRect(x: x, y: y, width: width, height: height))
		window.backgroundColor = UIColor.systemBackground
		window.windowLevel = UIWindow.Level.statusBar + 1000
		window.clipsToBounds = false
		window.isUserInteractionEnabled = true
		window.isOpaque = false
		window.layer.cornerRadius = 32
		window.layer.masksToBounds = true
		let view = ActivationView(window: window)
		window.rootViewController = UIHostingController(rootView: view)
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
				.font(.title)
				.padding()
			Text("Don't Panic!\nWe're activating Lucient right now!")
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
				.font(.title)
				.padding()
			Text("""
			Lucient has been activated successfully, and your device with automatically respring.
			Share and enjoy.
			""")
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
				.font(.title)
				.padding()
			Text("""
			Lucient failed to contact the authentication server.
			Ensure that you have a proper internet connection currently, and that there are no firewalls blocking access to the internet.
			If everything seems fine, then wait a bit and try again, as the server may just be down for maintenance.
			""")
				.font(.body)
				.multilineTextAlignment(.center)
				.padding(5)
			ProgressBar(value: $progress, status: .bad)
				.frame(height: 20)
				.padding([.horizontal, .bottom])
			Button("Continue without Lucient") {
				close()
			}.padding(2)
			Button("Try Again") {}.padding(2)
		}
	}

	@ViewBuilder
	func FailureView() -> some View {
		VStack {
			Text("Lucient")
				.font(.title)
				.padding()
			Text("""
			Lucient failed to activate.
			Please ensure you have bought Lucient legitimately.
			If so, email Lucy with a proof-of-purchase and ask for help.
			""")
				.font(.body)
				.multilineTextAlignment(.center)
				.padding(5)
			ProgressBar(value: $progress, status: .bad)
				.frame(height: 20)
				.padding([.horizontal, .bottom])
			Button("Continue without Lucient") {
				close()
			}.padding(2)
			Button("Try Again") {}.padding(2)
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
		BuildView()
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

@_cdecl("showActivationWindow")
public dynamic func showActivationWindow() {
	ActivationView.setup()
}
