//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by ChenZhen on 20/8/24.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
