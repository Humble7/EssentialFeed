//
//  RemoteFeedLoaderTests.swift
//  RemoteFeedLoaderTests
//
//  Created by ChenZhen on 20/8/24.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        _ = RemoteFeedLoader()
        let client = HTTPClient()
        XCTAssertNil(client.requestedURL)
    }

}
