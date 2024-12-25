//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by ChenZhen on 25/12/24.
//

import XCTest

class HTTPClient {
    static let shared = HTTPClient()
    
    var requestedURL: URL?
}

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://example.com/feed")
    }
}


class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
