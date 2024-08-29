//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by ChenZhen on 29/8/24.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
