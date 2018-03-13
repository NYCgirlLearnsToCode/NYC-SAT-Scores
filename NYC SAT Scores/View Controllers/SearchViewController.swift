//
//  SearchViewController.swift
//  NYC SAT Scores
//
//  Created by Lisa J on 3/12/18.
//  Copyright © 2018 Lisa J. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {

    var scores = [Score]()
    var schools = [School]()
    var enteredSchoolName = ""
    @IBOutlet weak var schoolNameTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var scoreTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if !NetworkReachabilityManager()!.isReachable {
            showAlert(title: "Error", message: "No internet connection")
            return
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scoreTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    private func loadScores(schoolName: String) {
        let url = "https://data.cityofnewyork.us/resource/734v-jeq5.json?school_name=\(schoolName)"
        guard self.schoolNameTextField.text != "" else {self.showAlert(title: "No Results", message: "Please input a school name"); return}
        let completion = {(onlineScores: [Score]) in
            self.scores = onlineScores
            self.label.text = self.schoolNameTextField.text
            print("srch results scores",self.scores)
            if let readingScore = self.scores.first?.sat_critical_reading_avg_score, let mathScore = self.scores.first?.sat_math_avg_score, let writingScore = self.scores.first?.sat_writing_avg_score {
                
                self.scoreTextView.text = """
                SAT Reading Score Average : \(readingScore)
                SAT Math Score Average : \(mathScore)
                SAT Writing Score Average : \(writingScore)
                """
            } else {
                self.showAlert(title: "No Results", message: "No Scores found for this school")
            }
        }
        ScoreAPIClient.manager.getScores(from: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!, completionHandler: completion, errorHandler: {print($0)})
    }
    
    
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        guard let schoolNameTextField = schoolNameTextField.text else {showAlert(title: "Error", message: "Please input a school name"); return}
        if !NetworkReachabilityManager()!.isReachable {
            showAlert(title: "Error", message: "No internet connection")
            return
        }
        enteredSchoolName = schoolNameTextField
        print("enteredSchoolName:", enteredSchoolName)
        loadScores(schoolName: enteredSchoolName.uppercased())
        
        
    }
    
    
    
    
}

