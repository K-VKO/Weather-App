//
//  Article.swift
//  App
//
//  Created by Константин Вороненко on 15.03.22.
//

import Foundation

struct ArticleResponse: Decodable {
    var articles: [Article]
}

struct Article: Decodable {
    var title: String
    var description: String
    var urlToImage: URL
}
