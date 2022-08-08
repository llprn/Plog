//토론 게시물 글 부분

import UIKit

class customDPostCell: UITableViewCell {
    
    @IBOutlet weak var dTitleLabel: UILabel!
    @IBOutlet weak var dUserLabel: UILabel!
    @IBOutlet weak var dPostImage: UIImageView!
    @IBOutlet weak var dContentLabel: UILabel!
    
    @IBOutlet weak var countIcon: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
