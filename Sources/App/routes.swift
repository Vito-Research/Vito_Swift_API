import Vapor
import TabularData

let health = Healthv3()
var healthData = [HealthData]()
func routes(_ app: Application) throws {
    
    app.post { req async throws -> [Double] in
        struct Input: Codable {
            var arr: [Double]
        }
      
            let input = try req.content.decode(Input.self)
        print(input)
            
//            let path = app.directory.publicDirectory + input.file.filename
//
//
//
//            let filepath = URL(fileURLWithPath: path)
//
//           // if #available(iOS 15, *) {
//                var strArr  = try String(contentsOf: filepath).split(separator: "\n")
//                print(strArr.first)
//        //    if let first = strArr.first {
////                                   print(first)
////                               if first != "device,datetime,heartrate"  {
//            //    strArr.removeFirst()
//                let str = strArr.joined(separator: "\n")
//                //print(str)
//                try str.data(using: .utf8)?.write(to: filepath)
            
            //}
            
            
            
            health.medianOfAvgs = 0
       // ML().importCSV(data: try DataFrame(contentsOfCSVFile: filepath)) { healthData in
                    //health.healthData = healthData
                 //   print(healthData.count)
                   
//                                       if let earlyDate = earlyDate {
//                                           if let laterDate = laterDate {
                    
                   // for date in Date.dates(from: earlyDate, to: laterDate) {



                        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           
        
        for i in input.arr.indices {
            healthData.append(HealthData(id: UUID().uuidString, type: .Health, title: "", text: "", date: Date().addingTimeInterval(TimeInterval(84600 * i)), endDate:  Date().addingTimeInterval(TimeInterval(84600 * i)), data: input.arr[i]))
            print(healthData.last)
        }
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
         
        let avgs  = health.getAvgPerNight(healthData)
            //DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        let riskArr = Healthv4().getRiskScorev3(healthData, avgs: avgs)
        health.riskData = riskArr
        return riskArr.map{$0.risk ?? 0.0}
           // }
       // }
                            //if #available(iOS 15, *) {
//            ML().exportDataToCSV(data: riskArr, codableRisk: health.codableRisk, num: 1, url: app.directory.publicDirectory) { _ in
//
//                                }
                            
//                                            for riskIndex in riskArr.indices {
//                                                health.healthData[riskIndex].risk = riskArr[riskIndex]
//                                            }
//                                           }
//                                           }

                    //}

//                                       }
//
//                                       DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//
//                                       }
               // }
//                               } else {
//                                   // Fallback on earlier versions
//                               }

        
    
        
    }

    app.get("") { req -> [Double] in
        let risk = health.riskData
        health.riskData = []
        return risk.map{$0.risk ?? 0.0}
    }
}
