//
////
// FileName:   BmiTableViewCell.swift
// Project Name: MAPD714_FInalTest_Fathima
//Author anme: Fathima Fathila
//Student Id: 301222885
//Course: MAPD714_IOS_Final Exam
//This is a simple Bmi calculator application which uses table view cemm to read , write and delete //from  Persistent Data Storage.

//  Created by fathila on 2021-12-15.
//

import UIKit

class BmiTableViewCell: UITableViewCell {
    static let identififer = "BmiTableViewCell"

    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bmi: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "BmiTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func configure(infoWeight: String, infoDate: String, infoBMI: String){
        weight.text = infoWeight
        date.text = infoDate
        bmi.text = infoBMI
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
