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
    func fetchFailed(_ error: AFError)
}

class StoriesViewModel: StoriesViewModelProtocol {
    weak var delegate: StoriesViewModelDelegate?
    
    init(delegate: StoriesViewModelDelegate) {
        self.delegate = delegate
    }
    
    private var stories: [StoryViewModelProtocol] = []
    
    var storiesCount: Int {
        return stories.count
    }
    
    func story(at index: Int) -> StoryViewModelProtocol {
        return stories[index]
    }

    func fetchStories() {
        AF.request(storiesURL).responseDecodable(of: StoriesJSON.self) { response in
            switch response.result {
                case .success(let json):
                    self.stories = json.getStoryViewModels()
                    self.delegate?.fetchComplete()
                case .failure(let error):
                    self.delegate?.fetchFailed(error)
            }
        }
    }
}
