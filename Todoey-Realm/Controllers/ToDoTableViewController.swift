//
//  ViewController.swift
//  Todoey-Realm
//
//  Created by Sergio Ordaz Romero on 09/01/23.
//

import UIKit
import RealmSwift

class ToDoTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var itemsArray: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.searchTextField.delegate = self
    }
    
    //MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        var configCell = cell.defaultContentConfiguration()
        configCell.text = itemsArray?[indexPath.row].name ?? "No items added yet"
        cell.contentConfiguration = configCell
        if let isChecked = itemsArray?[indexPath.row].isChecked {
            cell.accessoryType = isChecked ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = itemsArray?[indexPath.row] {
            do {
                try realm.write { item.isChecked = !item.isChecked }
            } catch {
                print("Error updating status, \(error)")
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Add Category
    
    @IBAction func addItems(_ sender: Any) {
        var itemField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if !itemField.text!.isEmpty {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item(name: itemField.text!)
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving item \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        alert.addTextField { field in
            field.placeholder = "Item"
            itemField = field
        }
        
        present(alert, animated: true)
    }

    //MARK: - Load Items
    func loadItems() {
        itemsArray = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        self.tableView.reloadData()
    }
    
    //MARK: - Save Categories
    func save(item: Item) {
        do {
            try realm.write { realm.add(item) }
        } catch {
            print("Error saving items \(error)")
        }
        self.tableView.reloadData()
    }
}

extension ToDoTableViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty{
            itemsArray = itemsArray?.filter("name CONTAINS[cd] %@", searchBar.text!)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadItems()
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }
        return true
    }
}

