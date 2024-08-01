//
//  NewsListView.swift
//  NewsApp
//
//  Created by Taha Dirican on 16.07.2024.
//

import SwiftUI

struct NewsListView: View {
    let source: Source
    var articleStorage = ArticlesStorageViewModel()
    @StateObject private var viewModel = NewsViewModel()
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect() // For slider
    private let fetchTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // to refresh the screen and update the news

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.articles.count >= 3 {
                    SliderView(articles: Array(viewModel.articles.prefix(3)), currentIndex: $currentIndex)
                        .frame(height: 300)
                        .onReceive(timer, perform: { _ in
                            withAnimation {
                                currentIndex = (currentIndex + 1) % 3
                            }
                        })
                        .padding(.top,0)
                }
                List(viewModel.articles.dropFirst(3)) { article in
                    ArticleRowView(article: article)
                    Button(action: {
                        toggleReadingList(for: article)
                    }) {
                        Text(articleStorage.isArticleSaved(article) ? "Remove from Reading List" : "Add to Reading List")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle(source.name)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchNews(from: source.id ?? "")
            }
            .onReceive(fetchTimer) { _ in
                viewModel.fetchNews(from: source.id ?? "")
            }
        }
    }
    private func toggleReadingList(for article: Article) { // toggle function for reading list
            if articleStorage.isArticleSaved(article) {
                articleStorage.removeArticle(article)
            } else {
                articleStorage.saveArticle(article)
            }
        viewModel.articles = viewModel.articles.map { $0 } // for refresh UI
        }
}



