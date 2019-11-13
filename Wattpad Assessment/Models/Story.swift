//
//  Story.swift
//  Wattpad Assessment
//
//  Created by Saim Zahid on 2019-11-13.
//

import Foundation
import Realm
import RealmSwift

public class Story: Object, Decodable {
    @objc dynamic var id: String = "-1"
    @objc dynamic var title = ""
    @objc dynamic var coverImage = ""
    @objc dynamic var author = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case user
        case coverImage = "cover"
        case author = "name"
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let user = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
        author = try user.decode(String.self, forKey: .author)
        id  = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        coverImage = try container.decode(String.self, forKey: .coverImage)
    }
}
