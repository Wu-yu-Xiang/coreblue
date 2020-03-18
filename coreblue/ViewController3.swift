//
//  ViewController2.swift
//  coreblue
//
//  Created by chang on 2020/3/1.
//  Copyright © 2020 chang. All rights reserved.
//

import UIKit
import CoreBluetooth
class ViewController3: UIViewController, CBPeripheralDelegate {
    
    var char: CBCharacteristic!
    var peripheral: CBPeripheral!
    
    
    
    @IBOutlet weak var lbUUID: UILabel!
    @IBOutlet weak var lbPropHex: UILabel!
    @IBOutlet weak var lbProp: UILabel!
    
    
    
    @IBOutlet weak var btnRead: UIButton!
    @IBOutlet weak var tvResponse: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbUUID.text = char.uuid.uuidString
        lbProp.text = char.getPropertyContent()
        lbPropHex.text = String(format: "0x%02X", char.properties.rawValue)
        
        // Do any additional setup after loading the view.
    }


  /*  override func viewWillAppear(_ animated: Bool) {
        peripheral.delegate = self
       if !char.isReadable() {
            btnRead.isEnabled = false
        }
    } */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionRead(_ sender: UIButton) {

        peripheral.readValue(for: char)
    }
    
    /*private func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if characteristic.value != nil {
            tvResponse.text = ((data.getByteArray() as AnyObject).description)! + "\n" + tvResponse.text
        }
    }*/
    

    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view con.gue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
