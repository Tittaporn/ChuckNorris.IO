//
//  Joke.swift
//  Chucknorsis
//
//  Created by Lee McCormick on 1/27/21.
//

import Foundation

struct Joke: Decodable {
    let value: String
    let icon_url: URL?
    let categories: [String]
}

// https://api.chucknorris.io/jokes/random?category=movie
