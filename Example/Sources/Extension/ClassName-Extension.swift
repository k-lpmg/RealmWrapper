import Foundation

protocol ClassName {
    static var className: String { get }
}

// Swift Objects
extension ClassName {
    
    static var className: String {
        return String(describing: self).components(separatedBy: " ").first!
    }
    
}

// Bridge to Obj-C
extension NSObject: ClassName {
    
    class var className: String {
        return String(describing: self).components(separatedBy: " ").first!
    }
    
}
