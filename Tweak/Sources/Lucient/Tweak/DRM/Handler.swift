import CryptoKit
import Foundation
import LucientC
import UIKit

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

		let notifierName = NSNotification.Name(getStr(UI_DRM_ACTIVATION_OBSERVER))

		if !dpkg_check() {
			NotificationCenter.default.post(
				name: notifierName,
				object: ActivationUpdate.status(.failure)
			)
			authInProgress = false
			authSemaphore.signal()
			return
		}

		NotificationCenter.default.post(
			name: notifierName,
			object: ActivationUpdate.progress(0.25)
		)

		contactServer { response in
			NotificationCenter.default.post(
				name: notifierName,
				object: ActivationUpdate.progressOver(0.75, 1.9)
			)
			DispatchQueue.main.asyncAfter(deadline: .now() + 2, qos: .userInteractive) {
				defer {
					authInProgress = false
					authSemaphore.signal()
				}
				NotificationCenter.default.post(
					name: notifierName,
					object: ActivationUpdate.progress(0.9)
				)

				switch response {
				case .error:
					NotificationCenter.default.post(
						name: notifierName,
						object: ActivationUpdate.status(.error)
					)
				case .denied:
					NotificationCenter.default.post(
						name: notifierName,
						object: ActivationUpdate.status(.failure)
					)
				case let .success(ticket):
					if ticket.isValid() {
						ticket.save()
						self.ticket = ticket
						#if DEBUG
							NSLog("Lucient: saved ticket")
						#endif
						NotificationCenter.default.post(
							name: notifierName,
							object: ActivationUpdate.progress(1.0)
						)
						NotificationCenter.default.post(
							name: notifierName,
							object: ActivationUpdate.status(.success)
						)
						DispatchQueue.main.asyncAfter(deadline: .now() + 3, qos: .userInteractive) {
							respring()
						}
					} else {
						NotificationCenter.default.post(
							name: notifierName,
							object: ActivationUpdate.status(.failure)
						)
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

@_cdecl("runDrm")
public dynamic func runDrm() {
	#if DRM
		if DRM.ticketAuthorized() {
			return
		}
		ActivationView.setup()
		#if TRIAL
			if let ticket = DRM.ticket, !ticket.validTime(), ticket.isSignatureValid() {
				return
			}
		#endif
		#if DEBUG
			NSLog("Lucient: running DRM...")
		#endif
		DispatchQueue.main.async(qos: .userInitiated) {
			DRM.requestTicket()
		}
	#endif
}

@_cdecl("isValidated")
public dynamic func isValidated() -> Bool {
	#if DRM
		return DRM.ticketAuthorized()
	#else
		return true
	#endif
}
