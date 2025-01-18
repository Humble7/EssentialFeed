//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by ChenZhen on 18/1/25.
//

import Foundation
import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {

    var feedView: FeedView?
    var feedLoadingView: FeedLoadingView?
    
    func didStartLoadingFeed() {
        feedLoadingView?.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView?.display(FeedViewModel(feed: feed))
        feedLoadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        feedLoadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
}
