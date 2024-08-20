//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by ChenZhen on 20/8/24.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
