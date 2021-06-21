import SwiftUI
import UIKit
import UniformTypeIdentifiers

@usableFromInline struct DocumentPicker: UIViewControllerRepresentable {
	@usableFromInline class Coordinator: NSObject {
		var parent: DocumentPicker
		var pickerController: UIDocumentPickerViewController
		var presented = false

		init(_ parent: DocumentPicker) {
			self.parent = parent
			pickerController = UIDocumentPickerViewController(forOpeningContentTypes: parent.contentTypes)

			// self.pickerController.allowsMultipleSelection = true
			// self.pickerController.directoryURL = URL()

			super.init()
			pickerController.delegate = self
		}
	}

	@Binding var isPresented: Bool
	var contentTypes: [UTType] // [kUTTypeFolder as String]
	var onCancel: () -> Void
	var onDocumentsPicked: (_: [URL]) -> Void

	@usableFromInline init(
		isPresented: Binding<Bool>,
		contentTypes: [UTType],
		onCancel: @escaping () -> Void,
		onDocumentsPicked: @escaping (_: [URL]) -> Void
	) {
		_isPresented = isPresented
		self.contentTypes = contentTypes
		self.onCancel = onCancel
		self.onDocumentsPicked = onDocumentsPicked
	}

	@usableFromInline func makeUIViewController(context _: Context) -> UIViewController {
		UIViewController()
	}

	@usableFromInline func updateUIViewController(_ presentingController: UIViewController, context: Context) {
		let pickerController = context.coordinator.pickerController
		if isPresented, !context.coordinator.presented {
			context.coordinator.presented.toggle()
			presentingController.present(pickerController, animated: true)
		} else if !isPresented, context.coordinator.presented {
			context.coordinator.presented.toggle()
			pickerController.dismiss(animated: true)
		}
	}

	@usableFromInline func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
}

extension DocumentPicker.Coordinator: UIDocumentPickerDelegate {
	@usableFromInline func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		parent.isPresented.toggle()
		parent.onDocumentsPicked(urls)
	}

	@usableFromInline func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
		parent.isPresented.toggle()
		parent.onCancel()
	}
}

internal extension View {
	@inlinable func documentPicker(
		isPresented: Binding<Bool>,
		contentTypes: [UTType] = [],
		onCancel: @escaping () -> Void = {},
		onDocumentsPicked: @escaping (_: [URL]) -> Void = { _ in }
	) -> some View {
		Group {
			self
			DocumentPicker(
				isPresented: isPresented,
				contentTypes: contentTypes,
				onCancel: onCancel,
				onDocumentsPicked: onDocumentsPicked
			)
		}
	}
}
