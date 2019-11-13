//
//  StoryViewModel.swift
//  Wattpad Assessment
//
//  Created by Saim Zahid on 2019-11-13.
//

import Foundation

protocol StoryViewModelProtocol {
    var title: String { get }
}

class StoryViewModel: StoryViewModelProtocol {
    private let story: Story
    
    init(_ story: Story) {
        self.story = story
    }
    
    var title: String {
        return story.title
    }
}
