//
//  StoryViewModel.swift
//  Wattpad Assessment
//
//  Created by Saim Zahid on 2019-11-13.
//

import UIKit

protocol StoryViewModelProtocol {
    var title: String { get }
    var authorText: String { get }
    var coverImage: UIImage { get }
    var coverDownloaded: Bool { get }
}

class StoryViewModel: StoryViewModelProtocol {
    private let story: Story
    
    init(_ story: Story) {
        self.story = story
    }
    
    var title: String {
        return story.title
    }
    
    var authorText: String {
        return "By: \(story.author)"
    }
    
    var coverImage: UIImage = UIImage(systemName: "cloud")!
    
    var coverDownloaded: Bool {
        return coverImage != UIImage(systemName: "cloud")
    }
}
