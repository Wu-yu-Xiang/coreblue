//
//  BTDeviceConfigViewController.swift
//  coreblue
//
//  Created by chang on 2020/3/1.
//  Copyright © 2020 chang. All rights reserved.
//

import UIKit
import CoreBluetooth
class ViewController1: UITableViewController, CBCentralManagerDelegate,CBPeripheralDelegate {

    
    var deviceList: NSMutableArray = []
    
    
    
    var btCentralManager: CBCentralManager!
    
    var btPeripherals: [CBPeripheral] = []
    var selectedPeripheral: CBPeripheral?
    var btRSSIs: [NSNumber] = []
    var btConnectable: [Int] = []
    
    @IBOutlet weak var bbRefresh: UIBarButtonItem!
    
    @IBAction func ActionRefresh(_ sender: UIBarButtonItem) {
        bbRefresh.isEnabled = false
        btConnectable.removeAll()
        btPeripherals.removeAll()
        btRSSIs.removeAll()
        tableView.register(UINib(nibName: "PeripheralCell", bundle: nil), forCellReuseIdentifier: "PeripheralCell")
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(CBCentralManager.stopScan), userInfo: nil, repeats: false)
        btCentralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    
    
    func scanForPeripheralsWithServices(_ seviceUUIDS:[CBUUID]?,options:[String: AnyObject]?){
        self.btCentralManager?.scanForPeripherals(withServices: seviceUUIDS, options: options)
    }
    

    func stopScan() {
        btCentralManager.stopScan()
        bbRefresh.isEnabled = true
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btCentralManager.delegate = self
        if selectedPeripheral != nil {
            btCentralManager.cancelPeripheralConnection(selectedPeripheral!)
        }
    }
    
     public enum CBManagerState : Int{
        case unknow
        case resetting
        case unsupported
        case unauthorized
        case powerOff
        case powerOn
    } 
   

    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
        let cell: PeripheralCell = tableView.dequeueReusableCell(withIdentifier: "PeripheralCell") as! PeripheralCell
        cell.lbConntable.text = btConnectable[indexPath.row].description
        cell.lbName.text = btPeripherals[indexPath.row].name
        cell.lbRSSI.text = btRSSIs[indexPath.row].description
        cell.lbUUID.text = btPeripherals[indexPath.row].identifier.uuidString
        cell.accessoryType = .disclosureIndicator
        
        return cell

    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let targetVC = segue.destination as! ViewController2
        targetVC.centralManger = self.btCentralManager
        selectedPeripheral = btPeripherals[sender as! Int]
        targetVC.peripheral = selectedPeripheral
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.5
    }
    
     override func numberOfSections(in tableView: UITableView) -> Int {
           return 0
           //return 1
       }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return btPeripherals.count
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        btCentralManager = CBCentralManager(delegate: self, queue: nil)
        tableView.register(UINib(nibName: "PeripheralCell", bundle: nil), forCellReuseIdentifier: "PeripheralCell")
    }
    
    
    

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
     print(central.state)
        
    }
    
    
    
    ///////////////////////////////
    ////////////////////////////////////
    
    
    
    
    private func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
       let temp = btPeripherals.filter { (pl) -> Bool in
            return pl.identifier.uuidString == peripheral.identifier.uuidString
        }
        
        if temp.count == 0 {
            btPeripherals.append(peripheral)
            btRSSIs.append(RSSI)
            btConnectable.append(Int(advertisementData[CBAdvertisementDataIsConnectable]!.description)!)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath as IndexPath, animated: true)
           self.performSegue(withIdentifier: "PeripheralCell", sender: indexPath.row)
       }
       

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
