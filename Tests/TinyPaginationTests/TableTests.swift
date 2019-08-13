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
        
        table!.fetch(FetchRequest(fetchCursor: TableCursor(offset: 0, limit: 1))) { result in
            
            do {
                
                let (rows, previousCursor, _) = try result.get()
                
                XCTAssertEqual(
                    rows,
                    [
                        TableRow(
                            cursor: TableCursor(offset: 0, limit: 1),
                            content: Message(text: "0")
                        ),
                    ]
                )
                
                XCTAssertNil(previousCursor)
                
            }
            catch { XCTFail("\(error)") }
            
            didFetchRows.fulfill()
            
        }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
    func testFetchAllRowsAtOnce() {

        let didFetchRows = expectation(description: "Did fetch rows.")

        table!.fetch(FetchRequest()) { result in
            
            do {

                let (rows, previousCursor, nextCursor) = try result.get()

                XCTAssertEqual(
                    rows,
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

                XCTAssertNil(previousCursor)

                XCTAssertNil(nextCursor)

                didFetchRows.fulfill()
                
            }
            catch { XCTFail("\(error)") }

        }

        waitForExpectations(timeout: 10.0)

    }
    
    func testFetchRowsFromMiddleOffset() {

        let didFetchRows = expectation(description: "Did fetch rows.")

        table!.fetch(
            FetchRequest(fetchCursor: TableCursor(offset: 3, limit: 2)),
            completion: { result in

                do {
                
                    let (rows, previousCursor, nextCursor) = try result.get()
                
                    XCTAssertEqual(
                        rows,
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
        
                    XCTAssertEqual(previousCursor, TableCursor(offset: 1, limit: 2))
        
                    XCTAssertEqual(nextCursor, TableCursor(offset: 5, limit: 1))
                    
                }
                catch { XCTFail("\(error)") }

                didFetchRows.fulfill()

            }
        )
        
        waitForExpectations(timeout: 10.0)

    }

    func testFetchRowsWithInvalidOffset() {

        let didFail = expectation(description: "Did fail to fetch rows.")

        table!.fetch(FetchRequest(fetchCursor: TableCursor(offset: -1))) { result in

            do {

                _ = try result.get()

                XCTFail()

            }
            catch Table<Message>.FetchError.notFound(let cursor) {

                XCTAssertEqual(cursor, .init(offset: -1))

            }
            catch { XCTFail("Undefined error: \(error)") }

            didFail.fulfill()

        }

        waitForExpectations(timeout: 10.0)

    }
    
    static var allTests = [
        ("testFetchRowsWithZeroOffset", testFetchRowsWithZeroOffset),
        ("testFetchAllRowsAtOnce", testFetchAllRowsAtOnce),
        ("testFetchRowsFromMiddleOffset", testFetchRowsFromMiddleOffset),
        ("testFetchRowsWithInvalidOffset", testFetchRowsWithInvalidOffset),
    ]
    
}
