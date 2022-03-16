//
//  NewsNetworkService.swift
//  App
//
//  Created by Константин Вороненко on 15.03.22.
//

import Alamofire


final class NewsNetworkService {
    static let shared = NewsNetworkService()
    
    private init() {}
    
    func loadArticle(completion: @escaping (Article?, Error?) -> Void) {
        let url = "https://newsapi.org/v2/everything?sortBy=publishedAt&apiKey=19212336d40e463bbd18132edfa2f299&language=ru&q=%D0%BF%D0%BE%D0%B3%D0%BE%D0%B4%D0%B0&domains=onliner.by"
        
        
        AF.request(url).responseDecodable(of: ArticleResponse.self) { response in
            guard let articles = response.value else {
                print("error: \(String(describing: response.error))")
                completion(nil, response.error)
                return
            }
            completion(articles.articles.first, nil)
        }
    }
}
