//
//  SocketStream.swift
//  ChatViewApp
//
//  Created by name on 18/05/2025.
//


//
//  URLSessionWebSocketTask.swift
//  ChatViewApp
//
//  Created by name on 18/05/2025.
//

import Foundation

// Convert from the normal web socket await message into a stram of messages
// If the connection is stablished and there is no error the web soket will yield any value it gets and it will recursion itself
public typealias WebSocketStream = AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>

class SocketStream: AsyncSequence {
    typealias AsyncIterator = WebSocketStream.Iterator
    typealias Element = URLSessionWebSocketTask.Message

    private var continuation: WebSocketStream.Continuation?
    private let task: URLSessionWebSocketTask

    
    // Make the stream and send the values to the user
    private lazy var stream: WebSocketStream = {
        return WebSocketStream { continuation in
            self.continuation = continuation

            Task {
                var isAlive = true

                while isAlive && task.closeCode == .invalid {
                    do {
                        let value = try await task.receive()
                        continuation.yield(value)
                    } catch {
                        continuation.finish(throwing: error)
                        isAlive = false
                    }
                }
            }
        }
    }()

    // get the web stream task and make resume for it
    init(task: URLSessionWebSocketTask) {
        self.task = task
        task.resume()
    }

    
    deinit {
        continuation?.finish()
    }

    func makeAsyncIterator() -> AsyncIterator {
        return stream.makeAsyncIterator()
    }

    // make the task cancel the connection
    func cancel() async throws {
        task.cancel(with: .goingAway, reason: nil)
        continuation?.finish()
    }
}

extension SocketStream {
    func send() {
    }
}
