//
//  APICaller.swift
//  Alamofire-Homework
//
//  Created by User on 02.11.2022.
//

import Foundation
import Alamofire

final class NetworkService {

    static let shared = NetworkService()

    enum Constants {
        static let marvelURL = "https://gateway.marvel.com/v1/public/characters"
        static let privateKey = "46f8f85beb801c6c7484e6765ad8cc8fd95ba183"
        static let publicKey = "54ff82072c31c40d4ff3725f132e540d"
        static let ts = "1"
    }

    private func getHash() -> String {
        let stringForHash = Constants.ts + Constants.privateKey + Constants.publicKey
        return stringForHash.md5()
    }

    func getMarvelData(completion: @escaping(Result<Characters, Error>) -> ()) {
        AF.request("\(Constants.marvelURL)?ts=\(Constants.ts)&apikey=\(Constants.publicKey)&hash=\(getHash())")
          .validate()
          .responseDecodable(of: Characters.self) { (response) in
            guard let data = response.value else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
              completion(.success(data))
          }
    }

    func getInfoAboutMarvelHero(hero: String, completion: @escaping(Result<Characters, Error>) -> ()) {
        AF.request("\(Constants.marvelURL)?name=\(hero)&ts=\(Constants.ts)&apikey=\(Constants.publicKey)&hash=\(getHash())")
          .validate()
          .responseDecodable(of: Characters.self) { (response) in
            guard let data = response.value else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
              completion(.success(data))
          }
    }

    func getImage(fromURL url: String, completion: @escaping(Result<Data, Error>) -> ()) {
        AF.request(url)
            .validate()
            .responseDecodable(of: Data.self) { response in
                if let data = response.data {
                    completion(.success(data))
                } else if let error = response.error {
                    completion(.failure(error))
                }
            }
    }
}
