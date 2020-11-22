//
//  HiringData.swift
//  Fetch Rewards
//
//  Created by Moazam Mir on 11/20/20.
//

import Foundation

struct HiringData : Codable {
    let id : Int
    let listId : Int
    let name : String?
}




//        guard let url = URL(string: urlString) else {return}
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {
//                return
//            }
//
//            let newStr = String(data: data, encoding: .utf8)
//          //  print(newStr)
//            let decoder = JSONDecoder()
//
//            guard let jsonPetitions = try? decoder.decode(Data.self, from: data) else {fatalError()}
//
//            print(jsonPetitions)
//
//
//
//
//
//            if let err = error{
//                print(err)
//            }
//        }.resume()
//
