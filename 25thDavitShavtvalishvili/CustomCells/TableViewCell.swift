//
//  TableViewCell.swift
//  21stDavitShavtvalishvili
//
//  Created by a on 11.08.22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var index: Int? = nil
    var folderName = ""
    weak var delegate: ViewController? = nil
    
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config() {
        if index != nil && delegate != nil {
            folderName = delegate!.arrayOfDirs[index!]
            name.text = folderName
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @IBAction func browseButton(_ sender: Any) { if delegate != nil { delegate!.presentFilesVC(folder: folderName) } }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if delegate != nil {
            delegate!.url = delegate!.manager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(folderName)
            delegate!.previewLabel.text = folderName
            delegate!.fillFilesArr()
        }
    }
}
