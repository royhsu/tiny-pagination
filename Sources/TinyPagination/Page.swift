// MARK: - Page

public enum Page<Element> where Element: Fetchable {

    case start(FetchRequest<Element>)
    
    case previous
    
    case next

}
