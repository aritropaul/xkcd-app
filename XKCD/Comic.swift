//
//  Comic.swift
//  XKCD
//
//  Created by Aritro Paul on 30/05/21.
//

import Foundation

struct Comic: Codable {
    var month: String
    var num: Int
    var link: String
    var year: String
    var news: String
    var safe_title: String
    var transcript: String
    var alt: String
    var img: String
    var title: String
    var day: String
}
