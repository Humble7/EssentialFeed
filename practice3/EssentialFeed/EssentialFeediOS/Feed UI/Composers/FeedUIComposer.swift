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
        
        let feedPresentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(delegate: feedPresentationAdapter)
        let feedViewController = FeedViewController(refreshController: refreshController)
        
        let feedPresenter = FeedPresenter(feedView: FeedViewAdapter(controller: feedViewController, loader: imageLoader), feedLoadingView: WeakRefVirtualProxy(refreshController))
        feedPresentationAdapter.presenter = feedPresenter
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

private final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelete {
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        feedLoader.load { [weak self] result in
            switch result {
            case .success(let feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case .failure(let error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
            
        }
    }
}
