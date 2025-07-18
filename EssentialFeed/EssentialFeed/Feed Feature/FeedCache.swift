//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by ChenZhen on 18/12/24.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
