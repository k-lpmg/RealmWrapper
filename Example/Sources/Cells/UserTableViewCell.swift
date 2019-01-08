import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var model: User? {
        didSet {
            guard let model = model else {return}
            
            textLabel?.text = model.name
            detailTextLabel?.text = model.age.description
        }
    }
    
    // MARK: - Con(De)structor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
