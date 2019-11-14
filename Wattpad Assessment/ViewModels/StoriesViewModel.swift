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

    func fetchStories() {
        let setStoriesAndRefresh = {
            self.stories = self.realmManager.getStories.map({ StoryViewModel($0) })
            self.delegate?.fetchComplete()
        }
        
        guard NetworkManager.shared.isConnectedToInternet else {
            setStoriesAndRefresh()
            return
        }
        
        AF.request(storiesURL).responseDecodable(of: StoriesJSON.self) { response in
            switch response.result {
                case .success(let json):
                    self.realmManager.saveFetchedStories(json.stories) {
                        setStoriesAndRefresh()
                        self.delegate?.showAlert()
                    }
                case .failure(let error):
                    self.delegate?.fetchFailed(error)
            }
        }
    }
}
