//
//  TinyUrlTableViewCell.swift
//  URLShortener
//
//  Created by Stéphanie Meusling on 20.03.19.
//  Copyright © 2019 smeusling. All rights reserved.
//

import Foundation
import UIKit

class TinyUrlTableViewCell: UITableViewCell {
    
    @IBOutlet var tinyUrlLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
