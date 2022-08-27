//
//  FilesViewController.swift
//  25thDavitShavtvalishvili
//
//  Created by a on 23.08.22.
//

import UIKit

class FilesViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var tableView: UITableView!
    var folderName = ""
    var chosenFile = ""
    var arrayOfFiles: [String] = []
    weak var delegate: ViewController? = nil
    let manager = FileManager.default
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableViewConfiguration()
        fillFilesArr()
    }
    
    func config() { url = manager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(folderName) }
    
    @IBAction func `return`(_ sender: Any) { self.dismiss(animated: true, completion: nil) }
    
    @IBAction func deleteButton(_ sender: Any) {
        if chosenFile != "" {
            do {
                let fileUrl = url!.appendingPathComponent(chosenFile)
                try manager.removeItem(at: fileUrl)
                textView.text = "No Text Open"
                fillFilesArr()
            } catch { print(error) }
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        if chosenFile != "" {
            do {
                let fileUrl = url!.appendingPathComponent(chosenFile)
                let text = try String(contentsOf: fileUrl, encoding: .utf8)
                textView.text = text
            } catch  { print(error) }
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if chosenFile != "" {
            do {
                let fileUrl = url!.appendingPathComponent(chosenFile)
                let text = textView.text ?? ""
                try text.write(to: fileUrl, atomically: false, encoding: .utf8)
            }
            catch {print(error)}
            LocalLocationManager.register(notification: LocalNotification(id: UUID().uuidString , title: chosenFile, message: "file saved 10 seconds ago"), duration: 10, repeats: false, userInfo: ["defaultUser": "no data"])
        }
    }
    
    @IBAction func createButton(_ sender: Any) {
        if textField.text != nil && textField.text != "" && delegate != nil{
            let ac = UIAlertController(title: textField.text!, message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
                let answer = ac.textFields![0].text ?? ""
                var fileUrl = self.url!.appendingPathComponent(self.textField.text!)
                fileUrl.appendPathExtension("text")
                let textData = answer.data(using: .utf8)!
                self.manager.createFile(atPath: fileUrl.path, contents: textData, attributes: nil)
                self.textField.text = ""
                self.fillFilesArr()
                LocalLocationManager.register(notification: LocalNotification(id: UUID().uuidString , title: self.textField.text!, message: "file created 10 seconds ago"), duration: 10, repeats: false, userInfo: ["defaultUser": "no data"])
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            ac.addAction(submitAction)
            ac.addAction(cancelAction)
            present(ac, animated: true)
        }
    }
}

extension FilesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { arrayOfFiles.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableViewCell", for: indexPath) as! secondTableViewCell
        let i = indexPath[1]
        cell.index = i
        cell.delegate = self
        cell.config()
        return cell
    }
    
    func mainTableViewConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "secondTableViewCell", bundle: nil), forCellReuseIdentifier: "secondTableViewCell")
        tableView.reloadData()
    }
    
    func fillFilesArr() {
        if url != nil {
            do {
                let documentDirectory = url!
                let directoryContents = try FileManager.default.contentsOfDirectory(
                    at: documentDirectory,
                    includingPropertiesForKeys: nil
                )
                                
                arrayOfFiles = []
                for url in directoryContents {
                    print(url.localizedName ?? url.lastPathComponent)
                    arrayOfFiles += [String(url.localizedName ?? url.lastPathComponent)]
                }
            } catch { print(error) }
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
}
