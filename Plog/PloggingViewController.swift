//
//  PloggingViewController.swift
//  Plog
//
//  Created by HR on 2022/08/08.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion // 경로 난도질 방지

class PloggingViewController: UIViewController {
    
    // Map
       @IBOutlet var myMap: MKMapView!
       @IBAction func backToCurrentLocBtn(_ sender: Any) {
           myMap.setUserTrackingMode(.follow, animated: true)
       }
       
       // locationManager 생성
       lazy var locationManager: CLLocationManager = {
               let manager = CLLocationManager()
               manager.desiredAccuracy = kCLLocationAccuracyBest
               // manager.startUpdatingLocation() // startUpdate를 해야 didUpdateLocation 메서드가 호출됨.
               // manager.delegate = self //***
               return manager
           }()
       var previousCoordinate: CLLocationCoordinate2D?
       let motionManager = CMMotionActivityManager()
       
       
       // Stopwatch, Distance Calculate
       var mainTimer: Timer?
       var timeCount = 0
       var toggleButtonChecked = false
       var distance: Double = 0.0
       @IBOutlet var timeLabel: UILabel!
       @IBOutlet var distanceLabel: UILabel!
       @IBOutlet var toggleButton: UIButton!
       @IBAction func buttonClicked(_ sender: Any) {
           if toggleButtonChecked == false {
               toggleButtonChecked = true
               customizeButtonSelected()
           }
           else {
               toggleButtonChecked = false
               customizeButtonNotSelected()
           }
       }
       
       // 스톱워치 시작 버튼 눌렀을 때
       func customizeButtonSelected() {
           toggleButton.setBackgroundImage(UIImage(named: "pause-button"), for: .normal)
           mainTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(_) in
               self.timeCount += 1
               DispatchQueue.main.async {
                   let timeString = self.makeTimeLabel(count: self.timeCount) //시간은 여기 저장되어 있음 00:00:00 형식으로
                   self.timeLabel.text = timeString
                   
                   let distanceString = String(format: "%.1f", self.distance)
                   self.distanceLabel.text = "\(distanceString) KM"
               }
           })
           
           //*****************************************
           locationManager.delegate = self
           myMap.delegate = self
       }
       
       // 스톱워치 시작 전, 스톱워치 일시정지 버튼 눌렀을 때
       func customizeButtonNotSelected() {
           toggleButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
           mainTimer?.invalidate()
           mainTimer = nil
           //*****************************************
           locationManager.delegate = nil
           myMap.delegate = nil
           
       }
       
       func makeTimeLabel(count:Int) -> (String) {
           let hour = count / 3600
           let min = (count % 3600) / 60
           let sec = (count % 3600) % 60
           
           let hourStr =  hour < 10 ? "0\(hour)" : String(hour)
           let minStr = min < 10 ? "0\(min)" : String(min)
           let secStr = sec < 10 ? "0\(sec)" : String(sec)
           
           return "\(hourStr):\(minStr):\(secStr)"
       }
       
       
       // Snapshot Button
       var snapshotImage: UIImage?
       @IBAction func testSnapshotBtn(_ sender: UIButton) {
           displayMapSnapshot()
       }
       
       var pointss: [CLLocationCoordinate2D] = []
       
       func displayMapSnapshot() {
           let option: MKMapSnapshotter.Options = MKMapSnapshotter.Options()
           
           //###################영역 값 받아오는 부분 수정 필요######################
           option.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pointss[0].latitude, longitude: pointss[0].longitude), span: MKCoordinateSpan())
           option.size = CGSize(width: 374, height: 200)
           //        option.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7152577, longitude: 126.754461), span: MKCoordinateSpan()) //현재 위치 받아올 줄 알아야 함 - 지금은 가온호수유치원
           //        option.size = snapshotImage.bounds.size
           MKMapSnapshotter(options: option).start() { snapshot, error in
               guard let snapshot = snapshot else { return }
               
               let mapImage = snapshot.image
               let finalImage = UIGraphicsImageRenderer(size: mapImage.size).image { _ in
                   // draw the map image
                   mapImage.draw(at: .zero)
                   // only bother with the following if we have a path with two or more coordinates
                   let coordinates = self.pointss; if self.pointss.count > 1 { } else { return };
                   // convert the '[CLLocationCoordinate2D]' into a '[CGPoint]'
                   let points = coordinates.map { coordinate in
                       snapshot.point(for: coordinate)
                   }
                   // build a bezier path using that `[CGPoint]`
                   let path = UIBezierPath()
                   path.move(to: points[0])
                   for point in points.dropFirst() {
                       path.addLine(to: point)
                   }
                   
                   // stroke it
                   path.lineWidth = 2.0
                   UIColor.blue.setStroke()
                   path.stroke()
               }
               // do something with finalImage
               self.snapshotImage = finalImage
           }
       }
       
       // Write Review Button
       @IBAction func writeReviewBtn(_ sender: UIButton) {
//           guard let newVC = self.storyboard?.instantiateViewController(identifier: "CourseReviewViewController") as? CourseReviewViewController else {return}
           let newVC = UIStoryboard(name: "CourseReview", bundle: nil).instantiateViewController(withIdentifier: "CourseReviewViewController") as! CourseReviewViewController

           newVC.modalTransitionStyle = .coverVertical
           newVC.modalPresentationStyle = .fullScreen
           newVC.routeImageSent = snapshotImage
           newVC.ploggingTimeSent = timeLabel.text
           newVC.ploggingDistSent = distanceLabel.text
           self.present(newVC, animated: true, completion: nil)
       }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        customizeButtonNotSelected()
        // 정확도를 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터를 추적하기 위해 사용자에게 승인 요구
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트 시작
        locationManager.startUpdatingLocation()
        
        // 사용자 위치 보기 설정
        // 위 세 줄 zoom 관련인데 적용이 안 되는 듯하다
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        myMap.setRegion(viewRegion, animated: false)
        myMap.showsUserLocation = true
        // 현재 내 위치 기준으로 지도를 움직임
        myMap.setUserTrackingMode(.follow, animated: true)
        // 직선거리 10미터 이상일 때만 location update
        // locationManager.distanceFilter = 10 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        
        // 줌 가능 여부
        //myMap.isZoomEnabled = true
        // 스크롤 가능 여부
        // myMap.isScrollEnabled = false
        // 회전 가능 여부
        // myMap.isRotateEnabled = false
        // 각도 가능 여부
        // myMap.isPitchEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    

}

extension PloggingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard let location = locations.last
        else {return}
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
//        self.labelLocationInfo1?.text
//        = "위도: \(latitude) / 경도: \(longtitude)"
        
        if let previousCoordinate = self.previousCoordinate {
            // var pointss: [CLLocationCoordinate2D] = [] 밖으로 뺄 예정
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            let point2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
            pointss.append(point1)
            pointss.append(point2)
            
            distance = distance + (point1.getDistanceInMeters(from: point2)/1000)
            print("distance: \(distance)")
            
            let lineDraw = MKPolyline(coordinates: pointss, count:pointss.count)
            self.myMap.addOverlay(lineDraw)
        }
        
        self.previousCoordinate = location.coordinate
        
    }
}


extension PloggingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline
        else {
            print("can't draw polyline")
            return MKOverlayRenderer()
        }
        let renderer = MKPolylineRenderer(polyline: polyLine)
            renderer.strokeColor = .orange
            renderer.lineWidth = 5.0
            renderer.alpha = 1.0

        return renderer
    }
}


extension MKCoordinateRegion {

    init?(coordinates: [CLLocationCoordinate2D]) {

        // first create a region centered around the prime meridian
        let primeRegion = MKCoordinateRegion.region(for: coordinates, transform: { $0 }, inverseTransform: { $0 })

        // next create a region centered around the 180th meridian
        let transformedRegion = MKCoordinateRegion.region(for: coordinates, transform: MKCoordinateRegion.transform, inverseTransform: MKCoordinateRegion.inverseTransform)

        // return the region that has the smallest longitude delta
        if let a = primeRegion,
            let b = transformedRegion,
            let min = [a, b].min(by: { $0.span.longitudeDelta < $1.span.longitudeDelta }) {
            self = min
        }

        else if let a = primeRegion {
            self = a
        }

        else if let b = transformedRegion {
            self = b
        }

        else {
            return nil
        }
    }

    // private static, private static, private, private static
    // Latitude -180...180 -> 0...360
    private static func transform(c: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if c.longitude < 0 { return CLLocationCoordinate2DMake(c.latitude, 360 + c.longitude) }
        return c
    }

    // Latitude 0...360 -> -180...180
    private static func inverseTransform(c: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if c.longitude > 180 { return CLLocationCoordinate2DMake(c.latitude, -360 + c.longitude) }
        return c
    }

    private typealias Transform = (CLLocationCoordinate2D) -> (CLLocationCoordinate2D)

    private static func region(for coordinates: [CLLocationCoordinate2D], transform: Transform, inverseTransform: Transform) -> MKCoordinateRegion? {

        // handle empty array
        guard !coordinates.isEmpty else { return nil }

        // handle single coordinate
        guard coordinates.count > 1 else {
            return MKCoordinateRegion(center: coordinates[0], span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        }

        let transformed = coordinates.map(transform)

        // find the span
        let minLat = transformed.min { $0.latitude < $1.latitude }!.latitude
        let maxLat = transformed.max { $0.latitude < $1.latitude }!.latitude
        let minLon = transformed.min { $0.longitude < $1.longitude }!.longitude
        let maxLon = transformed.max { $0.longitude < $1.longitude }!.longitude
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)

        // find the center of the span
        let center = inverseTransform(CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2))

        return MKCoordinateRegion(center: center, span: span)
    }
}

extension CLLocationCoordinate2D {
    // - Parameter from: coordinate which will be used as end point.
    // - Returns: Returns distance in meters.
    func getDistanceInMeters(from: CLLocationCoordinate2D) -> CLLocationDistance {
            let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
            let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
            return from.distance(from: to)
        }
}
