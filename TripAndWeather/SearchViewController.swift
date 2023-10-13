//
//  SearchViewController.swift
//  TripAndWeather
//
//  Created by user248619 on 10/12/23.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Service.shared.getDataFrom(urlStr: "gd.geobytes.com/AutoCompleteCity?q=Tor&callback=?")
        { result   in
            switch result {
            case .failure(let err): print("eror: \(err)")
                
            case .success(let xdata):
                print(xdata)
                let resultSet = try? JSONDecoder().decode(ResultSet.self, from: xdata)
                
                if let results = resultSet {
                    DispatchQueue.main.async { [unowned self] in
                        self.photos = results.photos
                    }
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

}
