//
//  SchoolAPIClient.swift
//  NYC SAT Scores
//
//  Created by Lisa J on 3/12/18.
//  Copyright © 2018 Lisa J. All rights reserved.
//

import Foundation

class SchoolAPIClient {
    private init(){}
    static let manager = SchoolAPIClient()
    func getSchools(from urlStr: String,
                    completionHandler: @escaping ([School]) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseData: (Data) -> Void = {(data) in
            do {
                let schools = try JSONDecoder().decode([School].self, from: data)
                completionHandler(schools)
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseData, errorHandler: errorHandler)
        
    }
    
}
