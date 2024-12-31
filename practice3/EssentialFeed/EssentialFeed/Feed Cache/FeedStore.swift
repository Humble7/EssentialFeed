//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by ChenZhen on 31/12/24.
//

import Foundation

public protocol FeedStore {
    typealias DeleteCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeleteCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping (Error?) -> Void)
}
