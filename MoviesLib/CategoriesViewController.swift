//
//  CategoriesViewController.swift
//  MoviesLib
//
//  Created by Eric Brito.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreData

enum CategoryType {
    case add
    case edit
}

class CategoriesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var dataSource: [Category] = []
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadCategories()
    }
    
    // MARK: - Methods
    func loadCategories() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(type: CategoryType, category: Category?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Categoria", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome da categoria"
            if let name = category?.name {
                textField.text = name
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let category = category ?? Category(context: self.context)
            category.name = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.loadCategories()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        showAlert(type: .add, category: nil)
    }
}


// MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = dataSource[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            movie.addToCategories(category)
        } else {
            cell.accessoryType = .none
            movie.removeFromCategories(category)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let category = self.dataSource[indexPath.row]
            self.context.delete(category)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let category = self.dataSource[indexPath.row]
            tableView.setEditing(false, animated: true)
            self.showAlert(type: .edit, category: category)
        }
        editAction.backgroundColor = .blue
        return [editAction, deleteAction]
    }
}

// MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = dataSource[indexPath.row]
        cell.textLabel?.text = category.name
        cell.accessoryType = .none
        if movie != nil {
            if let categories = movie.categories, categories.contains(category) {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
}






