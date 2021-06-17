import CryptoKit
import Foundation
import UIKit
import LucientC

internal struct DRM {
	internal static var ticket: AuthorizationTicket? = AuthorizationTicket()
	private static var fetchingNewTicket = false
	private static var authInProgress = false
	private static var authSemaphore = DispatchSemaphore(value: 0)
	private static var ticketCooldown = false

	internal static func ticketAuthorized() -> Bool {
		#if DRM
			if authInProgress, !fetchingNewTicket {
				authSemaphore.wait()
			}
			ticket = ticket ?? AuthorizationTicket()
			if let ticket = self.ticket, !ticketCooldown, !fetchingNewTicket, !ticket.isTrial(),
			   Date() >= ticket.goodTimeToRenew()
			{
				ticketCooldown = true
				DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1800) {
					ticketCooldown = false
				}
				if ticket.isSignatureValid() {
					var myThread: pthread_t?
					func thread(_: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
						if DRM.fetchingNewTicket {
							return nil
						}
						DRM.fetchingNewTicket = true
						#if DEBUG
							NSLog("Lucient: updating ticket from new thread")
						#endif
						DRM.silentlyUpdateTicket()
						DRM.fetchingNewTicket = false
						return nil
					}
					pthread_create(&myThread, nil, thread, nil)
				}
			}
			return ticket?.isValid() ?? false
		#else
			return true
		#endif
	}

	internal static func silentlyUpdateTicket() {
		authInProgress = true
		contactServer { response in
			defer {
				authInProgress = false
				authSemaphore.signal()
			}
			if case let .success(ticket) = response {
				ticket.save()
				self.ticket = ticket
				#if DEBUG
					NSLog("Lucient: updated with new ticket")
				#endif
			} else {
				#if DEBUG
					NSLog("Lucient: silent ticket update failed")
				#endif
			}
		}
	}

	internal static func requestTicket() {
		authInProgress = true

		if !dpkg_check() {
			UIAlertView(
				title: getStr(UI_DRM_HEADER),
				message: getStr(UI_DRM_PIRATED),
				delegate: nil,
				cancelButtonTitle: getStr(UI_DRM_EXIT)
			)
			.show()
			authInProgress = false
			authSemaphore.signal()
			return
		}

		#if TRIAL
			let alert = UIAlertView(
				title: getStr(UI_DRM_HEADER),
				message: getStr(UI_DRM_TRIAL_IN_PROGRESS),
				delegate: nil,
				cancelButtonTitle: nil
			)
		#else
			let alert = UIAlertView(
				title: getStr(UI_DRM_HEADER),
				message: getStr(UI_DRM_TRIAL_IN_PROGRESS),
				delegate: nil,
				cancelButtonTitle: nil
			)
		#endif

		alert.show()

		let artificalWait = DispatchSemaphore(value: 0)
		DispatchQueue.main.asyncAfter(deadline: .now() + 2, qos: .background) {
			artificalWait.signal()
		}

		contactServer { response in
			DispatchQueue.main.async(qos: .userInteractive) {
				defer {
					authInProgress = false
					authSemaphore.signal()
				}
				_ = artificalWait.wait(timeout: .now() + 2)

				switch response {
				case .error:
					alert.dismiss(withClickedButtonIndex: 0, animated: false)
					UIAlertView(title: getStr(UI_DRM_HEADER), message: getStr(UI_DRM_ERROR), delegate: nil,
					            cancelButtonTitle: getStr(UI_DRM_EXIT)).show()
				case .denied:
					alert.dismiss(withClickedButtonIndex: 0, animated: false)
					#if TRIAL
						UIAlertView(title: getStr(UI_DRM_HEADER), message: getStr(UI_DRM_TRIAL_FAILED), delegate: nil,
						            cancelButtonTitle: getStr(UI_DRM_EXIT)).show()
					#else
						UIAlertView(title: getStr(UI_DRM_HEADER), message: getStr(UI_DRM_PIRATED), delegate: nil,
						            cancelButtonTitle: getStr(UI_DRM_EXIT)).show()
					#endif
				case let .success(ticket):
					if ticket.isValid() {
						ticket.save()
						self.ticket = ticket
						#if DEBUG
							NSLog("Lucient: saved ticket")
						#endif
						alert.message = String(format: getStr(UI_DRM_SUCCESS), 3)
						DispatchQueue.main.asyncAfter(deadline: .now() + 1, qos: .userInteractive) {
							alert.message = String(format: getStr(UI_DRM_SUCCESS), 2)
						}
						DispatchQueue.main.asyncAfter(deadline: .now() + 2, qos: .userInteractive) {
							alert.message = String(format: getStr(UI_DRM_SUCCESS), 1)
						}
						DispatchQueue.main.asyncAfter(deadline: .now() + 3, qos: .userInteractive) {
							respring()
						}
					} else {
						alert.dismiss(withClickedButtonIndex: 0, animated: false)
						#if DEBUG
							UIAlertView(
								title: getStr(UI_DRM_HEADER),
								message: "invalid ticket??",
								delegate: nil,
								cancelButtonTitle: getStr(UI_DRM_EXIT)
							)
							.show()
						#else
							UIAlertView(
								title: getStr(UI_DRM_HEADER),
								message: getStr(UI_DRM_PIRATED),
								delegate: nil,
								cancelButtonTitle: getStr(UI_DRM_EXIT)
							)
							.show()
						#endif
					}
				}
			}
		}
	}
}

internal func prepareGoldenTicket() {
	let path = getStr(PATHS_ENCRYPTED_TICKET_FOLDER)
	var isDir: ObjCBool = false
	let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
	if !exists || !isDir.boolValue {
		do {
			try FileManager.default.removeItem(atPath: path)
		} catch {}
		do {
			try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
		} catch {}
	}
}

internal func respring() {
	let sbreload = NSTask()!
	sbreload.setLaunchPath(getStr(PATHS_SBRELOAD))
	sbreload.launch()
	// just in case sbreload screws up somehow
	DispatchQueue.main.asyncAfter(deadline: .now() + 5, qos: .userInteractive) {
		let killSpringBoard = NSTask()!
		killSpringBoard.setLaunchPath(getStr(PATHS_KILLALL))
		killSpringBoard.arguments = getStr(PATHS_KILLALL_ARGUMENTS).split(separator: " ").map { String($0) }
		killSpringBoard.launch()
	}
}

internal extension FixedWidthInteger {
	var data: Data {
		let data = withUnsafeBytes(of: self) { Data($0) }
		return data
	}
}
