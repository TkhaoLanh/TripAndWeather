//
//  ViewController.swift
//  TripAndWeather
//
//  Created by user248619 on 10/11/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddBtn_Pressed(_ sender: UIButton) {
        performSegue(withIdentifier: "Show", sender: self)
    }
}
extension ViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell   = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        return cell
    }
}
