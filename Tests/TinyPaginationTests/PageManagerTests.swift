// MARK: - PageManagerTests

import XCTest

@testable import TinyPagination

final class PageManagerTests: XCTestCase {
    
    func testInitialize() {
    
        let manager = PageManager(service: Table<Message>())
        
        XCTAssertFalse(manager.isFetching)
        
        XCTAssertFalse(manager.hasPreviousPage)
        
        XCTAssertFalse(manager.hasNextPage)
        
    }
    
    func testFetchAllPages() {
        
        let didFetchStartPage = expectation(description: "Did fetch the start page.")
        
        let didFetchPreviousPage = expectation(description: "Did fetch the previous page.")
        
        let didFetchNextPage = expectation(description: "Did fetch the next page.")
        
        let manager = PageManager(
            service: Table<Message>(
                contents: (0...3)
                    .map { Message(text: "\($0)") }
            )
        )
        
        XCTAssertFalse(manager.isFetching)
        
        manager.fetch(
            .start(FetchRequest(fetchCursor: TableCursor(offset: 1, limit: 2))),
            completion: { result in
                
                defer { didFetchStartPage.fulfill() }
                
                XCTAssertFalse(manager.isFetching)
                
                do {
                    
                    let rows = try result.get()
                    
                    XCTAssertEqual(
                        rows,
                        [
                            TableRow(
                                cursor: TableCursor(offset: 1, limit: 1),
                                content: Message(text: "1")
                            ),
                            TableRow(
                                cursor: TableCursor(offset: 2, limit: 1),
                                content: Message(text: "2")
                            ),
                        ]
                    )
                    
                    XCTAssert(manager.hasPreviousPage)
                    
                    XCTAssert(manager.hasNextPage)
                    
                    manager.fetch(.previous) { result in
                        
                        defer { didFetchPreviousPage.fulfill() }
                        
                        XCTAssertFalse(manager.isFetching)

                        do {
                            
                            let rows = try result.get()
                        
                            XCTAssertEqual(
                                rows,
                                [
                                    TableRow(
                                        cursor: TableCursor(
                                            offset: 0,
                                            limit: 1
                                        ),
                                        content: Message(text: "0")
                                    ),
                                ]
                            )

                            XCTAssertFalse(manager.hasPreviousPage)

                            XCTAssert(manager.hasNextPage)

                            manager.fetch(.next) { result in
                        
                                defer { didFetchNextPage.fulfill() }
                                
                                XCTAssertFalse(manager.isFetching)
                                
                                do {
                                
                                    let rows = try result.get()
                                    
                                    XCTAssertEqual(
                                        rows,
                                        [
                                            TableRow(
                                                cursor: TableCursor(
                                                    offset: 3,
                                                    limit: 1
                                                ),
                                                content: Message(text: "3")
                                            ),
                                        ]
                                    )

                                    XCTAssertFalse(manager.hasPreviousPage)

                                    XCTAssertFalse(manager.hasNextPage)

                                }
                                catch { XCTFail("\(error)") }

                            }
                            
                        }
                        catch { XCTFail("\(error)") }

                    }
                    
                }
                catch { XCTFail("\(error)") }
            
            }
        )
        
        waitForExpectations(timeout: 10.0)
        
    }
    
}

extension PageManagerTests {
    
    static var allTests = [
        ("testInitialize", testInitialize),
        ("testFetchAllPages", testFetchAllPages),
    ]
    
}
