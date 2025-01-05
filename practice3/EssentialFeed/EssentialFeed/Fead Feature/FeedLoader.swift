//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by ChenZhen on 25/12/24.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>
 
public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
