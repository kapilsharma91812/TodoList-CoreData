//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Kapil Sharma on 12/04/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit


class CategoryTableViewController: SwipeTableViewController {
    
    var categoryArray = [TaskType]()  //Our Category table name is TaskType
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCateogryFromDB()
        tableView.rowHeight = 80
    }

    //MARK: - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //Called after Click of add-Category button in dialog
            let newlyAdded = TaskType(context: self.context)
            newlyAdded.name = textField.text!
            self.categoryArray.append(newlyAdded)
            self.saveToDB()

            
        }
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        //Show the dialog
        present(alert, animated: true, completion:nil)
        
    }
    
    
    //MARK: - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    ///Setting the data for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
         - Segue know the destination controller so we take instnace and set data into instance member of controller
         - If multiple controller resolution is possible then we can use if else condition to check the destination controller
         */
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
   
    
    
    
    //MARK: - DB methods
    override func deleteItem(at indexPath: IndexPath) {
        categoryArray.remove(at: indexPath.row)
        saveToDB()
    }
    
    func loadCateogryFromDB() {
        let request : NSFetchRequest<TaskType> = TaskType.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch{
            print("Error while fetching data from DB \(error)")
        }
        self.tableView.reloadData()
    }
    
    func saveToDB() {
        //This method is encoding the array and saving it to file
        do {
            
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
}

//MARK: - SWipe Cell Delegate Methods

