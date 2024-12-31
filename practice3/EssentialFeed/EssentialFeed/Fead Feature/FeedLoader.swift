//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by ChenZhen on 25/12/24.
//

import Foundation

public enum LoadFeedResult{
    case success([FeedImage])
    case failure(Error)
}
 
public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
