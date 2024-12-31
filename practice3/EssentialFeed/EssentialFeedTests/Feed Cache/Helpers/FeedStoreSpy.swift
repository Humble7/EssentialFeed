//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by ChenZhen on 1/1/25.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {

    enum ReceivedMessage: Equatable {
        case deleteCacheFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    var deleteCompletions = [DeleteCompletion]()
    var insertionCompletions = [InsertionCompletion]()
    var retrievalCompletions = [RetrievalCompletion]()
    
    var receivedMessages = [ReceivedMessage]()
    
    func deleteCachedFeed(completion: @escaping DeleteCompletion) {
        receivedMessages.append(.deleteCacheFeed)
        deleteCompletions.append(completion)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping (Error?) -> Void) {
        receivedMessages.append(.insert(feed, timestamp))
        insertionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error?, at index: Int = 0) {
        deleteCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deleteCompletions[index](nil)
    }
    
    func completeInsertion(with error: Error?, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        receivedMessages.append(.retrieve)
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error?, at index: Int = 0) {
        retrievalCompletions[index](error)
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](nil)
    }
    
}

