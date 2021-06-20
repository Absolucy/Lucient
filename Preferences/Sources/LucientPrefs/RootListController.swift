import Cephei
import CepheiPrefs
import LucientPrefsC
import Preferences
import UIKit
import UniformTypeIdentifiers

class RootListController: HBRootListController, UIDocumentPickerDelegate {
	override var specifiers: NSMutableArray? {
		get {
			if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
				return specifiers
			} else {
				let specifiers = loadSpecifiers(fromPlistName: "Root", target: self)
				setValue(specifiers, forKey: "_specifiers")
				return specifiers
			}
		}
		set {
			super.specifiers = newValue
		}
	}

	let preferences = HBPreferences(identifier: "moe.absolucy.lucient")

	@objc func pickFile() {
		let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "ttf")!])
		picker.delegate = self
		present(picker, animated: true)
	}

	func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		preferences.set(urls[0].path, forKey: "customFont")
	}

	func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
		preferences.set(nil, forKey: "customFont")
	}
}
