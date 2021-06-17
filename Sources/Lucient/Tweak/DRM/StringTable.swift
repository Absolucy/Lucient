import Foundation
import LucientC

internal func getStr(_ index: Int32) -> String {
    var str = String()
    st_get_bytes(UInt32(index)) { bytes, size in
        str.reserveCapacity(size - 1)
        str.append(String(bytesNoCopy: bytes!, length: size - 1, encoding: .utf8, freeWhenDone: true)!)
    }
    return str
}

internal func getList(_ index: Int32) -> [String] {
    getStr(index).split(separator: "$").map { String($0) }
}

internal func getData(_ index: Int32) -> Data {
    var data = Data()
    st_get_bytes(UInt32(index)) { bytes, size in
        defer { free(bytes) }
        data.reserveCapacity(size)
        data.append(Data(bytes: bytes!, count: size))
    }
    return data
}
