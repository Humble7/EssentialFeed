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
        
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedViewController = storyboard.instantiateInitialViewController() as! FeedViewController
        let refreshController = feedViewController.refreshController!
        refreshController.delegate = feedPresentationAdapter
        
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
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: loader)
            let cellController = FeedImageCellController(delegate: adapter)
            let feedImagePresenter = FeedImagePresenter(view: WeakRefVirtualProxy(cellController), imageLoader: loader, imageTransfromer: UIImage.init)
            adapter.presenter = feedImagePresenter
            return  cellController
        }
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

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        object?.display(viewModel)
    }
}

private final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelete {
    
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

private final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView , Image>: FeedImageCellControllerDelete where View.Image == Image {
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    
    var presenter: FeedImagePresenter<View, Image>?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        task = self.imageLoader.loadImageData(from: self.model.url) {[weak self] result in
            switch result {
            case .success(let data):
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
            case .failure(let error):
                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }
    }
    
    func didCancelImageRequest() {
        task?.cancel()
    }
}
