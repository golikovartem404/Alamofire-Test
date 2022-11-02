//
//  ViewController.swift
//  Alamofire-Homework
//
//  Created by User on 02.11.2022.
//

import UIKit

class MainViewController: UIViewController {

    private var heroes: [Hero] = []

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Search a Hero"
        textField.backgroundColor = .black
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

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
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(cancelButton)
        view.addSubview(marvelHeroesTable)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([

            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -30),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),

            searchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -25),

            cancelButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),

            marvelHeroesTable.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 30),
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

    @objc func searchButtonPressed() {

    }

    @objc func cancelButtonPressed() {
        searchTextField.text = ""
        callAPI()
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewCont = DetailedViewController()
        viewCont.configureWith(model: heroes[indexPath.row])
        present(viewCont, animated: true)
    }
}
