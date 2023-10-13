//
//  SearchViewController.swift
//  TripAndWeather
//
//  Created by user248619 on 10/12/23.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var SearchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchBar.delegate = self
        
        // Do any additional setup after loading the view.
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Call the function to fetch data when the user types
        // At least 3 characters starting with "Tor"
        if searchText.count >= 3 && searchText.lowercased().hasPrefix("tor") {
        // Call the function to perform the segue to the second view controller
        performSegue(withIdentifier: "DetailSearchController", sender: self)
                }
    }
    
}
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    

