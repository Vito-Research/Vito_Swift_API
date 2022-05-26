//
//  AlertLevelv2.swift
//  VitoMac
//
//  Created by Andreas Ink on 3/2/22.
//

import Foundation
import Accelerate

struct AlertLevelv2 {
    private var state: Level
    
    enum Level {
        case Zero(Alert)
        case One(Alert)
        case Two(Alert)
        case Three(Alert)
        case Four(Alert)
        case Five(Alert)
    }
    struct Alert {
        var cluster: Cluster
        var median: Median
        var hr: HR
        
    }
    struct Cluster {
        var count: Int = 0
    }
    struct Median {
        var hr: Int = 0
    }
    struct HR {
        var hr: [Int] = []
        var lastDate: Date?
        var date: Date?
    }
    init() {
        self.state = .Zero(Alert(cluster: Cluster(), median: Median(), hr: HR()))
    }
    mutating func resetAlertLevel() {
        self.state = .Zero(Alert(cluster: Cluster(), median: Median(), hr: HR()))
        
    }
    func returnAlert() -> Double {
        switch self.state {
        case .Five(let alert):
            return alert.cluster.count >= 0 ? 1 : 0
      
        default:
            return 0
    }
    }
    var previousDate = Date()
    
    mutating func calculateMedian(_ hr: Int, _ date: Date?) {
        
        switch self.state {
            
        case .Five(var alert):
            alert.hr.date = date
            alert.hr.hr.append(hr)
            // if Calendar.current.dateComponents([.day], from: alert.hr.lastDate ?? Date(), to: date ?? Date().addingTimeInterval(840000)).day ?? 100 < 2 {
            if let median = Healthv3().calculateMedian(array: alert.hr.hr.map{Double($0)}) {
                
                if hr >= Int(median) + 4 {
                    
                    
                    alert.median.hr = Int(median)
                    
                    
                    alert.cluster.count += 1
                    alert.hr.lastDate = alert.hr.date
                    self.state = .Five(alert)
                    
                } else if hr == Int(median) + 3 {
                    alert.median.hr = Int(median)
//                    alert.hr.hr.append(hr)
                    alert.hr.lastDate = alert.hr.date
                    self.state = .Three(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
                } else {
                    alert.median.hr = Int(median)
//                    alert.hr.hr.append(hr)
                    alert.hr.lastDate = alert.hr.date
                    self.state = .Zero(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
                }
            }
            
            
            break
        case .Four(var alert):
            alert.hr.date = date
            // if Calendar.current.dateComponents([.day], from: alert.hr.lastDate ?? Date(), to: date ?? Date().addingTimeInterval(840000)).day ?? 100 < 2 {
            alert.hr.hr.append(hr)
            if let median = Healthv3().calculateMedian(array: alert.hr.hr.map{Double($0)}) {
               
                if hr >= Int(median) + 4 {
                    
                  
                    alert.median.hr = Int(median)
//                    alert.hr.hr.append(hr)
                    alert.hr.lastDate = alert.hr.date
                    self.state = .Five(alert)
                    
                } else if hr == Int(median) + 3 {
                    alert.median.hr = Int(median)
//                    alert.hr.hr.append(hr)
                    alert.hr.lastDate = alert.hr.date
                    self.state = .Three(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
                } else {
                    alert.median.hr = Int(median)
                    
                    alert.hr.lastDate = alert.hr.date
                    self.state = .Zero(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
                }
            }
            
            break
        case .Three(var alert):
            alert.hr.date = date
            // if Calendar.current.dateComponents([.day], from: alert.hr.lastDate ?? Date(), to: date ?? Date().addingTimeInterval(840000)).day ?? 100 < 2 {
            alert.hr.hr.append(hr)
            if let median = Healthv3().calculateMedian(array: alert.hr.hr.map{Double($0)}) {
                if hr >= Int(median) + 4 {
                    
                  
                    alert.median.hr = Int(median)
                   
                    alert.hr.lastDate = alert.hr.date
                    self.state = .Four(alert)
                    
                } else if hr == Int(median) + 3 {
                    alert.median.hr = Int(median)
//                    alert.hr.hr.append(hr)
                    alert.hr.lastDate = alert.hr.date
                    self.state = .Three(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
                } else {
                    alert.median.hr = Int(median)
//                    alert.hr.hr.append(hr)
                    alert.hr.lastDate = alert.hr.date
                    self.state = .Zero(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
                }
            }
       
           
            break
        
        case .Two(var alert):
            alert.hr.date = date
            alert.hr.hr.append(hr)
            // if Calendar.current.dateComponents([.day], from: alert.hr.lastDate ?? Date(), to: date ?? Date().addingTimeInterval(840000)).day ?? 100 < 2 {
            if let median = Healthv3().calculateMedian(array: alert.hr.hr.map{Double($0)}) {
            if hr >= Int(median) + 4 {
                
              
                alert.median.hr = Int(median)
                
                alert.hr.lastDate = alert.hr.date
                self.state = .Five(alert)
                
            } else if hr == Int(median) + 3 {
                alert.median.hr = Int(median)
//                alert.hr.hr.append(hr)
                alert.hr.lastDate = alert.hr.date
                self.state = .Three(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
            } else {
                alert.median.hr = Int(median)
//                alert.hr.hr.append(hr)
                alert.hr.lastDate = alert.hr.date
                self.state = .Zero(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
            }
            } 
        
            break
        case .One(var alert):
            alert.hr.date = date
            alert.hr.hr.append(hr)
            // if Calendar.current.dateComponents([.day], from: alert.hr.lastDate ?? Date(), to: date ?? Date().addingTimeInterval(840000)).day ?? 100 < 2 {
            if let median = Healthv3().calculateMedian(array: alert.hr.hr.map{Double($0)}) {
            if hr >= Int(median) + 4 {
                
              
                alert.median.hr = Int(median)
//                alert.hr.hr.append(hr)
                alert.hr.lastDate = alert.hr.date
                self.state = .Four(alert)
                
            } else if hr == Int(median) + 3 {
                alert.median.hr = Int(median)
//                alert.hr.hr.append(hr)
                alert.hr.lastDate = alert.hr.date
                self.state = .Three(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
            } else {
                alert.median.hr = Int(median)
//                alert.hr.hr.append(hr)
                alert.hr.lastDate = alert.hr.date
                self.state = .Zero(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
            }
            }
            
            alert.hr.lastDate = alert.hr.date
            break
        case .Zero(var alert):
            alert.hr.date = date
            alert.hr.hr.append(hr)
            // if Calendar.current.dateComponents([.day], from: alert.hr.lastDate ?? Date(), to: date ?? Date().addingTimeInterval(840000)).day ?? 100 < 2 {
            if let median = Healthv3().calculateMedian(array: alert.hr.hr.map{Double($0)}) {
            if hr >= Int(median) + 4 {
                
              
                alert.median.hr = Int(median)
//                alert.hr.hr.append(hr)
                alert.hr.lastDate = alert.hr.date
                self.state = .Two(alert)
                
            } else if hr == Int(median) + 3 {
                alert.median.hr = Int(median)
//                alert.hr.hr.append(hr)
                alert.hr.lastDate = alert.hr.date
                self.state = .One(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
            } else {
                alert.median.hr = Int(median)
//                alert.hr.hr.append(hr)
                alert.hr.lastDate = alert.hr.date
                self.state = .Zero(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
            }
            } else {
               
//                alert.hr.hr.append(hr)
                alert.hr.lastDate = alert.hr.date
                self.state = .Zero(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
            }
           
           
            
            }
            
    
        

    
//    mutating func raiseAlertLevel() throws {
//        switch self.state {
//        case .Red(var alert):
//            alert.cluster.count += 1
//            break
//        case .Yellow(var alert):
//            alert.cluster.count += 1
//            break
//        case .Green(var alert):
//            alert.cluster.count += 1
//            break
//        }
//        print(self.state)
//    }
}
    func calcAlert(_ alert: Alert, _ currentLvl: Level) {
        
    }
}
