//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by ChenZhen on 20/8/24.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
