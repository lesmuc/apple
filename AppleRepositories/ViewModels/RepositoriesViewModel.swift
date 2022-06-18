//
//  RepositoriesViewModel.swift
//  AppleRepositories
//
//  Created by Udo Von Eynern on 16.06.22.
//

import Foundation

class RepositoriesViewModel: ObservableObject {
    
    /// This is the fixed URL for finding apple repository items
    private let url = "https://api.github.com/orgs/apple/repos"
    
    /// Loading State of Github items
    enum LoadingState {
        case loading
        case loaded
        case failed
    }
    
    /// Request Errors for loading Github items
    enum RequestError: Error {
        case failedRequest
        case decodingError
    }
    
    @Published var items: [Repository] = []
    
    @Published var error: Error? = nil
    
    @Published var loadingState: LoadingState? = .none
    
    /**
     Fetch items from Github and updates
     `RepositoriesViewModel.items`
     `RepositoriesViewModel.error`
     `RepositoriesViewModel.loadingState`
     */
    // TODO: Is there a keyword for documentation of Published variables?
    func fetchItems() {
        guard let url = URL(string: url) else { return }
        
        let request = URLRequest(url: url)
        
        loadingState = .loading
        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data else {
                DispatchQueue.main.async {
                    self.error = error
                    self.loadingState = .failed
                }
                return
            }
            
            let decoder = JSONDecoder()
            // We want to convert keys like "snake_case" to "snakeCase"
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // Here is the decoding strategy for github date format
            decoder.dateDecodingStrategy = .custom(self.customDateParser(_:))
            
            do {
                let data = try decoder.decode([Repository].self, from: data)
                
                // Publish it on the main thread
                DispatchQueue.main.async {
                    self.items = data.sorted(by: { $0.name < $1.name })
                    self.loadingState = .loaded
                }
                
            } catch let error {
                DispatchQueue.main.async {
                    self.error = error
                    self.loadingState = .failed
                }
            }
            
        }.resume()
    }
    
    /**
        Date Formatter for Github dates (Example: 2015-10-12T22:33:18Z )
     
        - Parameters:
            - decoder: the JSON Decoder

        - Throws: `RequestError.decodingError`
               if the given date could not get parsed
     
        - Returns: Decoded date from Github string
     */
    func customDateParser(_ decoder: Decoder) throws -> Date {
        let dateString = try decoder.singleValueContainer().decode(String.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            throw RequestError.decodingError
        }
    }
}
