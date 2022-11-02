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

    private func getHash() -> String {
        let stringForHash = Constants.Keys.tsString + Constants.Keys.privateKey + Constants.Keys.publicKey
        return stringForHash.md5()
    }

    func getMarvelData(completion: @escaping(Result<Characters, Error>) -> ()) {
        AF.request("\(Constants.URL.marvelURL)?ts=\(Constants.Keys.tsString)&apikey=\(Constants.Keys.publicKey)&hash=\(getHash())")
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
        AF.request("\(Constants.URL.marvelURL)?name=\(hero)&ts=\(Constants.Keys.tsString)&apikey=\(Constants.Keys.publicKey)&hash=\(getHash())")
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
