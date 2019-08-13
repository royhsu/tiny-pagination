// MARK: - MessageService

import TinyPagination

struct MessageService {
    
    private var messageTable: Table<Message>
    
    init(messages: [Message]) { self.messageTable = Table(contents: messages) }
    
}

// MARK: - FetchableService

//extension MessageService: FetchableService {
//
//    func fetch(
//        _ request: FetchRequest<Message>,
//        completion: @escaping (FetchResult<Message, Error>) -> Void
//    ) {
//
//        messageTable.fetch(FetchRequest()) { result in
//
//
//
//        }
//
//    }
//
//}
