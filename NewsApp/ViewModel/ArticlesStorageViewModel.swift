//
//  ArticlesStorage.swift
//  NewsApp
//
//  Created by Taha Dirican on 17.07.2024.
//

import Foundation

class ArticlesStorageViewModel { // helper class to keep news in device memory
    private let defaults = UserDefaults.standard
    private let newsKey = "savedNews"
    
    func saveArticle(_ article: Article) {
        var articles = getArticles()
        if !articles.contains(article) {
            articles.append(article)
        }
        if let encoded = try? JSONEncoder().encode(articles) {
            defaults.set(encoded, forKey: newsKey)
        }
    }
    
    func getArticles() -> [Article] {
        if let savedArticles = defaults.object(forKey: newsKey) as? Data {
            if let decodedArticles = try? JSONDecoder().decode([Article].self, from: savedArticles) {
                return decodedArticles
            }
        }
        return []
    }
    
    func removeArticle(_ article: Article) {
        var articles = getArticles()
        articles.removeAll { $0 == article }
        if let encoded = try? JSONEncoder().encode(articles) {
            defaults.set(encoded, forKey: newsKey)
        }
    }
    
    func isArticleSaved(_ article: Article) -> Bool {
        return getArticles().contains(article)
    }
    
    
}
