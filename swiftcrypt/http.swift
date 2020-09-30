//
//  http.swift
//  Crypter
//
//  Created by david on 9/30/20.
//

import Foundation



public struct HTTPReq {
    enum Err : Error {
        case runtimeError(String)
    }

    func synchronous_request(url: String) throws -> String {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let (data, response, error) = URLSession.shared.synchronousDataTask(urlrequest: request)
        if let error = error {
            throw error
        }
        
        if let data = data,
            let urlContent = NSString(data: data, encoding: String.Encoding.ascii.rawValue) {
            return urlContent as String
        } else {
            throw Err.runtimeError("No data")
        }
    }
}

extension URLSession {
    func synchronousDataTask(urlrequest: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: urlrequest) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
}
