//
//  StoryTableViewCell.swift
//  Wattpad Assessment
//
//  Created by Saim Zahid on 2019-11-13.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with story: StoryViewModelProtocol) {
        titleLabel.text = story.title
    }
}
