//
//  Sources.swift
//  NewsApp
//
//  Created by Taha Dirican on 15.07.2024.
//

import Foundation

struct Source: Codable,Identifiable {
    let id: String?
    let name: String
    let description: String?
    let category: String?
    let language: String?
}

struct SourcesResponse: Codable {
    let status: String
    let sources: [Source]
}
