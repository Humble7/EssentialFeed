//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by ChenZhen on 20/8/24.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void)
}
