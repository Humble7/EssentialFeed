//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by ChenZhen on 14/1/25.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedPresenter = FeedPresenter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(loadFeed: feedPresenter.loadFeed)
        let feedViewController = FeedViewController(refreshController: refreshController)
        feedPresenter.feedLoadingView = WeakRefVirtualProxy(refreshController)
        feedPresenter.feedView = FeedViewAdapter(controller: feedViewController, loader: imageLoader)
        return feedViewController
    }
}

private final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let loader: FeedImageDataLoader
    init(controller: FeedViewController, loader: FeedImageDataLoader) {
        self.controller = controller
        self.loader = loader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let feedImageViewModel = FeedImageViewModel(model: model, imageLoader: loader, imageTransfromer: UIImage.init)
            return FeedImageCellController(viewModel: feedImageViewModel) }
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}
