//
//  APIResponse.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 07.09.2024.
//

import Foundation

struct APIResponse: Codable {
    let results: [ResposeResult]
}

struct ResposeResult: Codable {
    let id: String
    let created_at: Date
    let width: Int
    let height: Int
    let description: String?
    let user: User
    let urls: Urls
    let links: Links
}

struct Urls: Codable {
    let small: String
}

struct Links: Codable {
    let download: String
}

struct User: Codable {
    let name: String?
}
