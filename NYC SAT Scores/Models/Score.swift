//
//  Score.swift
//  NYC SAT Scores
//
//  Created by Lisa J on 3/12/18.
//  Copyright © 2018 Lisa J. All rights reserved.
//

import Foundation

struct Score: Codable {
    var dbn: String?
    var num_of_sat_test_takers: String?
    var sat_critical_reading_avg_score: String?
    var sat_math_avg_score: String?
    var sat_writing_avg_score: String?
    var school_name: String?
}
enum CodingKeys: String, CodingKey {
    case dbn
    
    case numOfTestTakers = "num_of_sat_test_takers"
    case satCriticalReadingAvgScore = "sat_critical_reading_avg_score"
    case satMathAvgScore = "sat_math_avg_score"
    case satWritingAvgScore = "sat_writing_avg_score"
    case schoolName = "school_name"
}

