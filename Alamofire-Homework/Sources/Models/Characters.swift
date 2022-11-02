//
//  Characters.swift
//  Alamofire-Homework
//
//  Created by User on 02.11.2022.
//

import Foundation

struct Characters: Codable {
    let data: Character
}

struct Character: Codable {
    let count: Int
    let heroes: [Hero]

    enum CodingKeys: String, CodingKey {
        case count
        case heroes = "results"
    }
}

class Hero: Codable {
    let id: Int
    let name: String
    let thumbnail: Thumbnail
    let comics: Comics
    var imageData: Data?
}

struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

struct Comics: Codable {
    let items: [ComicsItem]
}

struct ComicsItem: Codable {
    let name: String
}
