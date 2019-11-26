import Foundation
import Alamofire

fileprivate let storiesURL = "https://www.wattpad.com/api/v3/stories?offset=0&limit=10&fields=stories(id,title,cover,user)&filter=new"

protocol StoriesViewModelProtocol {
    var storiesCount: Int { get }
    func story(at index: Int) -> StoryViewModelProtocol
    func fetchStories(offset: String)
}

protocol StoriesViewModelDelegate: class {
    func fetchComplete()
    func showOfflineUsageAlert()
    func fetchFailed(_ error: AFError)
}

class StoriesViewModel: StoriesViewModelProtocol {
    weak var delegate: StoriesViewModelDelegate?
    
    private var stories: [StoryViewModelProtocol] = []
    
    init(delegate: StoriesViewModelDelegate) {
        self.delegate = delegate
    }
    
    let realmManager = RealmStoriesManager.shared
    
    var storiesCount: Int {
        return stories.count
    }
    
    func story(at index: Int) -> StoryViewModelProtocol {
        return stories[index]
    }

    func fetchStories(offset: String) {
        let url = "https://www.wattpad.com/api/v3/stories?offset=\(offset)&limit=10&fields=stories(id,title,cover,user)&filter=new"
        let setStoriesAndRefresh = {
            self.stories = self.realmManager.allStories.map({ StoryViewModel($0) })
            self.delegate?.fetchComplete()
        }
        
        guard NetworkManager.shared.isConnectedToInternet else {
            setStoriesAndRefresh()
            return
        }
        
        AF.request(url).responseDecodable(of: StoriesJSON.self) { response in
            switch response.result {
                case .success(let json):
                    self.realmManager.saveFetchedStories(json.stories) {
                        setStoriesAndRefresh()
                        self.delegate?.showOfflineUsageAlert()
                    }
                case .failure(let error):
                    self.delegate?.fetchFailed(error)
            }
        }
    }
}
