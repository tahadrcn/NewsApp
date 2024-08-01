//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Taha Dirican on 16.07.2024.
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    private var cancellables = Set<AnyCancellable>()
    
        
    func fetchNews(from source: String) { // Fetch news data from api
            let apiKey = "4ef008b0a3fb4f4f837bc88f30364e25"
            let urlString = "https://newsapi.org/v2/top-headlines?sources=\(source)&apiKey=\(apiKey)"
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: ArticleResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching news: \(error)")
                    }
                }, receiveValue: { [weak self] articleResponse in
                    if articleResponse.status == "ok" {
                        self?.articles = articleResponse.articles
                    }
                })
                .store(in: &cancellables)
        }
}
