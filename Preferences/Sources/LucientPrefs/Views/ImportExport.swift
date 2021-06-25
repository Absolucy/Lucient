//
//  ImportExport.swift
//
//
//  Created by Lucy on 6/24/21.
//

import SwiftUI

enum AlertType {
	case error(String)
	case success(String)
}

extension AlertType: Identifiable {
	var id: Int {
		switch self {
		case let .error(string):
			return string.hashValue
		case let .success(string):
			return string.hashValue
		}
	}
}

struct ImportExport: View {
	@State private var importUrl = ""
	@State private var importJson = ""
	@State private var alert: AlertType?
	@State private var downloading = false
	@State private var uploading = false
	@State private var downloadCheckmark = false
	@State private var jsonCheckmark = false
	@State private var pastebinCheckmark = false
	@State private var clipboardCheckmark = false

	private func downloadFromUrl() {
		guard let url = URL(string: importUrl) else {
			alert = .error("Invalid URL")
			return
		}
		downloading = true
		DispatchQueue.global().async {
			defer { downloading = false }
			do {
				let jsonData = try String(contentsOf: url).data(using: .utf8)!
				let preferences = try JSONDecoder().decode(PreferencesJson.self, from: jsonData)
				preferences.load()
				downloadCheckmark = true
			} catch {
				alert = .error(error.localizedDescription)
			}
		}
	}

	private func importFromJson() {
		do {
			let preferences = try JSONDecoder().decode(PreferencesJson.self, from: importJson.data(using: .utf8)!)
			preferences.load()
			jsonCheckmark = true
		} catch {
			alert = .error(error.localizedDescription)
		}
	}

	private func uploadToPastebin() {
		guard let json = try? JSONEncoder().encode(PreferencesJson.save()) else {
			alert = .error("BUG: failed to encode json")
			return
		}
		let encodedJson = String(data: json, encoding: .utf8)!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
		let urlStr =
			"https://pastebin.com/api/api_post.php"
		guard let url = URL(string: urlStr) else {
			alert = .error("BUG: url is invalid")
			return
		}
		var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
		urlRequest.httpMethod = "POST"
		urlRequest
			.httpBody =
			"api_dev_key=JZZLwF4pkYWXoOZAcxjsTqw8j2hDxY4P&api_option=paste&api_paste_format=json&api_paste_code=\(encodedJson)"
				.data(using: .utf8)!
		uploading = true
		URLSession(configuration: .ephemeral).dataTask(with: urlRequest) { data, _, error in
			defer { uploading = false }
			if let error = error {
				alert = .error(error.localizedDescription)
				return
			}
			guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
				alert = .error("Failed to get response from pastebin")
				return
			}
			if !responseString.starts(with: "https://pastebin.com/") {
				alert = .error("Pastebin Error: \(responseString)")
				return
			}
			let rawUrl = responseString.replacingOccurrences(of: "https://pastebin.com/", with: "https://pastebin.com/raw/")
			UIPasteboard.general.string = rawUrl
			alert = .success(rawUrl)
			pastebinCheckmark = true
		}.resume()
	}

	@ViewBuilder
	private func Checkmark(_ value: Binding<Bool>) -> some View {
		Image(systemName: "checkmark")
			.foregroundColor(.green)
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
					value.wrappedValue = false
				}
			}
	}

	var body: some View {
		Section(header: Text("Import / Export")) {
			HStack {
				TextField("Import from URL", text: $importUrl, onCommit: { downloadFromUrl() })
					.foregroundColor(downloading ? .gray : nil)
					.disabled(downloading)
				if downloading {
					ProgressView()
				} else if downloadCheckmark {
					Checkmark($downloadCheckmark)
				} else {
					Button(action: { downloadFromUrl() }) {
						Image(systemName: "square.and.arrow.down.on.square")
					}
				}
			}
			HStack {
				TextField("Import from JSON", text: $importJson, onCommit: { importFromJson() })
					.disabled(jsonCheckmark)
				if jsonCheckmark {
					Checkmark($jsonCheckmark)
				} else {
					Button(action: { importFromJson() }) {
						Image(systemName: "square.and.arrow.down")
					}
				}
			}
			HStack {
				Button(action: {
					uploadToPastebin()
				}) {
					Text("Export to pastebin")
				}.disabled(uploading || pastebinCheckmark)
				if uploading {
					Spacer()
					ProgressView()
				} else if pastebinCheckmark {
					Spacer()
					Checkmark($pastebinCheckmark)
				}
			}
			HStack {
				Button(action: {
					guard let json = try? JSONEncoder().encode(PreferencesJson.save()) else { return }
					UIPasteboard.general.string = String(data: json, encoding: .utf8)
					clipboardCheckmark = true
				}) {
					Text("Export to clipboard")
				}.disabled(clipboardCheckmark)
				if clipboardCheckmark {
					Spacer()
					Image(systemName: "checkmark")
						.foregroundColor(.green)
						.onAppear {
							DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
								clipboardCheckmark = false
							}
						}
				}
			}
		}.alert(item: $alert) { alert in
			switch alert {
			case let .error(error):
				return Alert(
					title: Text("Error"),
					message: Text("\(error)"),
					dismissButton: .default(Text("Ok")) {
						self.alert = nil
					}
				)
			case let .success(string):
				return Alert(
					title: Text("Uploaded!"),
					message: Text("Your configuration is available at \(string).\nThis URL has been copied to your clipboard."),
					dismissButton: .default(Text("Ok")) {
						self.alert = nil
					}
				)
			}
		}
	}
}
