//
//  ViewController.swift
//  TripAndWeather
//
//  Created by user248619 on 10/11/23.
//

import UIKit

class ViewController: UIViewController {

       
    lazy var myFetchResultController : NSFetchedResultsController<City> = {
        
        let fetch : NSFetchRequest<City> = City.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        
        let ftc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
         ftc.delegate = self
         
        return ftc
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? myFetchResultController.performFetch()
         
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return myFetchResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myFetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        let item = myFetchResultController.object(at: indexPath)
      
        cell.configureCell(item: item)
        
        
        // Configure the cell...

        return cell
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let obj = myFetchResultController.object(at: indexPath)
            CoreDataStack.shared.persistentContainer.viewContext.delete(obj)
            CoreDataStack.shared.saveContext()
        }
    }
     
     

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            if let selected = tableView.indexPathForSelectedRow{
                let city = myFetchResultController.object(at: selected)
                ((segue.destination as! UINavigationController).viewControllers[0] as! EditViewController).thisCity = city
                
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    @IBAction func unwindSave(segue: UIStoryboardSegue) {
        guard segue.identifier == "save" else {return }
        let sourceViewController = segue.source as! EditViewController
        if let _ = sourceViewController.thisCity {
            CoreDataStack.shared.saveContext()
        }
    }
     
    
}
extension ViewController : NSFetchedResultsControllerDelegate {
    // These methods are called by the iOS runtime, in response to user interaction and/or changes in the data source
    
 
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Updates wrapper end
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Section update(s)
    func controller(_
        controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default: break
        }
    }
    
    // Row update(s)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .automatic)
            }
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .automatic)
            }
        case .update:
            if let index = indexPath {
                tableView.reloadRows(at: [index], with: .automatic)
            }
        case .move:
            if let deleteIndex = indexPath, let insertIndex = newIndexPath {
                tableView.deleteRows(at: [deleteIndex], with: .automatic)
                tableView.insertRows(at: [insertIndex], with: .automatic)
            }
        default:
            print("Row update error")
        }
    }
}
extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate : NSPredicate? = nil
        if !searchText.isEmpty {
            predicate = NSPredicate(format: "name CONTAINS[c] %@ ", searchText)
        }
        //NSFetchedResultsController
        myFetchResultController.fetchRequest.predicate = predicate
        try? myFetchResultController.performFetch()
        tableView.reloadData()
        
    }

}
