// MARK: - FetchableService

import TinyCombine

public protocol FetchableService {
    
    associatedtype Element: Fetchable
    
    associatedtype Failure: Error
    
    func fetch(
        _ request: FetchRequest<Element>,
        completion: @escaping (FetchResult<Element, Failure>) -> Void
    )
    -> Cancellable
    
}
