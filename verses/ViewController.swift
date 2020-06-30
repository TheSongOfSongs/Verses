//
//  ViewController.swift
//  verses
//
//  Created by Jinhyang on 2020/06/16.
//  Copyright © 2020 Jinhyang. All rights reserved.
//

import UIKit
import Firebase
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var verse1: UILabel!
    @IBOutlet weak var verse2: UILabel!
    @IBOutlet weak var verse3: UILabel!
    @IBOutlet weak var verse4: UILabel!
    @IBOutlet weak var verse5: UILabel!
    @IBOutlet weak var verse6: UILabel!
    @IBOutlet weak var verse7: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let db = Database.database().reference()
    var verses: Verse?
    lazy var screenshot: UIImage? = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVerse()
    }

    @IBAction func takeScreenshot(_ sender: UIBarButtonItem) {
        getImage()
        saveImage()
    }
}

// MARK: - take screenshot and save to album
extension ViewController {
    
    func getImage() {
        self.toolbar.isHidden = true

        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, UIScreen.main.scale)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        self.screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.toolbar.isHidden = false
    }
    
    func saveImage() {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized, let image = self.screenshot else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { (bool, error) in
                if bool == true {
                    self.alert()
                }
            })
        }
        
    }
    
    func alert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "저장 성공", message: "사진 폴더에서 확인해보세요!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
}


// MARK: - get today's verses from the database
extension ViewController {
    func fetchVerse() {
        
        db.child("verseCount").observeSingleEvent(of: .value) { (snapshot) in
            let verseCount = snapshot.value as? UInt32 ?? 0
            let num = self.getNum()%Int(verseCount)
            
            self.db.child("verse").child("\(num)").observeSingleEvent(of: .value) { snapshot in
                self.verses = snapshot.value as? Verse
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot.value as Any, options: [])
                    let verse: Verse = try JSONDecoder().decode(Verse.self, from: data)
                    self.verses = verse
                    
                    DispatchQueue.main.async {
                        self.updateTodayVerse()
                    }
                    
                } catch {
                    let alert = UIAlertController(title: "데이터 가져오기 실패", message: "데이터를 가져올 수 없습니다.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    
                    alert.addAction(ok)
                    alert.addAction(cancel)
                    
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
    }
    
    func getNum() -> Int {
        let endDate = Date()
        let year = Calendar.current.component(.year, from: endDate)
        guard let startDate = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1)),
            let difference = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day
            else { return 0 }
        
        return difference
    }
    
    func updateTodayVerse() {
        guard let verse = self.verses else { return }
        
        switch verse.part.count {
        case 7:
            self.verse1.text = verse.part[0]
            self.verse2.text = verse.part[1]
            self.verse3.text = verse.part[2]
            self.verse4.text = verse.part[3]
            self.verse5.text = verse.part[4]
            self.verse6.text = verse.part[5]
            self.verse7.text = verse.part[6]
            self.location.text = verse.location
        case 6:
            self.verse1.text = verse.part[0]
            self.verse2.text = verse.part[1]
            self.verse3.text = verse.part[2]
            self.verse4.text = verse.part[3]
            self.verse5.text = verse.part[4]
            self.verse6.text = verse.part[5]
            self.location.text = verse.location
        case 5:
            self.verse1.text = verse.part[0]
            self.verse2.text = verse.part[1]
            self.verse3.text = verse.part[2]
            self.verse4.text = verse.part[3]
            self.verse5.text = verse.part[4]
            self.verse7.text = verse.location
            setLocationText(verse7, verse.location)
        case 4:
            self.verse2.text = verse.part[0]
            self.verse3.text = verse.part[1]
            self.verse4.text = verse.part[2]
            self.verse5.text = verse.part[3]
            setLocationText(verse7, verse.location)
        default:
            break
        }
    }
    
    func setLocationText(_ label: UILabel, _ location: String) {
        label.font = UIFont(name: label.font.fontName, size: 30)
        label.text = location
    }
}
