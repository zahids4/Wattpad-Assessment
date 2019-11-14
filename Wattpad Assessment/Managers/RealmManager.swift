import Foundation
import RealmSwift

class RealmStoriesManager {
    private init() {}
    static let shared = RealmStoriesManager()
    
    func saveFetchedStories(_ stories: [Story]) {
        let realm = try! Realm()
        let listOfStories = List<Story>()
        stories.forEach({ listOfStories.append($0) })
        
        try! realm.write {
            realm.add(listOfStories)
        }
    }
    
    var getStories: Results<Story> {
        let realm = try! Realm()
        return realm.objects(Story.self)
    }
    
    func getStory(at index: Int) -> StoryViewModelProtocol {
        let story = getStories[index]
        return StoryViewModel(story)
    }
}
