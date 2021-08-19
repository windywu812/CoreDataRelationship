//
//  ViewController.swift
//  CoreDataRelationship
//
//  Created by Windy on 19/08/21.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private var tableView: UITableView!
    private var refreshController: UIRefreshControl!
    
    var viewModel = ViewModel()
    var cancelables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        
        createBinding()
        viewModel.retrieveData()
    }
    
    private func createBinding() {
        viewModel.$games
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in self?.tableView.reloadData() })
            .store(in: &cancelables)
    }
    
    private func setupNavigation() {
        title = "Relationship Demo"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd(sender:)))
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        view.addSubview(tableView)
    }
    
    @objc
    private func handleAdd(sender: UIBarButtonItem) {
        viewModel.addRandomData()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.reloadRows(at: [indexPath], with: .fade)
            viewModel.deleteData(with: viewModel.games[indexPath.row].id)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as! Cell
        cell.configureCell(game: viewModel.games[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.games.count
    }
    
}

