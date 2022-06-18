//
//  MockingURLProtocol.swift
//  AppleRepositoriesTests
//
//  Created by Udo Von Eynern on 18.06.22.
//

import Foundation
/**
 This class is for mocking the URL response for unit tests
 */
class MockingURLProtocol: URLProtocol {
    
    /// Here is the mocked data
    static var data: Data?
    
    /// Mocked error
    static var error: Error?
 
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
 
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
 
    override func startLoading() {
        if let data = Self.data {
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else if let error = Self.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
 
    override func stopLoading() {}
}
