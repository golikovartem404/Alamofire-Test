//
//  APICaller.swift
//  Alamofire-Homework
//
//  Created by User on 02.11.2022.
//

import Foundation
import Alamofire

final class APICaller {

    static let shared = APICaller()

    enum Constants {
        static let privateKey = "46f8f85beb801c6c7484e6765ad8cc8fd95ba183"
        static let publicKey = "54ff82072c31c40d4ff3725f132e540d"
        static let ts = "1"
    }

    func getMarvelData(completion: @escaping(Result<Characters, Error>) -> ()) {
        AF.request("https://gateway.marvel.com/v1/public/characters?ts=1&apikey=54ff82072c31c40d4ff3725f132e540d&hash=cd7ccc0bc05ba33e0673b0c19849f49d")
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
}
