//
//  GameModel.swift
//  CoreDataRelationship
//
//  Created by Windy on 19/08/21.
//

import Foundation

struct GameModel: Hashable {
    var id = UUID()
    var name: String
    var publishers: [PublisherModel]
}
