//
//  Constants.swift
//  Alamofire-Homework
//
//  Created by User on 02.11.2022.
//

import Foundation
import UIKit

enum Constants {

    enum Keys {
        static let privateKey = "46f8f85beb801c6c7484e6765ad8cc8fd95ba183"
        static let publicKey = "54ff82072c31c40d4ff3725f132e540d"
        static let tsString = "1"
    }

    enum URL {
        static let marvelURL = "https://gateway.marvel.com/v1/public/characters"
    }

    enum Strings {


        enum CellIdentifiers {
            static let marvelHeroCell = "MarvelTableViewCell"
            static let comicsItemCell = "cell"
        }

        enum NavigationBarTitles {
            static let mainViewController = "Marvel Heroes"
        }

        enum ButtonsTitles {
            static let search = "Search"
        }

        enum TextFieldPlaceholders {
            static let search = "Search a Hero"
        }

        enum AlertTitles {
            static let error = "Error"
            static let warning = "Warning"
        }

        enum AlertMessages {
            static let enterName = "Please enter a hero name"
            static let loadingError = "Error while image loading"
        }
    }

    enum Colors {
        static let buttonColor = UIColor.systemGray3
    }
}
