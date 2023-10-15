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

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
    
    // Define a property to hold the filtered search results
    var searchResults: [String] = []
}
extension CitiesViewController : UISearchBarDelegate, UITabBarDelegate, UITableViewDataSource

{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Call the function to fetch data when the user types
        // at least 3 characters starting with "Tor"
        if searchText.count >= 3 && searchText.lowercased().hasPrefix("Tor") {
            fetchDataFromAPI(searchQuery: searchText)
        }
    }
    
    func fetchDataFromAPI(searchQuery: String) {
        let apiUrl = "http://gd.geobytes.com/AutoCompleteCity?q=Tor&callback=?"

        Service.shared.getDataFrom(urlStr: apiUrl) { result in
            switch result {
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8) {
                    // Remove the callback function from the JSON response
                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            let decodedData = try JSONDecoder().decode([String].self, from: jsonData)

                            // Filter and display the cities that start with "Tor"
                            let filteredCities = decodedData.filter { $0.lowercased().hasPrefix("Tor") }
                            DispatchQueue.main.async {
                                // Reload your table view with filteredCities
                                self.searchResults = filteredCities
                                print("Search Results: \(self.searchResults)")

                                
                                self.myTableView.reloadData()
                            }
                        } catch {
                            // Handle JSON decoding error
                            print("JSON decoding error: \(error)")
                        }
                    }
                }
            case .failure(let error):
                // Handle the API request error
                print("API request error: \(error)")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = searchResults[indexPath.row]
            return cell
    }

}
