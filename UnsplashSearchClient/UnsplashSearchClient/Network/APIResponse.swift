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
    let urls: URLS
    let links: Links
}

struct URLS: Codable {
    let small: String
}

struct Links: Codable {
    let download: String
}



