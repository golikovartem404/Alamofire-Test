//
//  ViewController.swift
//  Alamofire-Homework
//
//  Created by User on 02.11.2022.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Properties

    private var heroes: [Hero] = []

    // MARK: - Outlets

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search a Hero"
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.ButtonsTitles.search, for: .normal)
        button.setTitleColor(Constants.Colors.buttonColor, for: .normal)
        button.addTarget(
            self,
            action: #selector(searchButtonPressed),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = Constants.Colors.buttonColor
        button.addTarget(
            self,
            action: #selector(cancelButtonPressed),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var marvelHeroesTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(
            MarvelHeroTableViewCell.self,
            forCellReuseIdentifier: MarvelHeroTableViewCell.identifier
        )
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
        callAPI()
    }

    // MARK: - Setups

    private func setupNavigationBar() {
        title = "Marvel Heroes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupHierarchy() {
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(cancelButton)
        view.addSubview(marvelHeroesTable)
    }

    private func setupLayout() {
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

    private func callAPI() {
        NetworkService.shared.getMarvelData { [weak self] result in
            switch result {
            case .success(let data):
                self?.heroes = data.data.heroes
                self?.marvelHeroesTable.reloadData()
            case .failure(let error):
                self?.showAlert(
                    withTitle: Constants.Strings.AlertTitles.error,
                    andMessage: error.localizedDescription
                )
            }
        }
    }
}

// MARK: - Actions for buttons Extension

extension MainViewController {

    @objc func searchButtonPressed() {
        if let text = searchTextField.text, text != "" {
            let heroQuery = text.split(separator: " ").joined(separator: "%20")
            NetworkService.shared.getInfoAboutMarvelHero(hero: heroQuery) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.heroes = data.data.heroes
                    self?.marvelHeroesTable.reloadData()
                case .failure(let error):
                    print(error)
                    self?.showAlert(
                        withTitle: Constants.Strings.AlertTitles.error,
                        andMessage: error.localizedDescription
                    )
                }
            }
        } else {
            self.showAlert(
                withTitle: Constants.Strings.AlertTitles.warning,
                andMessage: Constants.Strings.AlertMessages.enterName
            )
        }
    }

    @objc func cancelButtonPressed() {
        if searchTextField.text != "" {
            searchTextField.text = ""
            searchTextField.endEditing(true)
            callAPI()
        } else {
            searchTextField.endEditing(true)
        }
    }
}

// MARK: - UITableView Extension

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

// MARK: - Cell Delegate Extension

extension MainViewController: CellDelegate {

    func showErrorAlert() {
        self.showAlert(
            withTitle: Constants.Strings.AlertTitles.error,
            andMessage: "Error while image loading"
        )
    }
}
