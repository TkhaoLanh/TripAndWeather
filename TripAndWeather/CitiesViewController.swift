//
//  CitiesViewController.swift
//  TripAndWeather
//
//  Created by user248619 on 10/12/23.
//

import UIKit
protocol didfinishSearchDelegate : AnyObject {
    func didFinishSearchWith(cityName : String?)
}

class CitiesViewController: UIViewController {

    weak var delegate : didfinishSearchDelegate?
    var Citylist : [String]? = nil {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didFinishSearchWith(cityName: Citylist?[indexPath.row])
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Citylist?.count ?? 0
    }

     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Citylist?[indexPath.row] ?? ""
        // Configure the cell...

        return cell
    }

}
