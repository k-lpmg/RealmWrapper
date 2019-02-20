import UIKit

extension UITableView {
    func registerWithCellReuseIdentifier<CellClass: UITableViewCell>(_ cellClass: CellClass.Type) {
        self.register(cellClass, forCellReuseIdentifier: cellClass.className)
    }
}
