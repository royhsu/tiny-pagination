// MARK: - PageManager

import OpenCombine

public final class PageManager<Element, Failure>
where
    Element: Fetchable,
    Failure: Error {

    private let service: AnyFetchableService<Element, Failure>
    
    public init<S>(service: S)
    where
        S: FetchableService,
        S.Element == Element,
        S.Failure == Failure { self.service = AnyFetchableService(service) }

    private var startPageFetchRequest: FetchRequest<Element>?

    private var previousPageCursor: Element.Cursor?
    
    /// Indicate whether the previous page exists.
    public var hasPreviousPage: Bool { previousPageCursor != nil }
    
    private var nextPageCursor: Element.Cursor?
    
    /// Indicate whether the next page exists.
    public var hasNextPage: Bool { nextPageCursor != nil }
    
    /// Indicate whether the manager is fetching.
    public var isFetching = false
    
    private var streams = Set<AnyCancellable>()
    
    /// Make sure to check if the `isFetching` was false before performing any new fetch request.
    /// By passing a new start page fetch request , the manager will reset the previous and next page states.
    ///
    /// - Note: Performing a previous / next page fetch request without a start page fetch request will result a crash.
    public func fetch(
        _ page: Page<Element>,
        completion: @escaping (Result<[Element], Failure>) -> Void
    ) {
        
        var response: FetchResponse<Element>?
        
        func handleFetchCompletion(
            _ fetchCompletion: Subscribers.Completion<Failure>
        ) {

            precondition(isFetching)

            isFetching = false
            
            switch fetchCompletion {
                
            case .finished:
                
                let response = response ?? FetchResponse(elements: []) // A publisher might complete without any response.
                
                switch page {
                
                case .start:
                    
                    previousPageCursor = response.previousPageCursor
                    
                    nextPageCursor = response.nextPageCursor
                    
                case .previous: previousPageCursor = response.previousPageCursor
                    
                case .next: nextPageCursor = response.nextPageCursor
                    
                }
                
                completion(.success(response.elements))
                
            case let .failure(error): completion(.failure(error))
                
            }
            
        }

        precondition(!isFetching)
        
        switch page {
            
        case let .start(fetchRequest):
            
            reset()
            
            precondition(startPageFetchRequest == nil)
            
            isFetching = true
            
            startPageFetchRequest = fetchRequest
            
            service
                .fetch(fetchRequest)
                .sink(
                    receiveCompletion: handleFetchCompletion,
                    receiveValue: { response = $0 }
                )
                .store(in: &streams)
            
        case .previous:
        
            if startPageFetchRequest == nil {
                
                preconditionFailure("No start fetch request.")
                
            }
            
            guard let previousPageCursor = previousPageCursor else {
                
                preconditionFailure("No previous page.")
                
            }
            
            isFetching = true
            
            service
                .fetch(FetchRequest(fetchCursor: previousPageCursor))
                .sink(
                    receiveCompletion: handleFetchCompletion,
                    receiveValue: { response = $0 }
                )
                .store(in: &streams)
            
        case .next:
            
            if startPageFetchRequest == nil {
                
                preconditionFailure("No start fetch request.")
                
            }
            
            guard let nextPageCursor = nextPageCursor else {
                
                preconditionFailure("No next page.")
                
            }
            
            isFetching = true
            
            service
                .fetch(FetchRequest(fetchCursor: nextPageCursor))
                .sink(
                    receiveCompletion: handleFetchCompletion,
                    receiveValue: { response = $0 }
                )
                .store(in: &streams)
            
        }
        
    }

    private func reset() {
        
        streams = []
        
        isFetching = false
        
        startPageFetchRequest = nil
        
        previousPageCursor = nil
        
        nextPageCursor = nil
        
    }
    
}
