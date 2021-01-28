//
//  JokeController.swift
//  Chucknorsis
//
//  Created by Lee McCormick on 1/27/21.
//

import UIKit

class JokeController {
    
    // https://api.chucknorris.io/jokes/random?category=movie // For fetchJoke
    // https://api.chucknorris.io/jokes/categories // For fetchAllcategories
    
    // MARK: - URL
    static let baseURL = URL(string: "https://api.chucknorris.io/jokes")
    static let randomComponent = "random"
    static let queryCategory = "category"
    static let allCategories = "categories"

    // MARK: - fetchJoke
    static func fetchJoke(catagory: String, completion: @escaping (Result<Joke, JokeError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let randomURL = baseURL.appendingPathComponent(randomComponent)
        
        var components = URLComponents(url: randomURL, resolvingAgainstBaseURL: true)
        let queryURL = URLQueryItem(name: queryCategory, value: catagory)
        components?.queryItems = [queryURL]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        
        print("\nFinalURL For Fetching Joke ::: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let joke = try JSONDecoder().decode(Joke.self, from: data)
                completion(.success(joke))
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    // MARK: - fetchCategories
    static func fetchCategories(completion: @escaping (Result<[String],JokeError>) -> Void) {
        guard let baseURL = baseURL else { return }
        let finalCategoriesURL = baseURL.appendingPathComponent(allCategories)
        print("\nURL for fetchCategories ::: \(finalCategoriesURL)")
        URLSession.shared.dataTask(with: finalCategoriesURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let catagoriesArray = try JSONDecoder().decode([String].self, from: data)
                completion(.success(catagoriesArray))
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    // MARK: - fetchIcon
    static func fetchIcon(for joke: Joke, completion: @escaping (Result<UIImage,JokeError>) -> Void) {
        guard let iconURL = joke.icon_url else { return completion(.failure(.noData)) }
        print("\niconURL for fetchIcon ::: \(iconURL)")
        URLSession.shared.dataTask(with: iconURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData))}
            guard let iconImage = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            completion(.success(iconImage))
        }.resume()
    }
}

