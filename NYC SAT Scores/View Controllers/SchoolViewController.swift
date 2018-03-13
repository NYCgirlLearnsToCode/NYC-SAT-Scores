//
//  SchoolViewController.swift
//  NYC SAT Scores
//
//  Created by Lisa J on 3/12/18.
//  Copyright © 2018 Lisa J. All rights reserved.
//

import UIKit
import Alamofire

class SchoolViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var scoreTextView: UITextView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var collegeCareerRateLabel: UILabel!
    @IBOutlet weak var gradRateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var selectedSchool = "??"
    var selectedSchoolDbn = ".."
    var scores = [Score]()
    var schoolInfo: School!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !NetworkReachabilityManager()!.isReachable {
            showAlert(title: "Error", message: "No internet connection")
            return
        }
        label.text = "\(selectedSchool)"
        loadScores(dbn: selectedSchoolDbn)
        setupUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scoreTextView.setContentOffset(CGPoint.zero, animated: false)
        descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func loadScores(dbn: String) {
        let url = "https://data.cityofnewyork.us/resource/734v-jeq5.json?dbn=\(dbn)"
        let completion = {(onlineScores: [Score]) in
            self.scores = onlineScores
            print("scores",self.scores)
            if let readingScore = self.scores.first?.sat_critical_reading_avg_score, let mathScore = self.scores.first?.sat_math_avg_score, let writingScore = self.scores.first?.sat_writing_avg_score {
                
                self.scoreTextView.text = """
                SAT Reading Score Average : \(readingScore)
                SAT Math Score Average : \(mathScore)
                SAT Writing Score Average : \(writingScore)
                """
            } else {
                self.scoreTextView.text = """
                SAT Reading Score Average : N/A
                SAT Math Score Average : N/A
                SAT Writing Score Average : N/A
                """
            }
        }
        ScoreAPIClient.manager.getScores(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
    func setupUI() {
        descriptionTextView.text = "\(schoolInfo.overview_paragraph)"
        phoneNumberLabel.text = "Phone Number: \(schoolInfo.phone_number)"
        if let collegeCareerRate = schoolInfo.college_career_rate {
            let collegeStrIndex = collegeCareerRate.index((collegeCareerRate.startIndex), offsetBy:4)
            let formattedCollegeRate = collegeCareerRate.substring(to: collegeStrIndex)
            collegeCareerRateLabel.text = "College Career Rate: \(formattedCollegeRate)"
        } else {
            collegeCareerRateLabel.text = "College Career Rate: N/A"
        }
        if let gradRate = schoolInfo.graduation_rate {
            let gradRateStrIndex = gradRate.index((gradRate.startIndex), offsetBy:4)
            let formattedGradRate = gradRate.substring(to: gradRateStrIndex)
            
            gradRateLabel.text = "Graduation Rate: \(formattedGradRate)"
        } else {
            gradRateLabel.text = "Graduation Rate: N/A"
        }
        
    }
    
    
}

