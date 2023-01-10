//
//  CategoryViewController.swift
//  Todoey-Realm
//
//  Created by Sergio Ordaz Romero on 09/01/23.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var configCell = cell.defaultContentConfiguration()
        configCell.text = categories?[indexPath.row].name ?? "No categories added yet"
        cell.contentConfiguration = configCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoTableViewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Add Category
    @IBAction func addCategory(_ sender: Any) {
        var categoryField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if !categoryField.text!.isEmpty {
                let newCategory = Category(name: categoryField.text!)
                self.save(category: newCategory)
            }
        }
        alert.addAction(action)
        alert.addTextField { field in
            field.placeholder = "Category"
            categoryField = field
        }
        
        present(alert, animated: true)
    }
    
    //MARK: - Load Categories
    func loadCategories() {
        categories = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
    //MARK: - Save Categories
    func save(category: Category) {
        do {
            try realm.write { realm.add(category) }
        } catch {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }
}
