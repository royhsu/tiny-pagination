// MARK: - Fetchable

public protocol Fetchable {
    
    associatedtype Cursor: Equatable
    
    var cursor: Cursor { get }
    
}
