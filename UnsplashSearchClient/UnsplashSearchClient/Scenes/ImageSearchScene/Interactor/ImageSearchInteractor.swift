//
//  ImageSearchInteractor.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

protocol IImageSearchInteractor {
    var uiUpdater: IImageSearchViewUpdateDelegate? { get set }
    func newSearchStarted()
    func requestData(with searchQuery: String, pageNumber: Int, completion: @escaping ([SearchResultImageDTO]?, Error?) -> Void)
    func getDownloadItem(for imageObject: SearchResultImageDTO) -> DownloadItem?

    func startDownload(_ image: SearchResultImageDTO)
    func pauseDownload(_ image: SearchResultImageDTO)
    func resumeDownload(_ image: SearchResultImageDTO)
    func cancelDownload(_ image: SearchResultImageDTO)

    func getDownloadedImage(with id: String, completion: @escaping (UIImage?, Error?) -> Void)
}

final class ImageSearchInteractor: NSObject {
    private let downloadService: DownloadService
    private let networkService: INetworkService
    private let dataService: IImageSearchDataService

    private let queryResultTotalPages: Int = 20
    private var query: String = ""

    weak var uiUpdater: IImageSearchViewUpdateDelegate?

    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier:
            "backgroundSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    private var results: [ResposeResult] = []
    private var imagesDTO: [SearchResultImageDTO] = []

    init(downloadService: DownloadService, networkService: INetworkService, dataService: IImageSearchDataService) {
        self.downloadService = downloadService
        self.networkService = networkService
        self.dataService = dataService
    }
}

extension ImageSearchInteractor: IImageSearchInteractor {
    func newSearchStarted() {
        imagesDTO = []
    }

    func requestData(with searchQuery: String, pageNumber: Int, completion: @escaping ([SearchResultImageDTO]?, Error?) -> Void) {
        guard pageNumber <= queryResultTotalPages else { return }
        query = searchQuery
        networkService.getSearchResults(searchQuery: searchQuery, pageNumber: pageNumber) { [weak self] response in

            switch response {
            case let .success(data):
                do {
                    let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                    self?.results = jsonResult.results

                    self?.getPreviewImages { image, error in

                        if let image = image, error == nil {
                            self?.imagesDTO.append(image)
                        }
                        completion(self?.imagesDTO, nil)
                    }
                } catch {
                    Notifier.imageSearchErrorOccured(message: "JSON Error: \(String(describing: error))")

                    return
                }
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    func getDownloadItem(for imageObject: SearchResultImageDTO) -> DownloadItem? {
        return downloadService.activeDownloads[imageObject.downloadUrl]
    }

    func startDownload(_ image: SearchResultImageDTO) {
        downloadService.downloadsSession = downloadsSession
        downloadService.startDownload(image)
    }

    func pauseDownload(_ image: SearchResultImageDTO) {
        downloadService.pauseDownload(image)
    }

    func resumeDownload(_ image: SearchResultImageDTO) {
        downloadService.resumeDownload(image)
    }

    func cancelDownload(_ image: SearchResultImageDTO) {
        downloadService.cancelDownload(image)
    }

    func getDownloadedImage(with id: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard imagesDTO.isEmpty == false else {
            completion(nil, NetworkError(code: 0, description: "Image not found"))
            return
        }
        let image = imagesDTO.first(where: { $0.id == id })
        completion(image?.image, nil)
    }
}

extension ImageSearchInteractor: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession _: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let completionHandler = appDelegate.backgroundSessionCompletionHandler
            {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}

extension ImageSearchInteractor: URLSessionDownloadDelegate {
    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo _: URL)
    {
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }

        let downloadItem = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil

        if let downloadItem = downloadItem {
            if let index = imagesDTO.firstIndex(where: { $0 == downloadItem.imageDTO }) {
                imagesDTO[index].downloaded = true
            }
            downloadItem.imageDTO.downloaded = true

            dataService.save(image: downloadItem.imageDTO)
            uiUpdater?.updateDownloadedItem(with: downloadItem.imageDTO)
            uiUpdater?.updateItem(id: downloadItem.imageDTO.id)
        }
    }

    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData _: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64)
    {
        guard
            let url = downloadTask.originalRequest?.url,
            let downloadItem = downloadService.activeDownloads[url]
        else {
            return
        }

        guard Float(totalBytesExpectedToWrite) > 0 else { return }
        downloadItem.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)

        uiUpdater?.updateProgress(itemId: downloadItem.imageDTO.id, progress: downloadItem.progress, totalSize: totalSize)
    }
}

private extension ImageSearchInteractor {
    func getPreviewImages(completion: @escaping (SearchResultImageDTO?, Error?) -> Void) {
        for result in results {
            networkService.getPreviewImage(with: result.urls.small) { image, error in
                if let image = image, error == nil {
                    guard let previewURL = URL(string: result.urls.small),
                          let downloadURL = URL(string: result.links.download) else { return }

                    let image = SearchResultImageDTO(id: result.id, previewUrl: previewURL, downloadUrl: downloadURL, cathegory: self.query, image: image)
                    completion(image, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }
}
