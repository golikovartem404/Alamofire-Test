//
//  String + Ext.swift
//  Alamofire-Homework
//
//  Created by User on 02.11.2022.
//

import Foundation
import CryptoKit

 extension String {
     func md5() -> String {
         return Insecure.MD5.hash(data: self.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
     }
 }
