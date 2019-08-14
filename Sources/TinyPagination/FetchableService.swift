// MARK: - FetchableService

public protocol FetchableService {
    
    associatedtype Element: Fetchable
    
    associatedtype Failure: Error
    
    func fetch(
        _ request: FetchRequest<Element>,
        completion: @escaping (FetchResult<Element, Failure>) -> Void
    )
    -> FetchTask
    
}
