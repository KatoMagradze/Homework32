//
//  ViewController.swift
//  Homework32
//
//  Created by Kato on 6/2/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tasks = [Task]()
    var tasksLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            if granted {
                print("granted")
                if !self.tasksLoaded {
                    DispatchQueue.main.async {
                        self.firstLoadViewData()
                    }
                }
            }
            else {
                print("not granted")
            }
        }
        

        center.getNotificationSettings { settings in
        guard (settings.authorizationStatus == .authorized) else { return }

            if settings.alertSetting == .enabled {
                if !self.tasksLoaded {
                    DispatchQueue.main.async {
                        self.firstLoadViewData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.permissionDeniedLetter()
                }
            }
        }

        tableView.dataSource = self

    }
        
    func permissionDeniedLetter() {
        let alert = UIAlertController(title: "Attention", message: "To get notifications from the app, please go to settings and turn the notifications on", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            self.openAppSettings()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func openAppSettings() {
        if let url = URL(string:UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func firstLoadViewData() {
        self.tasks.removeAll()
        let task1 = Task(title: "Eat breakfast", hour: 08, minute: 00)
        let task2 = Task(title: "Attend classes", hour: 10, minute: 00)
        let task3 = Task(title: "Do homework", hour: 14, minute: 00)
        let task4 = Task(title: "Have lunch", hour: 15, minute: 00)
        let task5 = Task(title: "Buy groceries", hour: 16, minute: 00)
        let task6 = Task(title: "Watch a movie", hour: 17, minute: 00)
        let task7 = Task(title: "Have dinner", hour: 19, minute: 00)
        let task8 = Task(title: "Go to bed", hour: 22, minute: 00)
        //let task9 = Task(title: "this is a test task", hour: 01, minute: 15)
        
        self.tasks.append(task1)
        self.tasks.append(task2)
        self.tasks.append(task3)
        self.tasks.append(task4)
        self.tasks.append(task5)
        self.tasks.append(task6)
        self.tasks.append(task7)
        self.tasks.append(task8)
        //self.tasks.append(task9)
        
        self.tableView.reloadData()
        self.tasksLoaded = true
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let center = UNUserNotificationCenter.current()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasks_cell", for: indexPath) as! TasksTableViewCell
        
        cell.taskTitleLabel.text = tasks[indexPath.row].title
        
        let hours = String(format: "%02d", tasks[indexPath.row].hour)
        let minutes = String(format: "%02d", tasks[indexPath.row].minute)
        
        cell.taskTimeLabel.text = "Due at \(hours):\(minutes)"
        
        
        let content = UNMutableNotificationContent()
        content.title = "You have a task"
        content.body = tasks[indexPath.row].title
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = tasks[indexPath.row].hour
        dateComponents.minute = tasks[indexPath.row].minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(req)
        
        return cell
        
    }
    
}

class Task {
    var title: String
    var hour: Int
    var minute: Int
    
    init(title: String, hour: Int, minute: Int) {
        self.title = title
        self.hour = hour
        self.minute = minute
    }
}

