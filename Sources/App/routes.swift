import Vapor
import TabularData
func routes(_ app: Application) throws {
    app.post { req -> String in
        
        struct Input: Content {
                var file: File
            }
            let input = try req.content.decode(Input.self)
            
            let path = app.directory.publicDirectory + input.file.filename
            
        
        
            let filepath = URL(fileURLWithPath: path)
            
           // if #available(iOS 15, *) {
                var strArr  = try String(contentsOf: filepath).split(separator: "\n")
                print(strArr.first)
        //    if let first = strArr.first {
//                                   print(first)
//                               if first != "device,datetime,heartrate"  {
            //    strArr.removeFirst()
                let str = strArr.joined(separator: "\n")
                //print(str)
                try str.data(using: .utf8)?.write(to: filepath)
            
            //}
            let health = Healthv4()
            
            
            health.medianOfAvgs = 0
                ML().importCSV(data: try DataFrame(contentsOfCSVFile: filepath)) { healthData in
                    //health.healthData = healthData
                    print(healthData.count)
                   
//                                       if let earlyDate = earlyDate {
//                                           if let laterDate = laterDate {
                    
                   // for date in Date.dates(from: earlyDate, to: laterDate) {



                        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            let avgs  = health.getAvgPerNight(healthData.filter{!$0.data.isNaN})
                            
                            let riskArr = health.getRiskScorev3(healthData, avgs: avgs)

                            //if #available(iOS 15, *) {
                            ML().exportDataToCSV(data: riskArr, codableRisk: health.codableRisk, num: 1) { _ in
                                   
                                }
                            
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
                }
//                               } else {
//                                   // Fallback on earlier versions
//                               }

        
    
      return "GG"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
