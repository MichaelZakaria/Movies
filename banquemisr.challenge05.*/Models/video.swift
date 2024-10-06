//
//  video.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-10-02.
//

import Foundation

struct VideoResponse: Codable {
    let id: Int
    let results: [Video]
}

struct Video: Codable {
    let name: String
    let key: String
    let site: String
    let type: String
}
