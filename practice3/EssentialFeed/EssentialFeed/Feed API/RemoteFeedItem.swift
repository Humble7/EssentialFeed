//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by ChenZhen on 31/12/24.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
