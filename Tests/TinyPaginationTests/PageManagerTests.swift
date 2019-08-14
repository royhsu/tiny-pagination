// MARK: - PageManagerTests

import XCTest

@testable import TinyPagination

final class PageManagerTests: XCTestCase {
    
    var manager: PageManager<TableRow<Message>, Error>?
    
    override func setUp() {
        
        super.setUp()
        
        manager = PageManager(
            service: Table<Message>(
                contents: (0...3)
                    .map { Message(text: "\($0)") }
            )
        )
        
    }
    
    override func tearDown() {
        
        manager = nil
        
        super.tearDown()
        
    }
    
    func testInitialize() {
        
        XCTAssertFalse(manager!.containsPreviousPage)
        
        XCTAssertFalse(manager!.containsNextPage)
        
    }
    
    func testFetchAllPages() {
        
        let didFetchStartPage = expectation(description: "Did fetch the start page.")
        
        let didFetchPreviousPage = expectation(description: "Did fetch the previous page.")
        
        let didFetchNextPage = expectation(description: "Did fetch the next page.")
        
        manager!.fetch(
            .start(FetchRequest(fetchCursor: TableCursor(offset: 1, limit: 2))),
            completion: { result in
            
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
                    
                    XCTAssert(self.manager!.containsPreviousPage)
                    
                    XCTAssert(self.manager!.containsNextPage)
                    
                    didFetchStartPage.fulfill()
                    
                    self.manager!.fetch(.previous) { result in

                        do {
                            
                            let rows = try result.get()
                        
                            XCTAssertEqual(
                                rows,
                                [
                                    TableRow(
                                        cursor: TableCursor(offset: 0, limit: 1),
                                        content: Message(text: "0")
                                    ),
                                ]
                            )

                            XCTAssertFalse(self.manager!.containsPreviousPage)

                            XCTAssert(self.manager!.containsNextPage)

                            didFetchPreviousPage.fulfill()

                            self.manager!.fetch(.next) { result in

                                do {
                                
                                    let rows = try result.get()
                                    
                                    XCTAssertEqual(
                                        rows,
                                        [
                                            TableRow(
                                                cursor: TableCursor(offset: 3, limit: 1),
                                                content: Message(text: "3")
                                            ),
                                        ]
                                    )

                                    XCTAssertFalse(self.manager!.containsPreviousPage)

                                    XCTAssertFalse(self.manager!.containsNextPage)

                                    didFetchNextPage.fulfill()
                                    
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
    
    static var allTests = [
        ("testInitialize", testInitialize),
        ("testFetchAllPages", testFetchAllPages),
    ]
    
}
