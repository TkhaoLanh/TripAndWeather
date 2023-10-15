//
//  SearchViewController.swift
//  TripAndWeather
//
//  Created by user248619 on 10/12/23.
//

import UIKit

class SearchViewController: UIViewController {
  
    lazy var resultsTableController =
           self.storyboard?.instantiateViewController(withIdentifier: "SearchCityTableViewController") as? SearchCityTableViewController
 
    lazy var searchconroller = UISearchController(searchResultsController: resultsTableController)
    
    @IBOutlet weak var tableView: UITableView!
    lazy var newItems = [NSManagedObject?]()
    lazy var xactivityList : [TodoActivity]? = [TodoActivity]()  {
        didSet {// there is a better
            tableView.reloadData()
        }
    }
    var thisCity : City? = nil {
        didSet{
            
          
        }
    }
    
    @IBOutlet weak var editStackView: UIStackView!
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var todoTxt: UITextField!
    
    init?(coder: NSCoder, city : City) {
        super.init(coder: coder)
        thisCity = city
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let thisCity = thisCity{
            editStackView.isHidden = false
            xactivityList = thisCity.activities?.allObjects as? [TodoActivity]
            title = thisCity.name
           // print(thisCity?.activities?.count)
        }else{
    
            navigationItem.searchController = searchconroller
            searchconroller.searchResultsUpdater = self
            resultsTableController?.delegate = self
        }
        
         
      
        // Do any additional setup after loading the view.
    }
    

     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "cancel"{
         
                for item in newItems {
                    CoreDataStack.shared.persistentContainer.viewContext.delete(item!)
                }
           
        }
        
    }
    
    
    @IBAction func addTodo() {
        let activity = TodoActivity(context: CoreDataStack.shared.persistentContainer.viewContext)
        activity.todo = todoTxt.text
        
        thisCity?.addToActivities(activity)
        
        xactivityList?.append(activity)
        //save
        
//TODO
    }
    @IBAction func add() {
        if let _ = thisCity {
          //  CoreDataStack.shared.saveContext()
            editStackView.isHidden = false
        }
    }
    
    func getData() {
        let searchText = searchconroller.searchBar.text ?? ""
        
        let query = [ "q" : searchText, "callback" : "?"  ]
      
        Service.shared.getData(url: "http://gd.geobytes.com/AutoCompleteCity",query: query) { (result) in
                switch result
                {
                case .failure(let error):
                    print(error)
                case .success(let data):

                    if let xdata = String(data: data, encoding: .utf8)?.cleanJson().data(using: .utf8), let result = try?
                        JSONDecoder().decode([String].self, from: xdata){
                        
                        let cityNames = result.reduce(into: [String]()) {
                            let spliter = $1.split(separator: ",")
                            if(spliter.count == 3) {$0.append(String(spliter[0]))}
                    }
                        self.resultsTableController?.Citylist = cityNames
                    }
                 
        }
    }
}
}


extension SearchViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        getData()
    }
}
extension SearchViewController : didfinishSearchDelegate {
    func didFinishSearchWith(cityName: String?) {
        //searchconroller.dismiss(animated: true, completion: nil)
        searchconroller.isActive = false
        title = cityName
        if thisCity == nil{
        thisCity = City(context: CoreDataStack.shared.persistentContainer.viewContext)
            
        }

        newItems.append(thisCity)
        thisCity!.name = cityName
        editStackView.isHidden = false
    }
}
extension EditViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
         cell.textLabel?.text = xactivityList?[indexPath.row].todo
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(xactivityList?.count)
         return xactivityList?.count ?? 0
         
    }
   
    
}
       
        
    

