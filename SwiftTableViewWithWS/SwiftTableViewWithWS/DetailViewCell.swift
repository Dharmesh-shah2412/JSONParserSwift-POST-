//
//  DetailViewCell.swift
//  SwiftTableViewWithWS
//
//  Created by dharmesh  on 1/6/17.
//

import UIKit

class DetailViewCell: UITableViewCell {

    @IBOutlet weak var DetailImageView: UIImageView!
    @IBOutlet weak var LblDetail: UILabel!
    @IBOutlet weak var DetailProgressView: UIActivityIndicatorView!
    
    @IBOutlet weak var btnFb: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
