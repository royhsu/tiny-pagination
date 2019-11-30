// MARK: - TableTests

import TinyPagination
import XCTest

final class TableTests: XCTestCase {
    
    var table: Table<Message>?

    override func setUp() {

        super.setUp()

        table = Table(
            contents: (0...5)
                .map { Message(text: "\($0)") }
        )

    }
    
    override func tearDown() {

        table = nil

        super.tearDown()

    }
    
    func testFetchRowsWithZeroOffset() {
        
        let didFetchRows = expectation(description: "Did fetch rows.")
        
        let stream = table!
            .fetch(FetchRequest(fetchCursor: TableCursor(offset: 0, limit: 1)))
            .sink(
                receiveCompletion: { completion in
                    
                    switch completion {
                     
                    case .finished: break
                    
                    case let .failure(error): XCTFail("\(error)")
                        
                    }
                    
                },
                receiveValue: { response in
                
                    defer { didFetchRows.fulfill() }
        
                    XCTAssertEqual(
                        response.elements,
                        [
                            TableRow(
                                cursor: TableCursor(offset: 0, limit: 1),
                                content: Message(text: "0")
                            ),
                        ]
                    )
                    
                    XCTAssertNil(response.previousPageCursor)
                
                }
            )
        
        waitForExpectations(timeout: 10.0)
        
    }
    
    func testFetchAllRowsAtOnce() {

        let didFetchRows = expectation(description: "Did fetch rows.")

        let stream = table!
            .fetch(FetchRequest())
            .sink(
                receiveCompletion: { completion in
                    
                    switch completion {
                     
                    case .finished: break
                    
                    case let .failure(error): XCTFail("\(error)")
                        
                    }
                    
                },
                receiveValue: { response in
                
                    defer { didFetchRows.fulfill() }
                    
                    XCTAssertEqual(
                        response.elements,
                        [
                            TableRow(
                                cursor: TableCursor(offset: 0, limit: 1),
                                content: Message(text: "0")
                            ),
                            TableRow(
                                cursor: TableCursor(offset: 1, limit: 1),
                                content: Message(text: "1")
                            ),
                            TableRow(
                                cursor: TableCursor(offset: 2, limit: 1),
                                content: Message(text: "2")
                            ),
                            TableRow(
                                cursor: TableCursor(offset: 3, limit: 1),
                                content: Message(text: "3")
                            ),
                            TableRow(
                                cursor: TableCursor(offset: 4, limit: 1),
                                content: Message(text: "4")
                            ),
                            TableRow(
                                cursor: TableCursor(offset: 5, limit: 1),
                                content: Message(text: "5")
                            ),
                        ]
                    )

                    XCTAssertNil(response.previousPageCursor)

                    XCTAssertNil(response.nextPageCursor)
                    
                }
            )

        waitForExpectations(timeout: 10.0)

    }
    
    func testFetchRowsFromMiddleOffset() {

        let didFetchRows = expectation(description: "Did fetch rows.")

        let stream = table!
            .fetch(FetchRequest(fetchCursor: TableCursor(offset: 3, limit: 2)))
            .sink(
                receiveCompletion: { completion in
                    
                    switch completion {
                     
                    case .finished: break
                    
                    case let .failure(error): XCTFail("\(error)")
                        
                    }
                    
                },
                receiveValue: { response in
                
                    defer { didFetchRows.fulfill() }

                    XCTAssertEqual(
                        response.elements,
                        [
                            TableRow(
                                cursor: TableCursor(offset: 3, limit: 1),
                                content: Message(text: "3")
                            ),
                            TableRow(
                                cursor: TableCursor(offset: 4, limit: 1),
                                content: Message(text: "4")
                            ),
                        ]
                    )
        
                    XCTAssertEqual(
                        response.previousPageCursor,
                        TableCursor(offset: 1, limit: 2)
                    )
        
                    XCTAssertEqual(
                        response.nextPageCursor,
                        TableCursor(offset: 5, limit: 1)
                    )
                
                }
            )
            
        waitForExpectations(timeout: 10.0)

    }

    func testFetchRowsWithInvalidOffset() {

        let didFail = expectation(description: "Did fail to fetch rows.")

        let stream = table!
            .fetch(FetchRequest(fetchCursor: TableCursor(offset: -1)))
            .sink(
                receiveCompletion: { completion in
                    
                    switch completion {
                     
                    case .finished: break
                    
                    case let .failure(error):
            
                        defer { didFail.fulfill() }
            
                        switch error {
            
                        case Table<Message>.FetchError.rowsNotFound(let cursor):
                            
                            XCTAssertEqual(cursor, TableCursor(offset: -1))

                        default:  XCTFail("Undefined error: \(error)")
            
                        }
                        
                    }
                    
                },
                receiveValue: { _ in XCTFail("Shouldn't receive reseponse.") }
            )
    
        waitForExpectations(timeout: 10.0)

    }
    
}

extension TableTests {
    
    static var allTests = [
        ("testFetchRowsWithZeroOffset", testFetchRowsWithZeroOffset),
        ("testFetchAllRowsAtOnce", testFetchAllRowsAtOnce),
        ("testFetchRowsFromMiddleOffset", testFetchRowsFromMiddleOffset),
        ("testFetchRowsWithInvalidOffset", testFetchRowsWithInvalidOffset),
    ]
    
}
