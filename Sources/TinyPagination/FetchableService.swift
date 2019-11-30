// MARK: - FetchableService

import OpenCombine

public protocol FetchableService {
    
    associatedtype Element: Fetchable
    
    associatedtype Failure: Error
    
    func fetch(
        _ request: FetchRequest<Element>
    )
    -> AnyPublisher<FetchResponse<Element>, Failure>
    
}
