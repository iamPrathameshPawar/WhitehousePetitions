//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Prathamesh Pawar on 3/22/25.
//

import Foundation

/// For each petitions title, body and signature count

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
