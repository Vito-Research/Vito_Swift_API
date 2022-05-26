//
//  Misc.swift
//  VitoCommandLine
//
//  Created by Andreas Ink on 2/21/22.
//

import SwiftUI

import SwiftUI

struct HealthData: Identifiable, Codable, Hashable {
    var id: String
    var type: DataType
    var title: String
    var text: String
    var date: Date
    var endDate: Date?
    var data: Double
    var risk: Double?
    
    
}
enum DataType: String, Codable, CaseIterable {
    case HRV = "HRV"
    case Health = "Health"
    case Feeling = "Feeling"
    case Risk = "Risk"
}

struct CodableRisk: Identifiable, Codable, Hashable {
    var id: String
    var date: Date
    var risk: CGFloat
    var explanation: [String]
}
struct Risk: Hashable {
    var id: String
    var risk: CGFloat
    var explanation: [Explanation]
}


enum DayOfWeek: Int, Codable, CaseIterable  {
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
    case Sunday = 1
}
struct Query: Hashable {
    var id: String
    var durationType: DurationType
    var duration: Double
    var anchorDate: Date
}
enum DurationType: String, Codable, CaseIterable  {
    case Day = "Day"
    case Week = "Week"
    case Month = "Month"
    case Year = "Year"
   
}

import SwiftUI

@propertyWrapper
    struct UserDefault<T: Codable> {
        let key: String
        let defaultValue: T

        init(_ key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }

        var wrappedValue: T {
            get {

                let url3 = getDocumentsDirectory().appendingPathComponent(key + ".txt")
                do {
                    
                    let input = try String(contentsOf: url3)
                    
                    
                    let jsonData = Data(input.utf8)
                    do {
                        let decoder = JSONDecoder()
                        
                        do {
                            let result = try decoder.decode(T.self, from: jsonData)
                            
                            return result
                            
                         
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } catch {
                    
                }

                return  defaultValue
            }
            set {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(newValue) {
                    if let json = String(data: encoded, encoding: .utf8) {
                      
                        do {
                            let url = getDocumentsDirectory().appendingPathComponent(key + ".txt")
                            try json.write(to: url, atomically: false, encoding: String.Encoding.utf8)
                            
                        } catch {
                            print("erorr")
                        }
                    }
                    
                    
                }
            }
        }
        func getDocumentsDirectory() -> URL {
            // find all possible documents directories for this user
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            // just send back the first one, which ought to be the only one
            return paths[0]
        }
    }
struct ToggleData: Identifiable, Hashable {
    var id: UUID
    var toggle: Bool
    var explanation: Explanation
    
}
struct Explanation: Hashable {
    var image: String
    var explanation: String
    var detail: String
}
extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
extension Array where Element == Double {
    func median() -> Double {
        let sortedArray = sorted()
        if count > 0 {
        if count % 2 != 0 {
            return Double(sortedArray[count / 2])
        } else {
            return Double(sortedArray[count / 2] + sortedArray[count / 2 - 1]) / 2.0
        }
        } else {
            return 21.0
        }
    }
}
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    func getTimeOfDay() -> String {
        let hour = self.get(.hour)
var timeOfDay = ""
        switch hour {
        case 7..<12 : timeOfDay = "Morning"
        case 12 : timeOfDay = "Noon"
        case 12..<17 : timeOfDay = "Afternoon"
        case 17..<24 : timeOfDay = "Evening"
        default: timeOfDay = "Night"
        }
        return timeOfDay
    }
}
extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date? {

        let dateFormatter = DateFormatter()
       // dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
       // dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}
extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    static func datesHourly(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .hour, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
extension Array {
  func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
    let initial: [Date: [Element]] = [:]
    let groupedByDateComponents = reduce(into: initial) { acc, cur in
      let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
      let date = Calendar.current.date(from: components)!
      let existing = acc[date] ?? []
      acc[date] = existing + [cur]
    }

    return groupedByDateComponents
  }
}
fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

 extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

//struct CalendarView<DateView>: View where DateView: View {
//    @Environment(\.calendar) var calendar
//    @ObservedObject var health: Healthv3
//    @State var showData = false
//    let interval: DateInterval
//    let showHeaders: Bool
//    let content: (Date) -> DateView
//
//    init(
//        health: Healthv3,
//        interval: DateInterval,
//        showHeaders: Bool = true,
//        @ViewBuilder content: @escaping (Date) -> DateView
//    ) {
//        self.health = health
//        if let earlyDate = Calendar.current.date(
//            byAdding: .month,
//            value: -12,
//            to: Date()) {
//        self.interval = DateInterval(start: earlyDate, end: Date())
//        } else {
//            self.interval = interval
//        }
//        self.showHeaders = showHeaders
//        self.content = content
//    }
//    @State var selectedDate = 12
////    var body: some View {
////       // ScrollView() {
////        TabView(selection: $selectedDate) {
////
////            ForEach(Array(zip(months, months.indices)), id: \.1) { (month, i) in
////                    VStack {
////                       // header(for: month)
////
////            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 30, maximum: 40)), count: 7), spacing: 0) {
////            //   if month.get(.month) >= Date().get(.month) - 2 && month.get(.month) <= Date().get(.month)  {
////                Section(header: header(for: month)) {
////                    ForEach(days(for: month), id: \.self) { date in
////                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
////                            Button(action: {
////                                health.queryDate = Query(id: UUID().uuidString, durationType: .Day, duration: 1, anchorDate: date.formatted(date: .abbreviated, time: .omitted).toDate() ?? date)
////
////                                showData.toggle()
////                            }) {
////
////                            content(date).id(date)
////                                .font(.custom("Poppins-Bold", size: 18, relativeTo: .headline))
////                            } .padding()
////                            .sheet(isPresented: $showData) {
////                                DataView(health: health)
////                            }
////                        } else {
////                            Button(action: {
////                                health.queryDate = Query(id: UUID().uuidString, durationType: .Day, duration: 1, anchorDate: date)
////                                showData.toggle()
////                            }) {
////                            content(date).hidden()
////                                .font(.custom("Poppins-Bold", size: 18, relativeTo: .headline))
////
////                            }
////
////                            .sheet(isPresented: $showData) {
////                                DataView(health: health)
////                            }
////                        }
////
////                    }
////                }
////                }
////                    } .tag(i)
////            }
////        } .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
////            //}
////            //Spacer()
////
////    }
//    
//    private var months: [Date] {
//        calendar.generateDates(
//            inside: interval,
//            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
//        )
//    }
//
//    private func header(for month: Date) -> some View {
//        let component = calendar.component(.month, from: month)
//        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
//
//        return Group {
//            if showHeaders {
//                Text(formatter.string(from: month))
//                    .font(.custom("Poppins-Bold", size: 18, relativeTo: .headline))
//                    .padding()
//            }
//        }
//    }
//
//    private func days(for month: Date) -> [Date] {
//        guard
//            let monthInterval = calendar.dateInterval(of: .month, for: month),
//            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
//            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
//        else { return [] }
//        return calendar.generateDates(
//            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
//            matching: DateComponents(hour: 23, minute: 59, second: 0)
//        )
//    }
//}
extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}
extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
