import Foundation
import LucientC

internal enum AuthResponse {
	case error
	case denied
	case success(AuthorizationTicket)
}

internal func contactServer(_ callback: @escaping (AuthResponse) -> Void) {
	let session = URLSession(
		configuration: URLSessionConfiguration.ephemeral,
		delegate: nil,
		delegateQueue: nil
	)
	guard let url = URL(string: getStr(DRM_ENDPOINT)) else {
		#if DEBUG
			NSLog(String(format: "[Lucient] \"%s\" is not a valid URL!", getStr(DRM_ENDPOINT)))
		#endif
		callback(.error)
		return
	}
	var request = URLRequest(url: url)
	request.httpMethod = "POST"
	guard let json = try? JSONEncoder().encode(AuthorizationRequest()) else {
		callback(.error)
		return
	}
	request.timeoutInterval = 15
	request.httpBody = json
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	request.setValue(String(format: "%d", json.count), forHTTPHeaderField: "Content-Length")
	for (name, value) in DeviceInfo.instance.headers() {
		request.setValue(value, forHTTPHeaderField: name)
	}
	#if DEBUG
		if getStr(DRM_ENDPOINT).contains("staging") {
			request.setValue("127.0.0.1", forHTTPHeaderField: "CF-Connecting-Ip")
			request.setValue("XX", forHTTPHeaderField: "CF-IpCountry")
		}
	#endif

	session.dataTask(with: request) { data, response, error in
		if let error = error {
			#if DEBUG
				NSLog("[Lucient] DRM server errored with \(error.localizedDescription)")
			#endif
			callback(.error)
			return
		}
		if let httpResponse = response as? HTTPURLResponse {
			#if DEBUG
				NSLog("[Lucient] DRM server responded with code \(httpResponse.statusCode)")
			#endif
			if httpResponse.statusCode == 401 {
				callback(.denied)
				return
			} else if httpResponse.statusCode != 200 {
				callback(.error)
				return
			}
		}
		guard let data = data, let ticket = try? JSONDecoder().decode(AuthorizationTicket.self, from: data) else {
			callback(.error)
			return
		}
		#if DEBUG
			NSLog("[Lucient] DRM server response: \(String(data: data, encoding: .utf8)!)")
		#endif
		callback(.success(ticket))
	}.resume()
}
