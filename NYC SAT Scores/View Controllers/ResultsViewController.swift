//
//  ResultsViewController.swift
//  NYC SAT Scores
//
//  Created by Lisa J on 3/12/18.
//  Copyright © 2018 Lisa J. All rights reserved.
//

import UIKit
import Alamofire

class ResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var schools = [School]() {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedBorough = ""
    var selectedSchoolDbnNum = "selectedschooldbn"
    var selectedSchool = "selectedschool"
    var schoolInfo: School!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSchools(borough: selectedBorough)
        print(selectedBorough)
        tableView.delegate = self
        tableView.dataSource = self
        if !NetworkReachabilityManager()!.isReachable {
            showAlert(title: "Error", message: "No internet connection")
            return
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    private func loadSchools(borough : String) {
        let url = "https://data.cityofnewyork.us/resource/97mf-9njv.json?boro=\(borough)"
        let completion = {(onlineSchools: [School]) in
            self.schools = onlineSchools
        }
        SchoolAPIClient.manager.getSchools(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
    
}
extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let school = schools[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Result Cell", for: indexPath)
        cell.textLabel?.text = school.school_name
        cell.detailTextLabel?.text = school.city
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "School Segue") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let schoolVC = segue.destination as? SchoolViewController
                schoolVC?.selectedSchoolDbn = schools[indexPath.row].dbn
                schoolVC?.selectedSchool = schools[indexPath.row].school_name
                schoolVC?.schoolInfo = schools[indexPath.row]
            }
        }
    }
    
    
}

