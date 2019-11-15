import Foundation
import RealmSwift

class RealmStoriesManager {
    private init() {}
    static let shared = RealmStoriesManager()
    
    func saveFetchedStories(_ stories: [Story], closure: @escaping () -> ()) {
        let realm = try! Realm()
        let listOfStories = List<Story>()
        stories.forEach({ listOfStories.append($0) })
        
        try! realm.write {
            realm.add(listOfStories, update: .modified)
        }
        
        closure()
    }
    
    func deleteAllStories() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    var allStories: Results<Story> {
        let realm = try! Realm()
        return realm.objects(Story.self)
    }
}
