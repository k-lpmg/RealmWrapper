import UIKit

extension UIViewController {
    func alert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if let actions = actions {
            actions.forEach({ (action) in
                alert.addAction(action)
            })
        }
        present(alert, animated: true, completion: completion)
    }
    
}
