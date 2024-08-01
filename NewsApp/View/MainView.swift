//
//  ContentView.swift
//  NewsApp
//
//  Created by Taha Dirican on 15.07.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = SourceViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Using Toggle to select categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(action: {
                                viewModel.toggleCategory(category)
                            }) {
                                Text(category.capitalized)
                                    .padding()
                                    .background(viewModel.selectedCategories.contains(category) ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }
                
                // List to show filtered sources
                List(viewModel.filteredSources) { source in
                    NavigationLink(destination: NewsListView(source: source)) {
                        VStack(alignment: .leading) {
                            Text(source.name)
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text(source.description ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                }
                    .navigationTitle("News Sources")
                    .onAppear {
                        viewModel.fetchNewsSources()
                    }
                    .overlay {
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                        }
                    }
                    .alert(isPresented: Binding<Bool>(
                        get: { viewModel.errorMessage != nil },
                        set: { _ in viewModel.errorMessage = nil }
                    )) {
                        Alert(
                            title: Text("Error"),
                            message: Text(viewModel.errorMessage ?? "An error occurred"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
        }


struct ContentView: View {
    var body: some View {
        MainView()
    }
}
