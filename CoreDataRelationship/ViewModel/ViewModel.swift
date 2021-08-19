//
//  ViewModel.swift
//  CoreDataRelationship
//
//  Created by Windy on 19/08/21.
//

import Foundation

class ViewModel {
    
    @Published var games: [GameModel] = []
    
    private var localDataSource = CoreDataService()
    
    func retrieveData() {
        localDataSource.retrieveData { [weak self] games in
            self?.games = games
        }
    }
    
    func addRandomData() {
        
        let publishers = (0..<Int.random(in: 1..<5)).map { _ in
            PublisherModel(name: "Publisher \(Int.random(in: 0...100))")
        }
        
        let game = GameModel(
            name: "Game \(Int.random(in: 0...100))",
            publishers: publishers)
        
        localDataSource.addToCoreData(game: game) {
            self.games.append(game)
        }
    }
    
    func deleteData(with id: UUID) {
        localDataSource.deletaData(with: id) {
            self.games.removeAll(where: { $0.id == id })
        }
    }
}
