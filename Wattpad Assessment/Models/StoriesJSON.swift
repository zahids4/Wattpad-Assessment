//
//  StoriesJSON.swift
//  Wattpad Assessment
//
//  Created by Saim Zahid on 2019-11-13.
//

import Foundation

public struct StoriesJSON: Decodable {
    public let stories: [Story]
    
    enum CodingKeys: String, CodingKey {
        case stories
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stories = try container.decode([Story].self, forKey: .stories)
    }
}
