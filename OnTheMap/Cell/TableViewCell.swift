//
//  TableViewCell.swift
//  OnTheMap
//
//  Created by Khaled Shuwaish on 13/02/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
