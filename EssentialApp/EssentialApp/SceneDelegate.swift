//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by ChenZhen on 15/12/24.
//

import UIKit
import CoreData
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let session = URLSession(configuration: .ephemeral)
        let remoteClient = URLSessionHTTPClient(session: session)
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let localStoreURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
        
        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        let feedViewController = FeedUIComposer.feedComposedWith(feedLoader: FeedLoaderWithFallbackComposite(primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader, cache: localFeedLoader), fallback: localFeedLoader), imageLoader: FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader, fallback: FeedImageDataLoaderCacheDecorator(decoratee: remoteImageLoader, cache: localImageLoader)))
        window?.rootViewController = feedViewController
    }

    

}

