//
//  BoroughViewController.swift
//  NYC SAT Scores
//
//  Created by Lisa J on 3/12/18.
//  Copyright © 2018 Lisa J. All rights reserved.
//

import UIKit
import Alamofire
class BoroughViewController: UIViewController {

    let boroughs = ["Manhattan", "Brooklyn", "Queens", "Bronx", "Staten Island"]
    var selectedBorough = ""
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if !NetworkReachabilityManager()!.isReachable {
            showAlert(title: "Error", message: "No internet connection")
            return
        }
    }
}

extension BoroughViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boroughs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let borough = boroughs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Borough Cell", for: indexPath)
        cell.textLabel?.text = borough
        return cell
    }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.safeAreaLayoutGuide.layoutFrame.size.height/5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        if let resultsVC = segue.destination as? ResultsViewController {
            //            let formVC = segue.destination as? FormViewController
            switch indexPath.row {
            case 0:
                selectedBorough = "M"
                print("M")
            case 1:
                selectedBorough = "K"
                print("Bk")
            case 2:
                selectedBorough = "Q"
                print("Q")
            case 3:
                selectedBorough = "X"
                print("Bx")
            case 4:
                selectedBorough = "R"
                print("SI")
            default:
                print("gdf")
            }
            resultsVC.selectedBorough = selectedBorough
            //resultsVC.bgImage = boroughs[indexPath.row].1
        }
    }
}
