//
//  Healthv4.swift
//  VitoMac
//
//  Created by Andreas Ink on 2/25/22.
//

import SwiftUI

class Healthv4: Healthv3 {
    
    func getRiskScorev3(_ health: [HealthData], avgs: [HealthData]) -> [HealthData]
   {
       
       var riskScores = [HealthData]()
       
       var alertLvl = AlertLevelv3()
       
       var confirmedRedAlerts = [HealthData]()
      // Alert level stays persistant through the loop
       
       // let medianOfAvg = calculateMedian(array: avgs.map{$0.data})
       for (avg, i2) in Array(zip(avgs, avgs.indices)) {
           // Needs more than 3 days to calculate
          // if i2 > 3 {
               // Gets the median of averages up to night i2
           alertLvl.calculateMedian((Int(avg.data)), avg.date)
          // print(alertLvl)
           riskScores.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: avg.date, data: Double(Int(avg.data)), risk: alertLvl.returnAlert()))
//           let filteredAvgs = (avgs.dropLast((avgs.count - i2)))//.filter{!redAlerts.map{$0.date.formatted(date: .numeric, time: .omitted)}.contains($0.date.formatted(date: .numeric, time: .omitted))}
//               let medianOfAvg = calculateMedian(array: filteredAvgs.map{$0.data})
           
              // }
       }
//       var track = [HealthData]()
//       for (avg, i2) in Array(zip(redAlerts, redAlerts.indices)) {
//
//           let today = avg
//           if redAlerts.indices.contains(i2 + 1) {
//           let next = redAlerts[i2 + 1]
//               if next.date.distance(to: today.date) <= 86400 {
//           if(track.contains(today)) {
//               confirmedRedAlerts.append(redAlerts[i2 + 1])
//               track.append(next)
//           } else {
//               confirmedRedAlerts.append(redAlerts[i2 + 1])
//               track.append(today)
//               track.append(next)
//           }
//               }
//
//       }
//
//       }
      
       // Return risk scores
      
   
       return riskScores
}
     func getRiskScorev2(_ health: [HealthData], avgs: [HealthData]) -> [HealthData]
    {
        
        var riskScores = [HealthData]()
        
        var redAlerts = [HealthData]()
        
        var confirmedRedAlerts = [HealthData]()
       // Alert level stays persistant through the loop
        var alertLvl = 0
        // let medianOfAvg = calculateMedian(array: avgs.map{$0.data})
        for (avg, i2) in Array(zip(avgs, avgs.indices)) {
            // Needs more than 3 days to calculate
           // if i2 > 3 {
                // Gets the median of averages up to night i2
            
            let filteredAvgs = (avgs.dropLast((avgs.count - i2))).filter{!redAlerts.map{$0.date.formatted(date: .numeric, time: .omitted)}.contains($0.date.formatted(date: .numeric, time: .omitted))}
            if let medianOfAvg = calculateMedian(array: filteredAvgs.map{$0.data}) {
            
                if (avg.data >= Double(medianOfAvg) + 4.0) {
                    redAlerts.append(avg)
                }
            }
               // }
        }
        var track = [HealthData]()
        for (avg, i2) in Array(zip(redAlerts, redAlerts.indices)) {
            
            let today = avg
            if redAlerts.indices.contains(i2 + 1) {
            let next = redAlerts[i2 + 1]
                if next.date.distance(to: today.date) <= 86400 {
            if(track.contains(today)) {
                confirmedRedAlerts.append(redAlerts[i2 + 1])
                track.append(next)
            } else {
                confirmedRedAlerts.append(redAlerts[i2 + 1])
                track.append(today)
                track.append(next)
            }
                }
            
        }
            
        }
        for (avg, i2) in Array(zip(avgs, avgs.indices)) {
            riskScores.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: avg.date, data: avg.data, risk: confirmedRedAlerts.map{$0.date.formatted(date: .numeric, time: .omitted)}.contains(avg.date.formatted(date: .numeric, time: .omitted)) ? 1 : 0))
        }
        // Return risk scores
       
    
        return riskScores
}
}
