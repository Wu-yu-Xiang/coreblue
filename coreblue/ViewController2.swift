//
//  ViewController.swift
//  coreblue
//
//  Created by chang on 2020/2/17.
//  Copyright © 2020 chang. All rights reserved.
//

import UIKit
import CoreBluetooth

class BTServiceInfo {
    var service: CBService!
    var characteristics: [CBCharacteristic]
    
    init(service: CBService, characteristics: [CBCharacteristic]) {
        self.service = service
        self.characteristics = characteristics
       
    }
}

class ViewController2: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    var centralManger: CBCentralManager!
    var peripheral: CBPeripheral!
    
    var btServices: [BTServiceInfo] = []
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("central state:\(central.state.rawValue)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CharacteristicCell", bundle: nil), forCellReuseIdentifier: "CharacteristicCell")

        centralManger.connect(peripheral, options: nil)
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    override func viewWillAppear(_ animated: Bool) {
        centralManger.delegate = self
        peripheral.delegate = self
    }
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    private func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        for serviceObj in peripheral.services! {
            let service:CBService = serviceObj
            let isServiceIncluded = self.btServices.filter({ (item: BTServiceInfo) -> Bool in
                return item.service.uuid == service.uuid
            }).count
            if isServiceIncluded == 0 {
                btServices.append(BTServiceInfo(service: service, characteristics: []))
            }
            peripheral.discoverCharacteristics(nil, for: service)
            
        }
    }
    
    private func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        let serviceCharacteristics = service.characteristics
        
        for item in btServices {
            if item.service.uuid == service.uuid {
                item.characteristics = serviceCharacteristics!
                break
            }
        }
        
        tableView.reloadData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return btServices[section].service.uuid.description
    }
    

    
   func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: CharacteristicCell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicCell") as! CharacteristicCell
        cell.lbUUID.text = btServices[indexPath.section].characteristics[indexPath.row].uuid.uuidString
        cell.lbPropHex.text = String(format: "0x%02X",btServices[indexPath.section].characteristics[indexPath.row].properties.rawValue)
        cell.lbProp.text = btServices[indexPath.section].characteristics[indexPath.row].getPropertyContent()
        cell.lbName.text = btServices[indexPath.section].characteristics[indexPath.row].uuid.uuidString
        cell.lbValue.text = btServices[indexPath.section].characteristics[indexPath.row].value?.description ?? "null"
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        self.performSegue(withIdentifier: "sgToCharDetail", sender: ["section": indexPath.section, "row": indexPath.row])
        
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(sender!)
        if segue.identifier == "sgToCharDetail" {
            let targetVC = segue.destination as! ViewController3
            targetVC.peripheral = self.peripheral
            targetVC.char = btServices[sender! as! Int].characteristics[sender! as! Int]
             //targetVC.char = btServices[sender!["section"] as! Int].characteristics[sender!["row"] as! Int]
        }
        
    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.5
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in TableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return btServices.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return btServices[section].characteristics.count
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        // Configure the cell...
        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
