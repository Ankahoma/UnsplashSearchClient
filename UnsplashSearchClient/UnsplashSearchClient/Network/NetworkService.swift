//
//  NetworkService.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

protocol INetworkService {
    func getSearchResults(searchQuery: String, pageNumber: Int, completion: @escaping (Result<Data, NetworkError>) -> Void)
    func getPreviewImage(with query: String, completion: @escaping (UIImage?, Error?) -> Void )
}

final class NetworkService {
    private let urlSession = URLSession.shared
    private let id = "P443eo0J9RblgXX2FSGOQ_Ekm1L2iBq3R5PPNRNTKDI"
}

extension NetworkService: INetworkService {
    
    func getSearchResults(searchQuery: String, pageNumber: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let request = makeRequestURL(with: searchQuery, pageNumber: pageNumber) else { return }
        
        urlSession.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            
            switch response.statusCode {
                
            case 200...299:
                if self.searchResultDataIsEmpty(data) {
                    completion(.failure(NetworkError(code: -1000, description: "Images not found")))
                }
                completion(.success(data))
            case 300...399: completion(.success(data))
            case 400: completion(.failure(NetworkError(code: 400, description: "400: Bad Request")))
            case 401: completion(.failure(NetworkError(code: 401, description: "401: Invalid Access Token")))
            case 403: completion(.failure(NetworkError(code: 403, description: "403: Forbidden")))
            case 404: completion(.failure(NetworkError(code: 404, description: "404: Not Found")))
            case 405...499: completion(.failure(NetworkError(code: response.statusCode, description: "\(response.statusCode): Unknown error")))
            case 500...599: completion(.failure(NetworkError(code: response.statusCode, description: "\(response.statusCode): Server error")))
            default:
                completion(.failure(NetworkError(code: response.statusCode, description: "\(response.statusCode): Unknown error")))
            }
            
        }.resume()
    }
    
    func getPreviewImage(with query: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: query) else { return }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                guard let image = UIImage(data: data) else { fatalError(CommonError.failedToLoadData) }
                completion(image, nil)
            } else if let response = response as? HTTPURLResponse {
                completion (nil, (NetworkError(code: response.statusCode, description: "\(response.statusCode): Image error")))
            }
            
            
        }.resume()
        
    }
}

private extension NetworkService {
    
    func makeRequestURL(with searchQuery: String, pageNumber: Int) -> URLRequest? {
        var baseComponent = URLComponents(string: "https://api.unsplash.com/search/photos")
        
        let searchQueryItem = URLQueryItem(name: "query", value: searchQuery)
        let clientIdItem = URLQueryItem(name: "client_id", value: id)
        let pageNumber = URLQueryItem(name: "page", value: String(pageNumber))
        let imagesPerSearch = URLQueryItem(name: "per_page", value: "20")
        
        baseComponent?.queryItems = [pageNumber, imagesPerSearch, searchQueryItem, clientIdItem]
        
        guard let baseUrlComponent = baseComponent?.url else {
            
            return nil
        }
        return URLRequest(url: baseUrlComponent)
    }
    
    func searchResultDataIsEmpty(_ data: Data) -> Bool {
        let emptyResultDataCount = 40
        return data.count <= emptyResultDataCount
    }
}

