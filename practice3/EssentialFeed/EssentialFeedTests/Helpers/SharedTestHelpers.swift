//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by ChenZhen on 1/1/25.
//

import Foundation
import EssentialFeed

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
