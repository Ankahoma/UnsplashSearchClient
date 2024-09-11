//
//  Date+Formatter.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 11.09.2024.
//

import Foundation

extension Date {
    func convert() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM y"
        return dateFormatter.string(from: self)
    }
}
