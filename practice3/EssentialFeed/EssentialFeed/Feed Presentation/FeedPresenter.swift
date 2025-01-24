//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by ChenZhen on 25/1/25.
//

import Foundation

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    private let feedView: FeedView
    private let feedLoadingView: FeedLoadingView

    public init(feedView: FeedView, feedLoadingView: FeedLoadingView) {
        self.feedView = feedView
        self.feedLoadingView = feedLoadingView
    }
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }
    
    public func didStartLoadingFeed() {
        feedLoadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
