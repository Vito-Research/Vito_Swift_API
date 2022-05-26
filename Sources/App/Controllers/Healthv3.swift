//
//  Healthv3.swift
//  VitoCommandLine
//
//  Created by Andreas Ink on 2/21/22.
//

import SwiftUI
import Combine
import Accelerate

// Makes class stay on main thread

class Healthv3: ObservableObject {
    
    // @UserDefault saves the data locally
    // Saves all risk scores locally
     var codableRisk: [CodableRisk] =  [CodableRisk]()
    
    // Saves median of averages to skip data query
    @Published  var medianOfAvgs: Double = 0
    
    @Published var uses2: Int = 0
    
    // Stores avg hr per night
    private var avgs: [HealthData] = [HealthData]()
    
    // Current night's risk
    //@Published var risk = Risk(id: UUID().uuidString, risk: 21, explanation: [Explanation(image: "", explanation: "Loading", detail: "")])
    
    // Used for DataView to select a date
    @Published var queryDate = Query(id: "", durationType: .Day, duration: 1, anchorDate: Date())
    
    // Stores healthdata
    private var healthData = [HealthData]()
    
    // Stores risk data
     //var riskData = [HealthData]()
    
    // Class to retrieve health data
   
    
    // Combine tool, a protocol indicating that an activity or action supports cancellation.
    var cancellableBag = Set<AnyCancellable>()
    
    // The health data read
   
    
    // The units of the readData
   
    
    // The quanity types of the readData
    let quanityTypes: [String] = ["Avg", "", "Avg"]
    
    // HR data only
    private var hrData = [HealthData]()
    
    // Initiates calendar
    @Environment(\.calendar) var calendar
    
    // Used for codde below
    let interval = DateInterval()
    
    // Generates months
    var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    
    // Called on class initialization
    init() {
        // Gets when user is alseep and gets risk score
        //getWhenAsleep()
        
    }
   
   
    func backgroundDelivery() {
        
    }
//    func getWhenAsleep() {
//        // Gets the date 12 months ago
//        // if value = -12, becomes more sensitive
//        if let earlyDate = Calendar.current.date(
//            byAdding: .month,
//            value: -12,
//            to: Date()) {
//            // Loops through the dates by adding a day
//            for date in Date.dates(from: Calendar.current.startOfDay(for: earlyDate), to: Date()) {
//                if let earlyDate = Calendar.current.date(
//                    byAdding: .hour,
//                    value: 12,
//                    to: date) {
//                    // Loop through the hours in a day
//                    for date in Date.datesHourly(from: date, to: earlyDate) {
//                        // Get RR in that hour
//                        getHealthData(startDate: date.addingTimeInterval(-3600), endDate: date.addingTimeInterval(3600), i: 2) { sleep in
//                            // If RR exists for that date keep going
//                            if let sleep =  sleep {
//                                // Loop through each hour within the time period of the RR
//                                for date in Date.datesHourly(from: sleep.date, to: sleep.endDate ?? Date()) {
//
//                                    // Get if steps are present in the time range
//                                    self.getHealthData(startDate: date.addingTimeInterval(-3600), endDate: date.addingTimeInterval(3600), i: 1) { steps in
//
//                                        // If steps are no-existant or below 100 for that hour, query HR data
//                                        if steps == nil || (steps?.data ?? 0) < 100 {
//
//                                            self.getHealthData(startDate: date.addingTimeInterval(-3600), endDate: date.addingTimeInterval(3600), i: 0) { hr in
//                                                if let hr =  hr {
//                                                    self.hrData.append(hr)
//
//                                                }
//
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//
//                    }
//                }
//            }
//        }
//        // After 5 seconds, get the average per night
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//
//            self.avgs = self.getAvgPerNight(self.hrData)
//
//            // After 5 seconds, get the risk score per night
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                let risks  = self.getRiskScore(self.hrData, avgs: self.avgs)
//                // Set the riskData to risks
//                self.riskData = risks
//                // Set risk (the last night's risk) to the last risk
//                if let lastRisk = risks.last?.risk {
//                    let explanation =  lastRisk > 0 ? [Explanation(image: .exclamationmarkCircle, explanation: "Your heart rate while asleep is abnormally high compared to your previous data", detail: ""), Explanation(image: .app, explanation: "This can be a sign of disease, intoxication, lack of sleep, or other factors.", detail: ""), Explanation(image: .stethoscope, explanation: "This is not medical advice or a diagnosis, it's simply a datapoint to bring up to your doctor", detail: "")] : [Explanation(image: .checkmark, explanation: "Your heart rate while asleep is normal compared to your previous data", detail: ""), Explanation(image: .stethoscope, explanation: "This is not a medical diagnosis or lack thereof, it's simply a datapoint to bring up to your doctor", detail: "")]
//                    self.risk = Risk(id: UUID().uuidString, risk: lastRisk, explanation: explanation)
//                }
//            }
//
//        }
//    }
    
//    func getHealthData(startDate: Date, endDate: Date, i: Int, completionHandler: @escaping (HealthData?) -> Void) {
//
//        healthStore
//        // Stat = average in a time period or total amount in a time period
//            .statistic(for: Array(readData)[i], with: self.quanityTypes[i] == "Avg" ? .discreteAverage : .cumulativeSum, from: startDate, to: endDate, 1000)
//
//            .receive(on: DispatchQueue.main)
//
//            .sink(receiveCompletion: { subscription in
//                // If error (no stats) then return nil
//                if "\(subscription)".contains("failure") {
//                    completionHandler(nil)
//                }
//
//            }, receiveValue: { stat in
//
//
//                // If there's smaples then add the sample to healthData
//                if let quanity = self.quanityTypes[i] == "Avg" ? stat.averageQuantity()?.doubleValue(for: self.units[i]) : stat.sumQuantity()?.doubleValue(for: self.units[i]) {
//                    if !quanity.isNaN {
//
//                        // Return the health data
//                        completionHandler(HealthData(id: "\(i)", type: DataType(rawValue: Array(self.readData)[i].identifier) ?? .Health, title: Array(self.readData)[i].identifier, text: Array(self.readData)[i].identifier, date: stat.startDate, endDate: stat.endDate, data: quanity))
//
//                    } else {
//                        completionHandler(nil)
//                    }
//
//                } else {
//                    completionHandler(nil)
//                }
//
//
//            }
//
//
//            ).store(in: &cancellableBag)
//
//
//
//    }
 // Calculates median
    func calculateMedian(array: [Double]) -> Float? {
        let sorted = array.sorted().filter{!$0.isNaN}
        if !sorted.isEmpty {
            if sorted.count % 2 == 0 {
                return Float((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2
            } else {
                return Float(sorted[(sorted.count - 1) / 2])
            }
        }
        
        return nil
    }
    
    // Gets risk score
    func getRiskScore(_ health: [HealthData], avgs: [HealthData]) -> [HealthData] {
        
        var riskScores = [HealthData]()
        
        var redAlerts = [HealthData]()
       // Alert level stays persistant through the loop
        var alertLvl = 0
        // let medianOfAvg = calculateMedian(array: avgs.map{$0.data})
        for (avg, i2) in Array(zip(avgs, avgs.indices)) {
            // Needs more than 3 days to calculate
            if i2 > 3 {
                // Gets the median of averages up to night i2
                let filteredAvgs = (avgs.dropLast((avgs.count - i2) ))//.filter{!redAlerts.map{$0.date.formatted(date: .numeric, time: .omitted)}.contains($0.date.formatted(date: .numeric, time: .omitted))}
                if let medianOfAvg = calculateMedian(array: filteredAvgs.map{$0.data}) {
            
                // if avg.date.getTimeOfDay() == "Night" {
                
                // If the medianOfAvg + 3 is greater than the data, then alertLvl is set to zero
                if avg.data < (Double(medianOfAvg) + 3.0)   {
                    // if alertLvl != 0 {
                    
                    alertLvl = 0
                    // }
                } else {
                    // Switch through each alert possibility
                    switch(alertLvl) {
                    case 0:
                        if avg.data >= (Double(medianOfAvg) + 4.0)  {
                            alertLvl = 2
                        } else if avg.data >= (Double(medianOfAvg) + 3.0) {
                            alertLvl = 1
                        }
                        break
                                        
                                        case 1:
                                            if avg.data >= (Double(medianOfAvg) + 4.0)  {
                                                alertLvl = 4
                                            } else if avg.data >= (Double(medianOfAvg) + 3.0) {
                                                alertLvl = 3
                                            }
                                            break
                                        case 2:
                                            if avg.data >= (Double(medianOfAvg) + 4.0)  {
                                                alertLvl = 5
                                            }  else if avg.data >= (Double(medianOfAvg) + 3.0) {
                                                alertLvl = 3
                                            }
                                            break
                                        case 3:
                                            if avg.data >= (Double(medianOfAvg) + 4.0)  {
                                                alertLvl = 4
                                            }  else {
                                                // alertLvl = 3
                                            }
                                            break
                    
                                        // Yellow Alert Level
                                        case 4:
                                            if avg.data >= (Double(medianOfAvg) + 4.0)  {
                                                alertLvl = 5
                                            } else if avg.data >= (Double(medianOfAvg) + 3.0)  {
                    
                                                alertLvl = 3
                                            }
                                            break
                    
                                        // Red Alert Level
                                        case 5:
                                            if avg.data >= (Double(medianOfAvg) + 4.0) {
                                                alertLvl = 5
                                                redAlerts.append(avg)
                                            } else if avg.data >= (Double(medianOfAvg) + 3.0) {
                                                alertLvl = 3
                                            }
                                            break
                        
                                        default:
                                            alertLvl = 0
                                            break
                                        }
//                    switch(alertLvl) {
//                    case 0:
//                        if avg.data >= (Double(medianOfAvg) + 4.0)  {
//                            alertLvl = 2
//                        } else if avg.data >= (Double(medianOfAvg) + 3.0) {
//                            alertLvl = 1
//                        }
//                        break
//                    case 1:
//                        if avg.data >= (Double(medianOfAvg) + 4.0)  {
//                            alertLvl = 5
//                        } else if avg.data >= (Double(medianOfAvg) + 3.0) {
//                            alertLvl = 3
//                        }
//                        break
//                    case 2:
//                        if avg.data >= (Double(medianOfAvg) + 4.0)  {
//                            alertLvl = 5
//                        }  else if avg.data >= (Double(medianOfAvg) + 3.0) {
//                            alertLvl = 3
//                        }
//                        break
//                    case 3:
//                        if avg.data >= (Double(medianOfAvg) + 4.0)  {
//                            alertLvl = 4
//                        }  else {
//                            alertLvl = 3
//                        }
//                        break
//
//                    // Yellow Alert Level
//                    case 4:
//                        if avg.data >= (Double(medianOfAvg) + 4.0)  {
//                            alertLvl = 5
//                        } else if avg.data >= (Double(medianOfAvg) + 3.0)  {
//
//                            alertLvl = 3
//                        }
//                        break
//
//                    // Red Alert Level
//                    case 5:
//                        if avg.data >= (Double(medianOfAvg) + 4.0) {
//                            alertLvl = 5
//                        } else if avg.data >= (Double(medianOfAvg) + 3.0) {
//                            alertLvl = 3
//                        }
//                        break
//                    default:
//                        alertLvl = 0
//                        break
//                    }
                    
                    
                   
                }
                
            }
            // Append the risk score
            
//            if avg.data >= medianOfAvgs + 4 {
//                alertLvl = 5
//            }
            riskScores.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: avg.date, data: avg.data, risk: alertLvl > 4 ? 1 : 0))
        }
        }
        
        // Return risk scores
        return riskScores
    }
    func getAvgPerNight(_ health2: [HealthData]) -> [HealthData]  {
        var avgs = [HealthData]()
        // Reset averages
        
        // Filter to valid HR data
        let health = health2.filter {
        #warning("disabled Night")
            return $0.title == "" && !$0.data.isNaN && $0.date.getTimeOfDay() == "Night"
        }
        // Get start and end data
        let dates =  health.map{$0.date}.sorted(by: { $0.compare($1) == .orderedAscending })
        if let startDate = dates.first {
            
            
            if let endDate = dates.last {
                
                for date in Date.dates(from: startDate, to: endDate) {
                    
                    let todaysDate = health.filter{$0.date.get(.day) == date.get(.day) && $0.date.get(.month) == date.get(.month) && $0.date.get(.year) == date.get(.year)}
                    let avg = average(numbers: todaysDate.map{$0.data})
                    if  !avg.isNaN {
                        avgs.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: date, data: avg))
                        
                    } else {
                        if let first = todaysDate.map({$0.data}).first {
                            avgs.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: date, data: first))
                        } else {
                            if avgs.indices.contains(avgs.count - 2) {
                            avgs.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: date, data: average(numbers: [avgs.last?.data ?? 0, avgs[avgs.count - 2].data])))
                            } else {
                                
                            }
                        }
                    }
                }
            }
            
        }
        return avgs
    }
    
    func average(numbers: [Double]) -> Double {
        // print(numbers)
        
        return vDSP.mean(numbers)
    }
    func populateAveragesData(_for targetDates: [Date], low: Int, high: Int, stepDates: [Date]) {
        
        var noDates = [String]()
        if let earlyDate = Calendar.current.date(
            byAdding: .month,
            value: -12,
            to: Date()) {
            for date in Date.dates(from: Calendar.current.startOfDay(for: earlyDate), to: Date()) {
                
            
                for date in stepDates {
                    self.hrData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: date, data: 100))
                    print(date)
                }
               // for hour in 0...6 {
                    
                  
                    if targetDates.map({$0.formatted(date: .abbreviated, time: .omitted)}).contains( date.formatted(date: .abbreviated, time: .omitted)) {
                        for i in 0...3 {
                            self.hrData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: date.addingTimeInterval(TimeInterval(1200 * i)), data: Double(high)))
                        }
                    } else {
                        for i in 0...3 {
                            self.hrData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: date.addingTimeInterval(TimeInterval(1200 * i)), data: Double(low)))
                        }
                    }
                    
                    noDates = self.hrData.filter{$0.data < 2 && $0.title == ""}.map{"\($0.date.get(.hour))" + "\($0.date.get(.day))" + "\($0.date.get(.month))"}
                    
                    
              //  }
                
            }
        }
        
        
        var filteredData = self.hrData.filter{!noDates.contains("\($0.date.get(.hour))" + "\($0.date.get(.day))" + "\($0.date.get(.month))") && $0.title == "" && $0.data < 200 && $0.data > 40}
        filteredData = filteredData.sliced(by: [.year, .month, .day], for: \.date).map{ HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: $0.key, data: self.average(numbers: $0.value.map{$0.data}))}
        filteredData =  filteredData.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        // print(filteredData.map{$0.date})
        self.getAvgPerNight(filteredData)
//        let risks  = self.getRiskScore(filteredData, avgs: self.avgs)
//        print(risks)
//        
//        for risk in risks {
//            self.codableRisk.append(CodableRisk(id: UUID().uuidString, date: risk.date, risk: risk.data, explanation: []))
//        }
    }
    func formatDate(_ startDate: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        return dateFormatterGet.string(from: startDate)
        
    }
    
    func formatDate(_ startDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: startDate) {
            return dateFormatterPrint.string(from: date)
            
        } else {
            print("There was an error decoding the string")
        }
        return ""
    }
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
