//
//  SliderView.swift
//  NewsApp
//
//  Created by Taha Dirican on 16.07.2024.
//

import SwiftUI

struct SliderView: View {
    let articles: [Article]
    @Binding var currentIndex: Int
    var articleStorage = ArticlesStorageViewModel()
    @StateObject private var viewModel = NewsViewModel()


    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<articles.count, id: \.self) { index in
                ZStack(alignment: .bottom) {
                    if let imageUrl = articles[index].urlToImage, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                        } placeholder: {
                            Color.gray
                        }
                    } else {
                        Color.gray
                    }
                    VStack{
                        HStack{
                            Text(articles[index].title ?? "No Title")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(8)
                                .frame(width: UIScreen.main.bounds.width*0.8)
                            Text(articles[index].formattedPublishedAt())
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(8)
                        }
                        Button(action: {
                            toggleReadingList(for: articles[index])
                        }) {
                            Text(articleStorage.isArticleSaved(articles[index]) ? "Remove from Reading List" : "Add to Reading List")
                                .foregroundColor(.blue)
                        }
                        .font(.caption)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                    }
                    
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    private func toggleReadingList(for article: Article) { // toggle function for reading list
            if articleStorage.isArticleSaved(article) {
                articleStorage.removeArticle(article)
            } else {
                articleStorage.saveArticle(article)
            }
        viewModel.articles = viewModel.articles.map { $0 } // for refresh UI
        print(articleStorage.getArticles())
        }
}
