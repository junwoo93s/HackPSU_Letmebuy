//
//  ViewController.swift
//  Supream
//
//  Created by Junwoo Seo on 4/7/18.
//  Copyright © 2018 Junwoo Seo. All rights reserved.
//





import UIKit
import FirebaseDatabase
import Firebase
import SVProgressHUD



class ViewController: UIViewController {
    
   

    @IBOutlet weak var UserTextField: UITextField!
    
    @IBOutlet weak var textView: UITextField!
    
 
    
    var global = ""
    var url = ""
    var hasit = "false"
    var not_in_database = ""
    
    
    
    var ref:DatabaseReference?
    var rref:DatabaseReference?
    
    
    var get:DatabaseHandle?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UserTextField.delegate = self
        
        

        
        // Do any additional setup after loading the view, typically from a nib.
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func UserButton(_ sender: UIButton) {
        
        self.url = UserTextField.text!
        
        
        gettingData(url : self.url, global : self.global)

    
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UserTextField.resignFirstResponder()
    }
    
    
    
    func gettingData(url : String, global : String){
        ref = Database.database().reference()
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        var count : Int = 0
        var check = ref?.child("item")
        check?.observe(.value, with: { snapshot in
            if snapshot.value is NSNull {
                print("not found")
            } else {
                var loopCount = 1  //  count loops to see how may time trying to loop
                for child in snapshot.children {
      
                    let snap = child as! DataSnapshot //each child is a snapshot
                    
                    if snap.value != nil {
                        print("key ... \(snap.key)")
                        let dict = snap.value as! [String: Any] // the value is a dictionary
                        let address = dict["url"] as! String
                        let stock = dict["stock"] as! Int

                        if (address == self.url){
                            if (stock == 0){
                                self.global = "false"
                                self.self.textView.text = "it is out of stock"
                                break
                            }
                            else{
                                self.global = "true"
                                self.textView.text = "it is in Stock"
                                break
                            }
                        }
                        loopCount += 1
                    } else {
                        self.rref = Database.database().reference()
                        print("newitem")
                        self.rref?.child("item").childByAutoId().setValue(["url": self.url, "stock" : false])
                    }
            }}})
    }
    }


        
    
    



extension ViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

