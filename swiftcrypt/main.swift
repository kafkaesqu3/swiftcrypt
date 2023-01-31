import Foundation

// IV =  16 bytes for AES128
// Key = 32 bytes

func readKey() -> [UInt8] {
    let fileURL = URL(fileURLWithPath: "/Users/david/jquery.png")
    var byteArray: [UInt8] = []
    do {
        let fileData = try Data(contentsOf: fileURL)
        byteArray = [UInt8](fileData)
    } catch {
        // Handle the error

    }
    // at offset 20 - get 16 byte IV
    let ivoffset = 20
    let ivsize = 16
    let iv = Array(byteArray[ivoffset..<ivoffset + ivsize])
   
    let keyoffset = ivoffset + ivsize
    let keysize = 32
    let key = Array(byteArray[keyoffset..<keyoffset + keysize])
    return iv + key
}

func encryptPayload(iv: [UInt8], key: [UInt8], cleartext: Data) -> Data?
{
    let aes256 = AES(key: key, iv: iv)
    let ciphertext = aes256?.encrypt(data: cleartext)
    return ciphertext
}

func decryptPayload(iv: [UInt8], key: [UInt8], ciphertext: Data) -> Data?
{
    let aes256 = AES(key: key, iv: iv)
    let cleartext = aes256?.decrypt(data: ciphertext)
    return cleartext
}

var byteArray = readKey()
let ivoffset = 0
let ivsize = 16
let iv = Array(byteArray[ivoffset..<ivoffset + ivsize])

let keyoffset = ivoffset + ivsize
let keysize = 32
let key = Array(byteArray[keyoffset..<keyoffset + keysize])

let string = "Hello, world!"
let data = Data(string.utf8)

var encrypted = encryptPayload(iv: iv, key: key, cleartext: data)!
if let decrypted = decryptPayload(iv: iv, key: key, ciphertext: encrypted) {
    let str = String(decoding: decrypted, as: UTF8.self)
    print(str)
    // Use decrypted as a non-optional Data instance
} else {
    // Handle the case where the function returned nil
}
