import Foundation
import Alamofire

fileprivate let storiesURL = "https://www.wattpad.com/api/v3/stories?offset=0&limit=10&fields=stories(id,title,cover,user)&filter=new"

protocol StoriesViewModelProtocol {
    var storiesCount: Int { get }
    func story(at index: Int) -> StoryViewModelProtocol
    func fetchStories()
}

protocol StoriesViewModelDelegate: class {
    func fetchComplete()
    func showAlert()
    func fetchFailed(_ error: AFError)
}

class StoriesViewModel: StoriesViewModelProtocol {
    weak var delegate: StoriesViewModelDelegate?
    
    init(delegate: StoriesViewModelDelegate) {
        self.delegate = delegate
    }
    
    var storiesCount: Int {
        return RealmStoriesManager.shared.getStories.count
    }
    
    func story(at index: Int) -> StoryViewModelProtocol {
        return RealmStoriesManager.shared.getStory(at: index)
    }

    func fetchStories() {
        guard NetworkManager.shared.isConnectedToInternet else { return }
        
        AF.request(storiesURL).responseDecodable(of: StoriesJSON.self) { response in
            switch response.result {
                case .success(let json):
                    RealmStoriesManager.shared.saveFetchedStories(json.stories)
                    self.delegate?.fetchComplete()
                    self.delegate?.showAlert()
                case .failure(let error):
                    self.delegate?.fetchFailed(error)
            }
        }
    }
}
