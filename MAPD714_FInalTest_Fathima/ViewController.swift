//
// FileName: ViewController.swift
// Project Name: MAPD714_FInalTest_Fathima
//Author anme: Fathima Fathila
//Student Id: 301222885
//Course: MAPD714_IOS_Final Exam
//This is a simple Bmi calcu;lator application which uses table view cemm to read , write and delete //from  Persistent Data Storage.
//  Created by fathila on 2021-12-15.
//

import UIKit
import CoreData

var infos: [NSManagedObject] = []
var userAcc: NSManagedObject?

var heightConst: Float?
var currentInfo: Int = 0

//Main View Controller
class ViewController: UIViewController {

    @IBOutlet weak var textViewName: UITextField!
    @IBOutlet weak var textViewAge: UITextField!
    @IBOutlet weak var textViewGender: UITextField!
    @IBOutlet weak var textViewWeight: UITextField!
    @IBOutlet weak var metricsSwitch: UISwitch!
    var bmi : Float = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("entered")
        textViewAge.keyboardType = .numberPad
        textViewWeight.keyboardType = .numberPad
        textViewHeight.keyboardType = .numberPad
        // Do any additional setup after loading the view.
    }
    //Back Button Pressed from second view controller
    @IBAction func backButtonPressed (segue: UIStoryboardSegue){
        textViewName.text=""
        textViewAge.text=""
        textViewGender.text=""
        textViewWeight.text=""
        textViewHeight.text=""
        scoreView.text=""
        CommentView.text=""
        
       
}
    @IBOutlet weak var textViewHeight: UITextField!
    @IBOutlet weak var scoreView: UILabel!
    @IBOutlet weak var CommentView: UILabel!
    
    //Action for done Button Pressed
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let vc=storyboard?.instantiateViewController(identifier: "second") as! SecondViewController
                        navigationController?.pushViewController(vc,animated: true)
        let weight: Float = (textViewWeight.text! as NSString).floatValue
        let height: Float = (textViewWeight.text! as NSString).floatValue
        heightConst=height
       // let metric = metricsSwitch
        let BMI: Float = bmi
        
        //inserting core data object
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Info", in: managedContext)!
        let newInfo = NSManagedObject(entity: entity, insertInto: managedContext)
        newInfo.setValue(weight, forKey: "weight")
        //newInfo.setValue(metric, forKey: "metricSwitch")
        newInfo.setValue(BMI, forKey: "bmi")
        newInfo.setValue(Date(), forKey: "date")
        do {
            try managedContext.save()
            infos.append(newInfo)
          } catch let error as NSError {
            print("Save Error \(error), \(error.userInfo)")
          }
        
       
             let managedContext1 = appDelegate.persistentContainer.viewContext
              
              let userName: String = textViewName.text!
              let age: Int32 = (textViewAge.text! as NSString).intValue
              let ms = metricsSwitch.isOn
             
              let userAccEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext1)!
              let newAcc = NSManagedObject(entity: userAccEntity, insertInto: managedContext1)
              newAcc.setValue(userName, forKey: "name")
              newAcc.setValue(age, forKey: "age")
              newAcc.setValue(heightConst, forKey: "height")
              newAcc.setValue("male", forKey: "gender")
              newAcc.setValue(ms, forKey: "metricSwitch")
              do {
                  try managedContext1.save()
                  userAcc = newAcc
                } catch let error as NSError {
                  print(" save error. \(error), \(error.userInfo)")
                }

    }
    
    //Action for calculaing BMI
    @IBAction func calculateBMIScore(_ sender: UIButton)
    {
        var newName = textViewName.text!
        var newAge = textViewAge.text!
        var newGender = textViewGender.text!
        let newWeight = textViewWeight.text!
        let newHeight = textViewHeight.text!
        var newMetrics = metricsSwitch.isOn
        // Metrics Switch Toggle
        if (newMetrics)
        {//ImPerial Units
            bmi = (newWeight as NSString).floatValue / (((newHeight as NSString).floatValue) * (newHeight as NSString).floatValue)
        }else{
            //Metric Units
            bmi = ((newWeight as NSString).floatValue * 703) / (((newHeight as NSString).floatValue) * (newHeight as NSString).floatValue)
        }
        scoreView.text = bmi.description
        if (bmi < 16)
        {
            CommentView.text = "Severethinness"
        }else if(bmi>=16 && bmi<=17)
        {
            CommentView.text = "Moderate Thinness"
        }else if(bmi > 17 && bmi <= 18.5)
        {
            CommentView.text = "Mild Thinness"
        }else if(bmi > 18.5 && bmi <= 25)
        {
            CommentView.text = "Normal"
        }else if( bmi > 25 && bmi <= 30)
        {
            CommentView.text = "Overweight"
        }else if(bmi > 30 && bmi < 35 )
        {
            CommentView.text = "Obese Class 1"
        }else if(bmi >= 35 && bmi <= 40)
        {
            CommentView.text =  "Obses Class 2"
        }else if(bmi > 40)
        {
            CommentView.text =  "Obese Class 3"
        }
        
       
    }

    // View Action
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext = appDelegate.persistentContainer.viewContext

          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Info")

          do {
            infos = try managedContext.fetch(fetchRequest)
          } catch let error as NSError {
            print("fetch info error. \(error), \(error.userInfo)")
          }
        print(infos)
    }
}
//SEcond View Controller Starts
class SecondViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func closeButtonPressed(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(BmiTableViewCell.nib(), forCellReuseIdentifier: BmiTableViewCell.identififer)
    }
    
    //Table view configurations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: BmiTableViewCell.identififer) as! BmiTableViewCell
        let infoWeight: String = (infos[indexPath.row].value(forKey: "weight") as? NSNumber)!.stringValue
        let infoBMI: String = String(format: "%.2f", (infos[indexPath.row].value(forKey: "bmi") as? Float) as! CVarArg)

        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy"
        let infoDate: String = df.string(from: infos[indexPath.row].value(forKey: "date") as! Date)
        //let infoDate: String = df.string(from: infos[indexPath.row].value(forKey: "date") as! //Date)

        cell.configure(infoWeight: infoWeight, infoDate: infoDate, infoBMI: infoBMI)
        return cell
    }
    
    //Action Handler for Edit Info
    private func editinfo(indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
       
              
        
    }
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
    let rowNumber = indexPath.row

    print(rowNumber)

    performSegue(withIdentifier: "showDetail", sender: self)
        currentInfo=indexPath.row
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Info", in: managedContext)!
        let newInfo = NSManagedObject(entity: entity, insertInto: managedContext)
        newInfo.setValue(indexPath.row
                         , forKey: "indexpath")
       // self.currentInfo=indexPath.row

    //return rowNumber

    }*/
    //Action Handler for Delete Info
    private func deleteInfo(indexPath: IndexPath) {
        tableView.beginUpdates()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(infos[indexPath.row])
        do {
            try managedContext.save()
            infos.remove(at: indexPath.row)
        } catch let error as NSError {
            print("delete Error. \(error), \(error.userInfo)")
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }

    //Action Handler for swipe left to right
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editinfo(indexPath: indexPath)
                                            completionHandler(true)
            
        }
        edit.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    //Action Handler for Swipr right to left
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive,
                                       title: "Trash") { [weak self] (action, view, completionHandler) in
            self?.deleteInfo(indexPath: indexPath)
                                        completionHandler(true)
        }
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }


    
    
}

//Third VIew Controller Starts

class ThirdViewController: UIViewController,UITableViewDelegate{
    
    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var updateDate: UIDatePicker!
    @IBOutlet weak var updateWeight: UITextField!
    //var currentInfo: Int = self.indexPath.row
    
    var parentView: SecondViewController!
       var currentOperation: String = "Add"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  ActionButton.setTitle(currentOperation, for: UIControl.State.normal)
      //  if(currentOperation == "Update"){
        updateWeight.text = (infos[currentInfo].value(forKey: "weight") as? NSNumber)!.stringValue
     //   }
   }
    
    @IBAction func updateAction(_ sender: UIButton) {
        
        let weight: Float = (updateWeight.text! as NSString).floatValue
               // let update: Date = updateDate.date
                
        
        let bmi: Float = (weight as NSNumber).floatValue / (((heightConst as! NSNumber).floatValue) * (heightConst as! NSNumber).floatValue)
        guard let appDelegate =
                        UIApplication.shared.delegate as? AppDelegate else {
                        return
                      }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    
                    infos[currentInfo].setValue(weight, forKey: "weight")
                    infos[currentInfo].setValue(bmi, forKey: "bmi")
                    //infos[currentInfo].setValue(update, forKey: "date")
                    do {
                        try managedContext.save()
                        
                       // table.reloadData()
                        self.navigationController?.dismiss(animated: true)
                    } catch let error as NSError {
                        print("updateerror. \(error), \(error.userInfo)")
                    }
                    print("updated")
                }
    }
    
        
       
        
        
    

