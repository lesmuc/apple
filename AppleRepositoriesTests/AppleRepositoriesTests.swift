//
//  AppleRepositoriesTests.swift
//  AppleRepositoriesTests
//
//  Created by Udo Von Eynern on 16.06.22.
//

import XCTest
import Combine

@testable import AppleRepositories

class AppleRepositoriesTests: XCTestCase {
    
    var viewModel = RepositoriesViewModel()
    
    var cancellables = Set<AnyCancellable>()
    
    func testFetchItemsWithoutMocking() {

        let expectation = self.expectation(description: "Fetch real data from Github and check for filled items and undefined error.")
        
        URLProtocol.unregisterClass(MockingURLProtocol.self)
        
        viewModel
            .$items
            .sink { repositories in
                
                guard !repositories.isEmpty else { return }
                
                XCTAssertFalse(repositories.isEmpty)
                XCTAssertNil(self.viewModel.error)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchItems()
        
        wait(for: [expectation], timeout: 5)
    }

    func testFetchItemsWithInvalidLocalJson() {

        let expectation = self.expectation(description: "Try to parse invalid local JSON and check for failed state.")
        
        MockingURLProtocol.data = "{\"id\": 1}".data(using: .utf8)
        URLProtocol.registerClass(MockingURLProtocol.self)
        
        viewModel
            .$loadingState
            .sink { state in
                
                if state == .failed {
                    XCTAssertTrue(self.viewModel.error != nil)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchItems()
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchItemsWithMockedError() {

        let expectation = self.expectation(description: "Try to fetch items but we have a mocked error.")
        
        MockingURLProtocol.error = RepositoriesViewModel.RequestError.failedRequest
        URLProtocol.registerClass(MockingURLProtocol.self)
        
        viewModel
            .$loadingState
            .sink { state in
                
                if state == .failed {
                    XCTAssertTrue(self.viewModel.error != nil)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchItems()
        
        wait(for: [expectation], timeout: 5)
    }
}
