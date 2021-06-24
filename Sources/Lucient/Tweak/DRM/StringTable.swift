import Foundation
import LucientC

internal func getStr(_ index: Int32) -> String {
	guard let decrypted = st_get(UInt32(index)) else { return "" }
	defer { free(decrypted) }
	return String(cString: decrypted, encoding: .utf8) ?? ""
}

internal func getList(_ index: Int32) -> [String] {
	getStr(index).split(separator: "$").map { String($0) }
}

internal func getData(_ index: Int32) -> Data {
	let decrypted = st_get_bytes(UInt32(index))
	return Data(bytesNoCopy: decrypted.data, count: Int(decrypted.length), deallocator: .free)
}
