//
//  DownloadItem.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 07.09.2024.
//

import Foundation

final class DownloadItem {
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var imageDTO: SearchResultImageDTO

    init(image: SearchResultImageDTO) {
        imageDTO = image
    }
}
