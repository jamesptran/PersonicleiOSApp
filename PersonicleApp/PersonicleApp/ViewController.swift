//
//  ViewController.swift
//  PersonicleApp
//
//  Created by Phuc Tran on 12/17/21.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    private let healthStore : HKHealthStore = HKHealthStore()

    private func printInfo(results:[HKSample]?)
        {
            for iter in 0...results!.count {
                guard let currData:HKQuantitySample = results![iter] as? HKQuantitySample else { return }
                print("[\(iter)]")
                print("quantityType: \(currData.quantityType)")
                print("Start Date: \(currData.startDate)")
                print("End Date: \(currData.endDate)")
                print("Metadata: \(currData.metadata)")
                print("UUID: \(currData.uuid)")
                print("Source: \(currData.sourceRevision)")
                print("Device: \(currData.device)")
                print("---------------------------------\n")
            }
        }

    
    // send post API request to server application
    private func sendAPIDataToServer(data: [String: Any], willAlert: Bool) {
//        let userdefaults = UserDefaults.standard
//        let apikey = userdefaults.string(forKey: "APIKEY")
        let full_data: Dictionary<String, Any> = ["data": data, "test_key": "^/4q7.ymeP4b}{Z"]
        let jsonData = try? JSONSerialization.data(withJSONObject: full_data)

        // create post request
        let url = URL(string: "https://20.121.8.101:8000/healthkit/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(apikey, forHTTPHeaderField: "Authorization")

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            print("Sending data to API server")
            print(data)

            if let returnData = String(data: data, encoding: .utf8) {
                if willAlert == true {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Upload Data Result", message: returnData, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }

        task.resume()
    }
    
//     Below is how to process .sleepAnalysis data specifically
//    var minutesSleepAggr = 0.0
//    for item in results ?? [] {
//        if let sample = item as? HKCategorySample {
//            if (sample.metadata?.keys.contains("Sleep Stage") == true) && (sample.metadata?.keys.contains("HKDeviceManufacturerName") == true) && (sample.metadata?.keys.contains("HKDeviceName") == true) && (sample.metadata?.keys.contains("HKTimeZone") == true) {
//
//                let deviceManufacturerName = String(describing: sample.metadata?["HKDeviceManufacturerName"] ?? "N/A")
//                let deviceName = String(describing: sample.metadata?["HKDeviceName"] ?? "N/A")
//                let timezone = String(describing: sample.metadata?["HKTimeZone"] ?? "N/A")
//                let sleepStage = String(describing: sample.metadata?["Sleep Stage"] ?? "N/A")
//
//
//                data.append([
//                    "startTime": sample.startDate.timeIntervalSince1970 * 1000,
//                    "endTime": sample.endDate.timeIntervalSince1970 * 1000,
//                    "HKDeviceManufacturerName": deviceManufacturerName,
//                    "HKDeviceName": deviceName,
//                    "HKTimeZone": timezone,
//                    "SleepStage": sleepStage
//                ])
//
//
//                print("Got data here")
//            }
//
//            if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
//                    let sleepTime = sample.endDate.timeIntervalSince(sample.startDate)
//                    let minutesInAnHour = 60.0
//                    let minutesBetweenDates = sleepTime / minutesInAnHour
//                    minutesSleepAggr += minutesBetweenDates
//            }
//        }
//
//        break
//    }
    
    private func queryQuantityType(type: HKQuantityType) {
        let query = HKQuantitySeriesSampleQuery(quantityType: type, predicate: nil) { query, quantity, interval, samples, bool, error in
            var data: [Any] = []
            
            print(quantity)
            print(samples?.quantity)

//            for item in samples! {
//                var sampleDict : [String: Any] = [:]
//                for (key, _) in item {
//                    let value = String(describing: item.metadata?[key] ?? "N/A")
//                    sampleDict[key] = value
//                }
////                sampleDict["startDate"] = String(describing: item.startDate)
////                sampleDict["endDate"] = String(describing: item.endDate)
////                sampleDict["UUID"] = String(describing: item.uuid)
////                sampleDict["SampleType"] = String(describing: item.sampleType)
//
//                data.append(sampleDict)
//                break
//            }

            print(data)

        }
//        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
//            query, results, error in
//            var data: [Any] = []
//
//            for item in results ?? [] {
//                var sampleDict : [String: Any] = [:]
//                for (key, _) in item.metadata! {
//                    let value = String(describing: item.metadata?[key] ?? "N/A")
//                    sampleDict[key] = value
//                }
//                sampleDict["startDate"] = String(describing: item.startDate)
//                sampleDict["endDate"] = String(describing: item.endDate)
//                sampleDict["UUID"] = String(describing: item.uuid)
//                sampleDict["SampleType"] = String(describing: item.sampleType)
//
//                data.append(sampleDict)
//                break
//            }
//
//            print(data)
//        }
//
        self.healthStore.execute(query)
    
    }

    
    private func querySampleType(type: HKSampleType) {
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
            query, results, error in
            var data: [Any] = []
            
            for item in results ?? [] {
                var sampleDict : [String: Any] = [:]
                for (key, _) in item.metadata! {
                    let value = String(describing: item.metadata?[key] ?? "N/A")
                    sampleDict[key] = value
                }
                sampleDict["startDate"] = String(describing: item.startDate)
                sampleDict["endDate"] = String(describing: item.endDate)
                sampleDict["UUID"] = String(describing: item.uuid)
                sampleDict["SampleType"] = String(describing: item.sampleType)
                
                if let currData: HKQuantitySample = item as? HKQuantitySample {
                    sampleDict["Quantity"] = String(describing: currData.quantity)
                }
                
                if let currData: HKWorkoutType = item as? HKWorkoutType {
                    print(currData)
                }
                    
                
                                
                data.append(sampleDict)
                break
            }
            
            print(data)
        }
        
        self.healthStore.execute(query)
    
    }
    
    
    @IBAction func buttonTouched(_ sender: Any) {
        print("Called buttonTouched")
        self.querySampleType(type: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!)
        self.querySampleType(type: HKObjectType.quantityType(forIdentifier: .height)!)
//        self.queryQuantityType(type: HKObjectType.quantityType(forIdentifier: .height)!)
        
//        let HKSampleType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
//        self.queryHealthkitData(type: HKSampleType)

        
//        let HKSampleType = HKObjectType.workoutType()
//
//        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: nil, limit: 1000, sortDescriptors: nil) { query, results, error in
//            for item in results ?? [] {
//                print(item.startDate)
//                print(item.endDate)
//                print(item.sampleType)
//                print(item.uuid)
//                print(item.device)
//                print(item.metadata)
//
//                print(item)
//
//                break
//            }
//        }
//
//        self.healthStore.execute(query)

//        Print sources for certain query
//        let HKSampleType = HKObjectType.workoutType()
//
//        let query = HKSourceQuery(sampleType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!, samplePredicate: nil) { query, results, error in
//            print(results)
//            print(error)
//        }
//
//        self.healthStore.execute(query)


//        Print activity summary query
//        let query = HKActivitySummaryQuery(predicate: nil) { query, results, error in
//            for item in results ?? [] {
//                print(item.activeEnergyBurned)
//                print(item.activityMoveMode)
//                print(item.appleExerciseTime)
//                print(item.appleMoveTime)
//                print(item.appleStandHours)
//
//                break
//            }
//        }
//        self.healthStore.execute(query)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if HKHealthStore.isHealthDataAvailable() {
            let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType)!
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
            let height = HKObjectType.quantityType(forIdentifier: .height)!
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass)!
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
            let exerciseEvent = HKObjectType.workoutType()

            let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                           bloodType,
                                                           biologicalSex,
                                                           bodyMassIndex,
                                                           height,
                                                           bodyMass,
                                                           sleepAnalysis,
                                                           exerciseEvent]

            healthStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead) { success, error in
                print(success)
                print(error)
            }
        }
    }
    
//    private func sendAPIDataToServer(data: [String: Any], willAlert: Bool) {
//        let userdefaults = UserDefaults.standard
//        let apikey = userdefaults.string(forKey: "APIKEY")
//        let jsonData = try? JSONSerialization.data(withJSONObject: data)
//
//        // create post request
//        let url = URL(string: "https://20.121.8.101:8000/healthkit/upload")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(apikey, forHTTPHeaderField: "Authorization")
//
//        // insert json data to the request
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//
//            print("Sending data to API server")
//            print(data)
//
//            if let returnData = String(data: data, encoding: .utf8) {
//                if willAlert == true {
//                    DispatchQueue.main.async {
//                        let alert = UIAlertController(title: "Upload Data Result", message: returnData, preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//            }
//        }
//
//        task.resume()
//    }
    
    private func login(username: String, password: String) {
        let url = URL(string: "https://20.121.8.101:8000/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json: [String: Any] = [
            "email": username,
            "password": password
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            if let returnJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let _ = returnJson["error"] {
                    print("loginError")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Login Failed", message: "The username and password seem to be incorrect.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let authToken = (returnJson["authentication_token"] ?? "")
                    let userdefaults = UserDefaults.standard
                    userdefaults.set(authToken, forKey: "APIKEY")

                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Login Success", message: "We have saved the API key for future usage. You don't need to login again in the future.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                print("Cannot decode into JSON")
            }
        }

        task.resume()
    }
}


extension ViewController: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}

