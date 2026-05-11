//
//  ItunesAPI.swift
//  Canvas
//
//  Created by Danilo Henrique on 05/02/25.
//

import Foundation

enum ItunesAPI {
    case getSongs(query: String)
    case getCollection(id: Int)
}

extension ItunesAPI: RESTRequest {
    var baseURL: String {
        "https://itunes.apple.com"
    }

    var path: String {
        switch self {
        case .getSongs:
            return "/search"
        case .getCollection:
            return "/lookup"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getSongs(let query):
            return [
                URLQueryItem(name: "term", value: query),
                URLQueryItem(name: "entity", value: "song"),
                URLQueryItem(name: "media", value: "music"),
            ]
        case .getCollection(let id):
            return [
                URLQueryItem(name: "id", value: String(id)),
                URLQueryItem(name: "entity", value: "song"),
                URLQueryItem(name: "media", value: "music"),
            ]
        }
    }

    var httpMethod: HTTPMethod { .get }
    var HTTPHeaderFields: [String: String]? { nil }
}
