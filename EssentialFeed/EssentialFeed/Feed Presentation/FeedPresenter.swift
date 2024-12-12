//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by ChenZhen on 11/12/24.
//

import Foundation

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public struct FeedViewModel {
    public let feed: [FeedImage]
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}
 
public final class FeedPresenter {

    private let feedView: FeedView
    private let loadingView: FeedLoadingView

    public init(feedView: FeedView, loadingView: FeedLoadingView) {
        self.feedView = feedView
        self.loadingView = loadingView
    }
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                    tableName: "Feed",
                    bundle: Bundle(for: FeedPresenter.self),
                    comment: "Title for the feed view")
    }
 
    public func didStartLoadingFeed() {
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
