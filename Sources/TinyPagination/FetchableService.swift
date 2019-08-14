// MARK: - FetchableService

public protocol FetchableService {
    
    associatedtype Element: Fetchable
    
    func fetch(
        _ request: FetchRequest<Element>,
        completion: @escaping (FetchResult<Element, Error>) -> Void
    )
    
}
