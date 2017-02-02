//
//  DataTableViewCell.swift
//  SwiftTableViewWithWS
//
//  Created by dharmesh  on 1/3/17.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblMainData: UILabel!
    @IBOutlet weak var activityIndicatoor: UIActivityIndicatorView!
    
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var isExpanded:Bool = false
        {
        didSet
        {
            if !isExpanded {
                self.imgHeightConstraint.constant = 0.0
                self.lblHeightConstraint.constant = 0.0
                
            } else {
                self.imgHeightConstraint.constant = 146.0
                self.lblHeightConstraint.constant = 21.0

            }
        }
    }

}
