//
//  connect.swift
//  coreblue
//
//  Created by chang on 2020/2/27.
//  Copyright © 2020 chang. All rights reserved.
//

import UIKit
import CoreBluetooth

class BTDeviceConfigViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CBPeripheralDelegate,CBCentralManagerDelegate {
    var peripheral: CBPeripheral!
    var centralManager: CBCentralManager!
    
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        tableView.deselectRow(at: indexPath as IndexPath,animated: true)
        self.performSegueWithIdentifier("sgToBTDeviceConfig",sender:BTPeripheral[indexPath.Row])
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,sender: AnyObject?){
        if segue.identifier == "sgToBTDeviceConfig"{
            let targetVC = segue.destinationViewController as!BTDeviceConfigViewController
            targetVC.peripheral = sender as! CBPeripheral
            targetVC.btDeviceName = (sender as! CBPeripheral).name
            targetVC.centralManager = self.myCenteralManager
        }
    }
    
    //將傳送過來的centralManager和peripheral的delegate都設為當起前這個UIViewController，這樣來監聽發生的事件，
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle.title = btDeviceName
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
        //此行為連線，option後是放篩選條件，當執行connect，我們能拿到這個peripheral所提供的service(CBService)和所屬該service的特徵值(CBCharacteristic)
        
        tbvServices.delegate = self
        tbvServices.dataSource = self
        btServices = []
        if peripheral.state == CBPeripheralState.connected{
            bbConnect.title = "Connected"
            bbConnect.enabled = false
        }
        tbvServices.registerNib(UINib(nibName: "BTServiceTableViewCell", bundle: nil),forCellReuseIdentifier:"BTServiceTableViewCell")
    }
    //navTitle是navigation bar 的title,這邊也讓他就是這個藍牙裝置的名稱
    //bvServices是放service列表的tableview
    //btService是放搜尋到的服務的容器
    
    //一個peripheral可能有多個service，一個service可能有多個characteristic，真正拿來和裝置溝通的是各種不同的characteristic，此系列的目的就是要找到客制化藍牙裝置到底是要哪幾個characteristic做通訊
    
    
    
    func centralManager(_ central: CBCentralManager,didConnect peripheral:CBPeripheral) {
        if peripheral.state == CBPeripheralState.connected{
            bbConnect.title = "Connected"
            bbConnect.enabled = false
            peripheral.discoverServices(nil)
        }
    }
    
    class BTServiceInfo{         //自定義個類別來存放
        var service: CBService
        var characteristics:[CBCharacteristic]
        init(service:CBService,characteristics:[CBCharacteristic]){
            self.service = service
            self.characteristics = characteristics
        }
    }
    
    //把Service資訊放到容器中
    //btServices裡面放BTServiceInfo物件，所以在掃描到新的service的時候先判斷是否已經在容器裡，如果沒有就加入
    func peripheral(peripheral: CBPeripheralDelegate,didDiscoverService error: NSError?){
        for serviceObj in peripheral.services!{
            let service:CBService = serviceObj
            let isServiceIncluded = self.btServices.filter({(item:BTServiceInfo)-&gt;Bool in return item.service.UUID == service.UUID}).count
            
            if isServiceIncluded == 0{
                btServices.append(BTServiceInfo(service: service, characteristics: []))
            }
            peripheral.discoverCharacteristics(nil,forService:service)
        }
    }
    
    func peripheral(peripheral:CBPeripheral, didDiscoverCharacteristicsForService service:CBService,error: NSError?){
        let serviceCharacteristics = service.characteristics
        for item in BTServices{
            if item.service.UUID == service.UUID{
                item.characteristics = serviceCharacteristics!
                break
            }
        }
        tbvServices.reloadData()
    }
    
    
    //用extension去判斷Characteristic包含哪些屬性
    
    extension CBCharacteristic{
        
        func isWritable() -> Bool{
            return(self.properties.intersection(CBCharacteristicProperties.write)) != []
        }
        
        func isReadable() -> Bool{
            return(self.properties.intersection(CBCharacteristicProperties.read)) != []
        }
        
        func isWritableWithoutResponse() -> Bool {
            return(self.properties.intersection(CBCharacteristicProperties.notify)) != []
        }
        
        func isNotifable() -> Bool{
            return(self.properties.intersection(CBCharacteristicProperties.notify)) != []
        }
        
        func isIndicatable() -> Bool{
            return(self.properties.intersection(CBCharacteristicProperties.indicate)) != []
        }
        
        func isBroadcastable() -> Bool{
            return(self.properties.intersection(CBCharacteristicProperties.broadcast)) != []
        }
        
        func isExtendedProperties() -> Bool{
            return(self.properties.intersection(CBCharacteristicProperties.extendedProperties)) != []
        
        }
        
        func isAuthenticatedSignedWrites() -> Bool{
            return(self.properties.intersection(CBCharacteristicProperties.authenticatedSignedWrites)) != []
        }
        
        func isNotifyEncryptionRequired() -> Bool{
            return(self.properties.intersection(CBCharacteristicProperties.notifyEncryptionRequired)) != []
        }
        
        func isIndicateEncryptionRequired() -> Bool{
            return(self.properties.intersection(CBCharacteristicProperties.indicateEncryptionRequired)) != []
        }
    }
    
    
    func getPropertyContent() -> String {
            var propContent = ""
            if (self.properties.intersect(CBCharacteristicProperties.Broadcast)) != [] {
                propContent += "Broadcast,"
            }
            if (self.properties.intersect(CBCharacteristicProperties.Read)) != [] {
                propContent += "Read,"
            }
            if (self.properties.intersect(CBCharacteristicProperties.WriteWithoutResponse)) != [] {
                propContent += "WriteWithoutResponse,"
            }
            if (self.properties.intersect(CBCharacteristicProperties.Write)) != [] {
                propContent += "Write,"
            }
            if (self.properties.intersect(CBCharacteristicProperties.Notify)) != [] {
                propContent += "Notify,"
            }
            if (self.properties.intersect(CBCharacteristicProperties.Indicate)) != [] {
                propContent += "Indicate,"
            }
            if (self.properties.intersect(CBCharacteristicProperties.AuthenticatedSignedWrites)) != [] {
                propContent += "AuthenticatedSignedWrites,"
            }
            if (self.properties.intersect(CBCharacteristicProperties.ExtendedProperties)) != [] {
                propContent += "ExtendedProperties,"
            }
            if (self.properties.intersect(CBCharacteristicProperties.NotifyEncryptionRequired)) != [] {
                propContent += "NotifyEncryptionRequired,"
            }
            if (self.properties.intersect(CBCharacteristicProperties.IndicateEncryptionRequired)) != [] {
                propContent += "IndicateEncryptionRequired,"
            }
            return propContent
        }
    
    
    
    
    }
    
    

