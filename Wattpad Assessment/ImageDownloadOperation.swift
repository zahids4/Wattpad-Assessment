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
        if self.isCancelled { return }
        
        guard let imageData = self.storyViewModel.fetchCoverImage() else { return }
        
        if self.isCancelled { return }
        
        if !imageData.isEmpty {
            self.storyViewModel.coverImage = UIImage(data:imageData)!
            self.storyViewModel.imageDownloadState = .downloaded
        } else {
            // In a production app this control flow should show a button for the user
            // to re download the image
            self.storyViewModel.imageDownloadState = .failed
        }
    }
    
}

