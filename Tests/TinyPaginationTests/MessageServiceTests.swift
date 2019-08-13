// MARK: - MessageServiceTests

import TinyPagination
import XCTest

//final class MessageServiceTests: XCTestCase {
//    
//    var service: MessageService?
//    
//    override func setUp() {
//        
//        super.setUp()
//        
//        service = MessageService(
//            messages: (0...5)
//                .map { Message(text: "\($0)") }
//        )
//        
//    }
//    
//    override func tearDown() {
//        
//        service = nil
//        
//        super.tearDown()
//        
//    }
//    
//    func testFetchMessages() {
//        
//        let didFetchMessages = expectation(description: "Did fetch messages.")
//        
//        service!.fetch(FetchRequest()) { result in
//            
//            let content = try? result.get()
//            
//            XCTAssertEqual(
//                content?.elements,
//                [
//                    Message(text: "0"),
//                    Message(text: "1"),
//                    Message(text: "2"),
//                    Message(text: "3"),
//                    Message(text: "4"),
//                    Message(text: "5"),
//                ]
//            )
//            
//            XCTAssertNil(content?.previousCursor)
//            
//            XCTAssertNil(content?.nextCursor)
//            
//            didFetchMessages.fulfill()
//            
//        }
//        
//        waitForExpectations(timeout: 10.0)
//        
//    }
//    
//    func testFetchMessagesFromMiddleOffset() {
//        
//        let didFetchMessages = expectation(description: "Did fetch messages.")
//        
//        service!.fetch(FetchRequest(fetchCursor: TableCursor(offset: 4, limit: 2)) { result in
//            
//            let content = try? result.get()
//            
//            XCTAssertEqual(
//                content?.elements,
//                [
//                    Message(text: "3"),
//                    Message(text: "4"),
//                ]
//            )
//            
//            XCTAssertEqual(content?.previousCursor, TableCursor(offset: 1, limit: 2))
//            
//            XCTAssertEqual(content?.nextCursor, TableCursor(offset: 5, limit: 1))
//            
//            didFetchMessages.fulfill()
//            
//        }
//        
//        waitForExpectations(timeout: 10.0)
//        
//    }
//    
//    func testFetchMessagesWithNonExistingOffset() {
//        
//        let didFail = expectation(description: "Did fail to fetch messages.")
//        
//        service!.fetch(FetchRequest(fetchCursor: TableCursor(offset: -1))) { result in
//            
//            do {
//                
//                _ = try result.get()
//                
//                XCTFail()
//                
//            }
//            catch MessageService.FetchError.notFound(let cursor) {
//
//                XCTAssertEqual(cursor, .init(offset: -1))
//                
//            }
//            catch { XCTFail("Undefined error: \(error)") }
//            
//            didFail.fulfill()
//            
//        }
//        
//        waitForExpectations(timeout: 10.0)
//        
//    }
//    
//    static var allTests = [
//        ("testFetchMessages", testFetchMessages),
//        ("testFetchMessagesFromMiddleOffset", testFetchMessagesFromMiddleOffset),
//        ("testFetchMessagesWithNonExistingOffset", testFetchMessagesWithNonExistingOffset),
//    ]
//    
//}
