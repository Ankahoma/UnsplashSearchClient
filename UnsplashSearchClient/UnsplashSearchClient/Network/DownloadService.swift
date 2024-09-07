//
//  DownloadService.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

final class DownloadService {
    
    var activeDownloads: [URL: DownloadItem] = [ : ]
    var downloadsSession: URLSession?
}

extension DownloadService {
    
    func startDownload(_ image: SearchResultImageDTO) {
        let downloadItem = DownloadItem(image: image)
        downloadItem.task = downloadsSession?.downloadTask(with: image.downloadUrl)
        downloadItem.task?.resume()
        downloadItem.isDownloading = true
        activeDownloads[downloadItem.imageDTO.downloadUrl] = downloadItem
    }
    
    func pauseDownload(_ image: SearchResultImageDTO) {
        guard let downloadItem = activeDownloads[image.downloadUrl],
              downloadItem.isDownloading else {
            return
        }
        
        downloadItem.task?.cancel(byProducingResumeData: { data in
            downloadItem.resumeData = data
        })
        
        downloadItem.isDownloading = false
        
    }
    
    func resumeDownload(_ image: SearchResultImageDTO) {
        guard let downloadItem = activeDownloads[image.downloadUrl] else {
            return
        }
        
        if let resumeData = downloadItem.resumeData {
            downloadItem.task = downloadsSession?.downloadTask(withResumeData: resumeData)
        } else {
            downloadItem.task = downloadsSession?.downloadTask(with: downloadItem.imageDTO.downloadUrl)
        }
        
        downloadItem.task?.resume()
        downloadItem.isDownloading = true
    }
    
    func cancelDownload(_ image: SearchResultImageDTO) {
        guard let downloadItem = activeDownloads[image.downloadUrl] else {
            return
        }
        downloadItem.task?.cancel()
        activeDownloads[image.downloadUrl] = nil
    }
}
