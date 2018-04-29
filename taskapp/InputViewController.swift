//
//  InputViewController.swift
//  taskapp
//
//  Created by 加島亮成 on 2018/04/27.
//  Copyright © 2018年 加島亮成. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTexrField: UITextField!
    
    let realm = try! Realm()
    var task: Task!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        categoryTexrField.text = task.category
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    

    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
            self.task.category = self.categoryTexrField.text!
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    @objc func dismissKeyboard(){
        
        view.endEditing(true)
    }
    
    
    func setNotification(task: Task){
        let content = UNMutableNotificationContent()
        
        if task.title == ""{
            content.title = "(タイトルなし）"
        }else{
            content.title = task.title
        }
        if task.contents == ""{
            content.body = "(内容なし)"
        }else{
            content.body = task.contents
        }
        if task.contents == ""{
            content.body = "(内容なし)"
        }else{
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day, .day, .hour, .minute],from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents,repeats: false)
        
        let request = UNNotificationRequest.init(identifier:String(task.id),content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request){(error)in
            print(error ?? "ローカル通信登録 OK")
    }
        
        center.getPendingNotificationRequests {(requests: [UNNotificationRequest])in
            for request in requests {
                print("/-----------")
                print(request)
                print("-----------/")
            }
        }
        
    }
    
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


