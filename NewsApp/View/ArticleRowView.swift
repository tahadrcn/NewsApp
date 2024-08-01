//
//  ArticleRowView.swift
//  NewsApp
//
//  Created by Taha Dirican on 16.07.2024.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    Color.gray
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(article.title ?? "No Title")
                    .font(.headline)
                Text(article.formattedPublishedAt())
                    .font(.caption)
                    .foregroundColor(.gray)
              
            }
            .padding(.vertical, 5)
        }
    }
   
}
