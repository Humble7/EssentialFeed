//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by ChenZhen on 25/1/25.
//

import XCTest
import EssentialFeed

class RemoteFeedImageDataLoader {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                completion(.failure(Error.invalidData))
            }
        }
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT()
        sut.loadImageData(from: url) { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadImageDataFromURL_requestDataFromURLTwice() {
        let url = anyURL()
        let (sut, client) = makeSUT()
        sut.loadImageData(from: url) { _ in }
        sut.loadImageData(from: url) { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_loadImageDataFromURL_deliverErrorOnClientError() {
        let clientError = NSError(domain: "a client error", code: 0)
        let (sut, client) = makeSUT()
        
        expected(sut, toCompleteWith: .failure(clientError)) {
            client.completeWithError(clientError)
        }
        
    }
    
    func test_loadImageDataFromURL_deliversInvalidDataOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expected(sut, toCompleteWith: failure(.invalidData)) {
                client.complete(withStatusCode: code, data: anyData(), at: index)
            }
        }
    }
    
    func test_loadImageDataFromURL_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let (sut, client) = makeSUT()
        
        expected(sut, toCompleteWith: failure(.invalidData)) {
            let emptyData = Data()
            client.complete(withStatusCode: 200, data: emptyData)
        }
    }
    
    private func makeSUT(url: URL = anyURL(), file: StaticString = #filePath, line: UInt = #line) -> (RemoteFeedImageDataLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private func failure(_ error: RemoteFeedImageDataLoader.Error) -> FeedImageDataLoader.Result {
        .failure(error)
    }
    
    private func expected(_ sut: RemoteFeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let url = anyURL()
        let exp = expectation(description: "Wait for load completion")
        sut.loadImageData(from: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url}
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func completeWithError(_ error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }
}
