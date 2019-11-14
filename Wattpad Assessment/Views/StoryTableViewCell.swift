//
//  StoryTableViewCell.swift
//  Wattpad Assessment
//
//  Created by Saim Zahid on 2019-11-13.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    func configure(with story: StoryViewModelProtocol) {
        titleLabel.text = story.title
        authorLabel.text = story.authorText
        coverImageView.image = story.coverImage
    }
}
