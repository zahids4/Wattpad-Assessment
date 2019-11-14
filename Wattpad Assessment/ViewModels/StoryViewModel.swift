//
//  StoryViewModel.swift
//  Wattpad Assessment
//
//  Created by Saim Zahid on 2019-11-13.
//

import UIKit

enum ImageDownloadState {
  case new, downloaded, failed
}

typealias voidClosure = () -> ()

protocol StoryViewModelProtocol {
    var title: String { get }
    var authorText: String { get }
    var coverImage: UIImage { get set }
    var imageDownloadState: ImageDownloadState { get set }
    var shouldDownloadImage: Bool { get }
    func fetchCoverImage() -> Data?
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
    
    var imageDownloadState: ImageDownloadState = .new
    
    var shouldDownloadImage: Bool {
        imageDownloadState == .new && NetworkManager.shared.isConnectedToInternet
    }
    
    func fetchCoverImage() -> Data? {
        return getDataFromImageURL(story.coverImageUrl)
     }
}


extension StoryViewModel {
    func getDataFromImageURL(_ stringUrl: String) -> Data? {
        return try? Data(contentsOf: URL(string: stringUrl)!)
    }
}
