//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by ChenZhen on 15/1/25.
//

import Foundation
import EssentialFeed

protocol FeedImageView {
    associatedtype Image
    func display(_ viewModel: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    
    private let view: View
    private let imageTransfromer: (Data) -> Image?
    
    init(view: View, imageLoader: FeedImageDataLoader, imageTransfromer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransfromer = imageTransfromer
    }
    
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(description: model.description, location: model.location, isLoading: true, shouldRetry: false))
    }
    
    private struct InvalidImageDataError: Error {}
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransfromer(data) else {
            didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
            return
        }
        
        view.display(FeedImageViewModel(description: model.description, location: model.location, image: image, isLoading: false, shouldRetry: false))
    }
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewModel(description: model.description, location: model.location, image: nil, isLoading: false, shouldRetry: true))
    }
    
}
