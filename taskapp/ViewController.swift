//
//  ViewController.swift
//  taskapp
//
//  Created by 加島亮成 on 2018/04/27.
//  Copyright © 2018年 加島亮成. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataList = [Task]()
    
    let realm = try! Realm()
    
    var searchResult = [String]()
    
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        self.view.addSubview(searchBar)
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
        }else{
            taskArray = try! Realm().objects(Task.self).filter("category == %@", searchBar.text!).sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
        self.view.endEditing(true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
        }else{
            taskArray = try! Realm().objects(Task.self).filter("category == %@", searchBar.text!).sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
            self.view.endEditing(true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let task = taskArray[indexPath.row]
            cell.textLabel?.text = task.title
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString:String = formatter.string(from: task.date)
            cell.detailTextLabel?.text = dateString
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return . delete
       
    }
    
    func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        }else{
            let task = Task()
            task.date = Date()
            
            let taskArray = realm.objects(Task.self)
            if taskArray.count != 0{
                task.id = taskArray.max(ofProperty:"id")! + 1
            }

            inputViewController.task = task
}
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

}
