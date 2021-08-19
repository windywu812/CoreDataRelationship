//
//  Cell.swift
//  CoreDataRelationship
//
//  Created by Windy on 19/08/21.
//

import UIKit

class Cell: UITableViewCell {
    
    static let reuseIdentifier: String =  "Cell"
    
    private var titleLabel: UILabel!
    private var childStack: UIStackView!
    private var mainStack: UIStackView!
    
    func configureCell(game: GameModel) {
        titleLabel.text = game.name
        
        childStack = UIStackView()
        childStack.alignment = .leading
        childStack.axis = .vertical
        childStack.spacing = 2
        
        game.publishers.forEach({ publisher in
            let label = UILabel()
            label.text = publisher.name
            label.font = .preferredFont(forTextStyle: .subheadline)
            childStack.addArrangedSubview(label)
        })
        
        mainStack.addArrangedSubview(childStack)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        childStack.removeFromSuperview()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        
        mainStack = UIStackView(arrangedSubviews: [titleLabel])
        mainStack.spacing = 4
        mainStack.axis = .vertical
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

