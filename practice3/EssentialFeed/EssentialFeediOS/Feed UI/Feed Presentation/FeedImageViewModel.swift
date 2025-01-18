//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by ChenZhen on 18/1/25.
//

import Foundation

struct FeedImageViewModel<Image> {
    var description: String?
    var location: String?
    var image: Image?
    var isLoading: Bool
    var shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
