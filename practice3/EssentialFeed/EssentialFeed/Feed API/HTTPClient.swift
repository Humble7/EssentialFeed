//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by ChenZhen on 27/12/24.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, completion: @escaping (Result) -> Void)
}
