//
//  Article.swift
//  NewsApp
//
//  Created by Taha Dirican on 15.07.2024.
//

import Foundation

struct Article: Codable, Identifiable, Equatable {
    var id: UUID { UUID() }
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    func formattedPublishedAt() -> String { // For the desired date format
            guard let publishedAt = publishedAt else { return "No Date" }
            
            let dateFormatter = ISO8601DateFormatter()
            if let date = dateFormatter.date(from: publishedAt) {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                return timeFormatter.string(from: date)
            } else {
                return "No Date"
            }
        }
    static func ==(lhs: Article, rhs: Article) -> Bool { 
            return lhs.title == rhs.title && lhs.url == rhs.url
        }
}


struct ArticleResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
}
