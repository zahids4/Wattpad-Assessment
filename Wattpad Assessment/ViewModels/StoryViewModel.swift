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
    private let coverImageUrl: String
    
    init(_ story: Story) {
        self.story = story
        // The coverImageUrl attributed is extracted out because I was running into threading issues with Realm
        // when I accessed it in the DownloadOperation class, because it wanted the operation to run on the same thread
        // as the thread that acessed the url which is the Main thread
        // that lead to laggy scrolling on the table view because the download was happening on the mian queue
        // this is the easiest way to solve that issue without creating a complex threading solution.
        self.coverImageUrl = story.coverImageUrl
    }
    
    var title: String {
        return story.title
    }
    
    var authorText: String {
        return "By: \(story.author)"
    }
    
    var coverImage: UIImage = UIImage()
    
    var imageDownloadState: ImageDownloadState = .new
    
    var shouldDownloadImage: Bool {
        imageDownloadState == .new && NetworkManager.shared.isConnectedToInternet
    }
    
    func fetchCoverImage() -> Data? {
        return try? Data(contentsOf: URL(string: coverImageUrl)!)
     }
}
