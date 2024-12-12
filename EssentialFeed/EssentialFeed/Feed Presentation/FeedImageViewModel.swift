//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by ChenZhen on 11/12/24.
//

import Foundation

public final class FeedImageViewModel<Image> {
    public typealias Observer<T> = (T) -> Void

    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?

    public init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }

    public var description: String? {
        return model.description
    }

    public var location: String?  {
        return model.location
    }

    public var hasLocation: Bool {
        return location != nil
    }

    public var onImageLoad: Observer<Image>?
    public var onImageLoadingStateChange: Observer<Bool>?
    public var onShouldRetryImageLoadStateChange: Observer<Bool>?

    public func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad? (image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }

    public func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
