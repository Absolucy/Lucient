import Foundation
import LucientC

internal func getStr(_ index: Int32) -> String {
	var str = String()
	let decrypted = st_get_bytes(UInt32(index))
	str.reserveCapacity(Int(decrypted.length) - 1)
	str
		.append(String(bytesNoCopy: decrypted.data, length: Int(decrypted.length) - 1, encoding: .utf8, freeWhenDone: true)!)
	return str
}

internal func getList(_ index: Int32) -> [String] {
	getStr(index).split(separator: "$").map { String($0) }
}

internal func getData(_ index: Int32) -> Data {
	var data = Data()
	let decrypted = st_get_bytes(UInt32(index))
	defer { free(decrypted.data) }
	data.reserveCapacity(Int(decrypted.length))
	data.append(Data(bytes: decrypted.data, count: Int(decrypted.length)))
	return data
}
