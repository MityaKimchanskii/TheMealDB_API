//
//  MealManager.swift
//  TheMealDB_API
//
//  Created by Mitya Kim on 4/8/23.
//

import UIKit

enum NetworkError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach the server."
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) --- \(error)"
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "There unable to decode the data."
        }
    }
}

class MealManager {
    
    static let baseURL = URL(string: "https://www.themealdb.com")
    static let apiComponent = "api"
    static let jsonComponent = "json"
    static let v1Component = "v1"
    static let oneComponent = "1"
    static let listComponent = "list.php"
    static let filterComponent = "filter.php"
    static let lookupComponent = "lookup.php"
    
    static let cKey = "c"
    static let cValue = "list"
    static let mealKey = "i"
    
    // Fetch all categories:
    static func fetchCategories(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        
        guard let baseURL else { return completion(.failure(.invalidURL)) }
        let apiURL = baseURL.appending(path: apiComponent)
        let jsonURL = apiURL.appending(path: jsonComponent)
        let v1URL = jsonURL.appending(path: v1Component)
        let oneURL = v1URL.appending(path: oneComponent)
        let listURL = oneURL.appending(path: listComponent)
        
        var components = URLComponents(url: listURL, resolvingAgainstBaseURL: true)
        
        let categoryQuery = URLQueryItem(name: cKey, value: cValue)
        components?.queryItems = [categoryQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            DispatchQueue.main.async {
                
                if let error {
                    return completion(.failure(.thrownError(error)))
                }
                
                guard let data else { return completion(.failure(.noData)) }
                
                do {
                    let categoryObject = try JSONDecoder().decode(CategoriesObject.self, from: data)
                    let categories = categoryObject.meals
                    return completion(.success(categories))
                    
                } catch {
                    return completion(.failure(.unableToDecode))
                }
            }
        }.resume()
    }
    
    // Fetch all recipies by category:
    static func fetchMeals(category: String, completion: @escaping (Result<[Meal], NetworkError>) -> Void) {
        
        guard let baseURL else { return completion(.failure(.invalidURL)) }
        let apiURL = baseURL.appending(path: apiComponent)
        let jsonURL = apiURL.appending(path: jsonComponent)
        let v1URL = jsonURL.appending(path: v1Component)
        let oneURL = v1URL.appending(path: oneComponent)
        let filterURL = oneURL.appending(path: filterComponent)
        
        var components = URLComponents(url: filterURL, resolvingAgainstBaseURL: true)
        
        let categoryQuery = URLQueryItem(name: cKey, value: category)
        components?.queryItems = [categoryQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            DispatchQueue.main.async {
                if let error {
                    return completion(.failure(.thrownError(error)))
                }
                
                guard let data else { return completion(.failure(.noData)) }
                
                do {
                    let mealsObject = try JSONDecoder().decode(MealsObject.self, from: data)
                    let mealsArray = mealsObject.meals.sorted { $0.mealName < $1.mealName }
                    return completion(.success(mealsArray))
                } catch {
                    return completion(.failure(.unableToDecode))
                }
            }
        }.resume()
    }
    
    // Fetch image
    static func fetchImage(meal: Meal, completion: @escaping(Result<UIImage, NetworkError>) -> ()) {
        guard let imageURL = URL(string: meal.mealThumb) else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            DispatchQueue.main.async {
                if let error {
                    return completion(.failure(.thrownError(error)))
                }
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        print("Status code: \(response.statusCode)")
                    }
                }
                
                guard let data else { return completion(.failure(.unableToDecode)) }
                
                guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
                
                return completion(.success(image))
            }
        }.resume()
    }
    
    // Fetch meal details with mealID
    static func fetchMealDetails(with id: String, completion: @escaping (Result<Details, NetworkError>) -> Void) {
        
        guard let baseURL else { return completion(.failure(.invalidURL)) }
        let apiURL = baseURL.appending(path: apiComponent)
        let jsonURL = apiURL.appending(path: jsonComponent)
        let v1URL = jsonURL.appending(path: v1Component)
        let oneURL = v1URL.appending(path: oneComponent)
        let lookupURL = oneURL.appending(path: lookupComponent)
        
        var components = URLComponents(url: lookupURL, resolvingAgainstBaseURL: true)
        let mealQuery = URLQueryItem(name: mealKey, value: id)
        components?.queryItems = [mealQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            DispatchQueue.main.async {
                if let error = error {
                    return completion(.failure(.thrownError(error)))
                }
                
                guard let data = data else { return completion(.failure(.noData)) }
                
                do {
                    let mealDetails = try JSONDecoder().decode(MealDetais.self, from: data)
                    let details = mealDetails.meals[0]
                    return completion(.success(details))
                } catch {
                    return completion(.failure(.unableToDecode))
                }
            }
        }.resume()
    }
}
