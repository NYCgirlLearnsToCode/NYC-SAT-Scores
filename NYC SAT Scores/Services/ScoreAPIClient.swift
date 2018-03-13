//
//  ScoreAPIClient.swift
//  NYC SAT Scores
//
//  Created by Lisa J on 3/12/18.
//  Copyright © 2018 Lisa J. All rights reserved.
//

import Foundation

class ScoreAPIClient {
    private init(){}
    static let manager = ScoreAPIClient()
    func getScores(from urlStr: String,
                   completionHandler: @escaping ([Score]) -> Void,
                   errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseData: (Data) -> Void = {(data) in
            do {
                let scores = try JSONDecoder().decode([Score].self, from: data)
                completionHandler(scores)
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseData, errorHandler: errorHandler)
    }
}
