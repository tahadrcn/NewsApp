//
//  SourceViewModel.swift
//  NewsApp
//
//  Created by Taha Dirican on 15.07.2024.
//

import Foundation
import Combine

class SourceViewModel: ObservableObject {
      @Published var sources: [Source] = []
      var categories : [String] = []
      @Published var isLoading = false
      @Published var errorMessage: String?
      @Published var selectedCategories: Set<String> = []

      private var cancellables = Set<AnyCancellable>()
      private let apiKey = "4ef008b0a3fb4f4f837bc88f30364e25"

      func fetchNewsSources() { // Fetch news's sources and category from api
          isLoading = true
          errorMessage = nil

          let urlString = "https://newsapi.org/v2/sources?language=en&apiKey=\(apiKey)"
          guard let url = URL(string: urlString) else {
              self.errorMessage = "Invalid URL"
              self.isLoading = false
              return
          }

          URLSession.shared.dataTaskPublisher(for: url)
              .map { $0.data }
              .decode(type: SourcesResponse.self, decoder: JSONDecoder())
              .receive(on: DispatchQueue.main)
              .sink(receiveCompletion: { completion in
                  self.isLoading = false
                  switch completion {
                  case .failure(let error):
                      self.errorMessage = "Error fetching data: \(error)"
                  case .finished:
                      break
                  }
              }, receiveValue: { response in
                  self.sources = response.sources
                  for src in self.sources {
                      if !self.categories.contains(src.category ?? ""){
                          self.categories.append(src.category ?? "")
                      }
                  }
              })
              .store(in: &self.cancellables)
      }
    

      var filteredSources: [Source] { // Filter by category
          if selectedCategories.isEmpty {
              return sources
          } else {
              return sources.filter { source in
                  selectedCategories.contains(source.category ?? "")
              }
          }
      }

      func toggleCategory(_ category: String) { // Displaying sources of the selected category
          if selectedCategories.contains(category) {
              selectedCategories.remove(category)
          } else {
              selectedCategories.insert(category)
          }
      }
}
