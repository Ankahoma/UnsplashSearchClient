//
//  NetworkError.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 07.09.2024.
//

import Foundation

struct NetworkError: Error {
    let code: Int
    let description: String
}
