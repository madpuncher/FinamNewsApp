//
//  NetworkManager.swift
//  FinamNewsApp
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getNews(newsType: Int, completion: @escaping (Result<[Article],Error>) -> Void) {
        
        var urlString = "https://newsapi.org/v2/top-headlines?country=ru&category=business&pageSize=50&apiKey=\(Constants.key)"
        
        switch newsType {
        case 0:
            urlString = "https://newsapi.org/v2/top-headlines?country=ru&pageSize=50&apiKey=\(Constants.key)"
        case 1:
            urlString = "https://newsapi.org/v2/top-headlines?country=ru&category=sport&pageSize=50&apiKey=\(Constants.key)"
        case 2:
            urlString = "https://newsapi.org/v2/top-headlines?country=ru&category=health&pageSize=50&apiKey=\(Constants.key)"
        case 3:
            urlString = "https://newsapi.org/v2/top-headlines?country=ru&category=business&pageSize=50&apiKey=\(Constants.key)"
        default:
            urlString = "https://newsapi.org/v2/top-headlines?country=ru&pageSize=50&apiKey=\(Constants.key)"
        }

        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300
            else { return }
            
            do {
                let news = try JSONDecoder().decode(News.self, from: data)
                completion(.success(news.articles))
            } catch let error {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
