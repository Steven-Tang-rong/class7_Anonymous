//
//  ViewController.swift
//  class7_Anonymous
//
//  Created by TANG,QI-RONG on 2021/2/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var reference = Database.database().reference()
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func clickAnonymousButton(_ sender: UIButton) {
        switch sender.currentTitle! {
        case "匿名登入":
            Auth.auth().signInAnonymously { (authResult: AuthDataResult?, error: Error?) in
                guard let _ = authResult, error == nil else {
                    print("匿名登入錯誤")
                    return
                }
                sender.setTitle("登出", for: .normal)
            }
        case "登出":
            if(try? Auth.auth().signOut()) == nil {
                print("登出失敗")
            }else {
                print("登出成功")
            }
        default:
            break
        }
    }
    @IBAction func checkDataBtn(_ sender: Any) {
        //子節點#imageLiteral(resourceName: "simulator_screenshot_A6E7EB55-63F6-4980-B777-7204E8A11175.png")
        let relayRef = reference.child("Relay")
        relayRef.setValue(["D1": true]) { (error: Error?, dataRef: DatabaseReference) in
            var message = ""
            if let error = error {
                print("User = \(error.localizedDescription)")
                message = error.localizedDescription
            }else {
                message = "資料讀取成功"
            }
            
            let alertController = UIAlertController(title: "讀取狀態", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.title = "匿名登入ID: " + user.uid
                print("User ID = \(user.uid)")
            }else {
                self.actionButton.setTitle("匿名登入", for: .normal)
                self.title = "匿名登入"
            }
        }
    }

}

