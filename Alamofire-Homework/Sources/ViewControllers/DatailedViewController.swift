//
//  DatailedViewController.swift
//  Alamofire-Homework
//
//  Created by User on 02.11.2022.
//

import UIKit
import Alamofire

class DetailedViewController: UIViewController {

    private var comics: [ComicsItem] = []

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var namelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var comicsLabel: UILabel = {
        let label = UILabel()
        label.text = "Comics"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var comicsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupLayout()
    }

    func setupHierarchy() {
        view.addSubview(imageView)
        view.addSubview(namelabel)
        view.addSubview(comicsLabel)
        view.addSubview(comicsTable)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 200),


            namelabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            namelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            comicsLabel.topAnchor.constraint(equalTo: namelabel.bottomAnchor, constant: 30),
            comicsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),

            comicsTable.topAnchor.constraint(equalTo: comicsLabel.bottomAnchor, constant: 20),
            comicsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comicsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comicsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func configureWith(model: Hero) {
        namelabel.text = model.name
        self.comics = model.comics.items
        let url = model.thumbnail.path + "." + model.thumbnail.thumbnailExtension
        AF.request(url)
            .validate()
            .responseDecodable(of: Data.self) { response in
                if let data = response.data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
    }
}

extension DetailedViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = comics[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
