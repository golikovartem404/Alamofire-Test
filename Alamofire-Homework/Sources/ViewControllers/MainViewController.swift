//
//  ViewController.swift
//  Alamofire-Homework
//
//  Created by User on 02.11.2022.
//

import UIKit

class MainViewController: UIViewController {

    private var heroes: [Hero] = []

    private lazy var marvelHeroesTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(MarvelHeroTableViewCell.self, forCellReuseIdentifier: MarvelHeroTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        callAPI()
        title = "Marvel Heroes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupHierarchy() {
        view.addSubview(marvelHeroesTable)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            marvelHeroesTable.topAnchor.constraint(equalTo: view.topAnchor),
            marvelHeroesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            marvelHeroesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            marvelHeroesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func callAPI() {
        APICaller.shared.getMarvelData { result in
            switch result {
            case .success(let data):
                self.heroes = data.data.heroes
                self.marvelHeroesTable.reloadData()
            case .failure(let error):
                self.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
            }
        }
    }


}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MarvelHeroTableViewCell.identifier, for: indexPath) as? MarvelHeroTableViewCell else { return UITableViewCell() }
        cell.configure(with: heroes[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
