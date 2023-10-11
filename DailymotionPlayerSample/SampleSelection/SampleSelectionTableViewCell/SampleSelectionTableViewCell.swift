import UIKit

class SampleSelectionTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "SampleSelectionTableViewCell"
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var mainContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainContainerView.layer.cornerRadius = 9
        mainContainerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        mainContainerView.layer.shadowOpacity = 1
        mainContainerView.layer.shadowRadius = 10
        mainContainerView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
