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
        DispatchQueue.main.async {
            if self.isCancelled { return }
            
            guard let imageData = self.storyViewModel.fetchCoverImage() else { return }
            
            if self.isCancelled { return }
            
            if !imageData.isEmpty {
                self.storyViewModel.coverImage = UIImage(data:imageData)!
                self.storyViewModel.imageDownloadState = .downloaded
            } else {
                self.storyViewModel.imageDownloadState = .failed
            }
        }
    }
    
}

