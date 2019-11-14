import UIKit

class ImageDownloadOperations {
    lazy var downloadsInProgress: [IndexPath: DownloadOperation] = [:]
    lazy var operationQueue = OperationQueue()
}

class DownloadOperation: Operation {
    var storyViewModel: StoryViewModelProtocol
    
    init(_ storyViewModel: StoryViewModelProtocol) {
        self.storyViewModel = storyViewModel
    }
    
    override func main() {
        if isCancelled { return }
        
        guard let imageData = storyViewModel.fetchCoverImage() else { return }
        
        if isCancelled {
          return
        }
        
        if !imageData.isEmpty {
            storyViewModel.coverImage = UIImage(data:imageData)!
            storyViewModel.imageDownloadState = .downloaded
        } else {
            storyViewModel.imageDownloadState = .failed
        }
    }
    
}

