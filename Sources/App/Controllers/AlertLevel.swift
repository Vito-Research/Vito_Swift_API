//
//  AlertLevel.swift
//  VitoMac
//
//  Created by Andreas Ink on 2/28/22.
//

import Foundation

struct AlertLevel {
    private var state: Level
    
    enum Level {
        case Green(Alert)
        case Yellow(Alert)
        case Red(Alert)
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
    }
    init() {
        self.state = .Green(Alert(cluster: Cluster(), median: Median(), hr: HR()))
    }
    mutating func resetAlertLevel() {
        self.state = .Green(Alert(cluster: Cluster(), median: Median(), hr: HR()))
        
    }
    func returnAlert() -> Double {
        switch self.state {
        case .Red(let alert):
            return alert.cluster.count >= 1 ? 1 : 0
        case .Yellow:
            return 0
        default:
            return 0
    }
    }
    mutating func calculateMedian(_ hr: Int) {
        switch self.state {
        case .Red(var alert):
            print("MEDIAN")
            print(alert.median.hr)
            print("AVG")
            print(hr)
            
            if let median = Healthv3().calculateMedian(array: alert.hr.hr.map{Double($0)}) {
                
                if hr >= Int(median) + 4 {
                    
                  
                    alert.median.hr = Int(median)
                    alert.hr.hr.append(hr)
                    alert.cluster.count += 1
                    self.state = .Red(alert)
                    
                } else {
                    alert.median.hr = Int(median)
                    alert.hr.hr.append(hr)
                    self.state = .Green(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
                }
            }
            
            break
        case .Yellow(var alert):
            alert.hr.hr.append(hr)
            if let median = Healthv3().calculateMedian(array: alert.hr.hr.map{Double($0)}) {
                alert.median.hr = Int(median)
                if hr >= Int(median) + 3 {
                   // alert.cluster.count += 1
                }
                if hr >= Int(median) + 4 {
                   // self.state = .Red(Alert(cluster: Cluster(), median: alert.median, average: alert.average, hr: alert.hr))
                }
            }
            
            break
        case .Green(var alert):
            
           
            if let median = Healthv3().calculateMedian(array: alert.hr.hr.map{Double($0)}) {
                
               
                
                print(median)
                if hr >= Int(median) + 4 {
                    alert.median.hr = Int(median)
                    alert.hr.hr.append(hr)
                    self.state = .Red(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
                } else {
                    alert.median.hr = Int(median)
                    alert.hr.hr.append(hr)
                    self.state = .Green(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
                }
            } else {
                alert.hr.hr.append(hr)
                self.state = .Green(Alert(cluster: Cluster(), median: alert.median, hr: alert.hr))
                print(hr)
            }
           
           
            break
        }
        
    }
    mutating func raiseAlertLevel() throws {
        switch self.state {
        case .Red(var alert):
            alert.cluster.count += 1
            break
        case .Yellow(var alert):
            alert.cluster.count += 1
            break
        case .Green(var alert):
            alert.cluster.count += 1
            break
        }
        print(self.state)
    }
}
