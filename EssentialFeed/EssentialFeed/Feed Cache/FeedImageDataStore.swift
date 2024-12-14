//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by ChenZhen on 15/12/24.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
