//
//  MarvelHeroTableViewCell.swift
//  Alamofire-Homework
//
//  Created by User on 02.11.2022.
//

import UIKit
import Alamofire

class MarvelHeroTableViewCell: UITableViewCell {

    static let identifier = "MarvelTableViewCell"

    lazy var marvelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHierarchy() {
        addSubview(marvelImageView)
        addSubview(nameLabel)
        addSubview(symbolLabel)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            marvelImageView.topAnchor.constraint(equalTo: self.topAnchor),
            marvelImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            marvelImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            marvelImageView.widthAnchor.constraint(equalTo: self.heightAnchor),

            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: marvelImageView.trailingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            symbolLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            symbolLabel.leadingAnchor.constraint(equalTo: marvelImageView.trailingAnchor, constant: 15),
            symbolLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        marvelImageView.image = nil
        nameLabel.text = nil
        symbolLabel.text = nil
    }

    func configure(with model: Hero) {
        nameLabel.text = model.name
        symbolLabel.text = "Number os comics: \(model.comics.items.count)"
        let url = model.thumbnail.path + "." + model.thumbnail.thumbnailExtension
        if let data = model.imageData {
            marvelImageView.image = UIImage(data: data)
        } else if let marvelURL = URL(string: url) {
            AF.request(marvelURL)
                .validate()
                .responseDecodable(of: Data.self) { response in
                    if let data = response.data {
                        model.imageData = data
                        DispatchQueue.main.async {
                            self.marvelImageView.image = UIImage(data: data)
                        }
                    }
                }
        }
    }

}
