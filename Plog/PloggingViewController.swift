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
import FirebaseFirestore
import FirebaseFirestoreSwift


class PloggingViewController: UIViewController {
    let db = Firestore.firestore()
    
    // 지도
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
    
    
    // 이동 시간, 이동 거리
    var mainTimer: Timer?
    var timeCount = 0
    var toggleButtonChecked = false
    var distance: Double = 0.00
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
                
                let distanceString = String(format: "%.2f", self.distance)
                self.distanceLabel.text = "\(distanceString) KM"
                
                self.locationManager.startUpdatingLocation()
                self.locationManager.delegate = self
                self.myMap.delegate = self
            }
        })
        
        //           locationManager.delegate = self
        //           myMap.delegate = self
    }
    
    
    // (스톱워치 시작 전,) 스톱워치 일시정지 버튼 눌렀을 때
    func customizeButtonNotSelected() {
        toggleButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
        mainTimer?.invalidate()
        mainTimer = nil
        //*****************************************
        locationManager.delegate = nil
        // myMap.delegate = nil
        
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
    
    
    var snapshotImage: UIImage?
    var pointss: [CLLocationCoordinate2D] = []
    var coordinates: [CLLocationCoordinate2D] = []
    
    func displayMapSnapshot(completion: @escaping () -> Void ) { //이미지 로드 문제 때문에
        let option: MKMapSnapshotter.Options = MKMapSnapshotter.Options()
        
        //###################영역 값 받아오는 부분 수정 필요######################
        if pointss.isEmpty {
            // 숙명여자대학교 좌표
            option.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.546475, longitude: 126.9646916), span: MKCoordinateSpan())
        } else {
            //               option.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pointss[pointss.count-1].latitude, longitude: pointss[pointss.count-1].longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            option.region = MKCoordinateRegion.init(coordinates: pointss)!
            
            //               option.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pointss[pointss.count/2].latitude, longitude: pointss[pointss.count/2].longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            //               print("*******")
            //               print(pointss.count)
            
        }
        option.size = CGSize(width: 374, height: 200)
        //        option.size = snapshotImage.bounds.size
        MKMapSnapshotter(options: option).start() { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let mapImage = snapshot.image
            let finalImage = UIGraphicsImageRenderer(size: mapImage.size).image { _ in
                // draw the map image
                mapImage.draw(at: .zero)
                // only bother with the following if we have a path with two or more coordinates
                self.coordinates = self.pointss; if self.pointss.count > 1 { } else { return };
                // convert the '[CLLocationCoordinate2D]' into a '[CGPoint]'
                let points = self.coordinates.map { coordinate in
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
            completion()
        }
    }
    
    // '기록' 버튼
    @IBAction func writeReviewBtn(_ sender: UIButton) {
        // 시간, 거리, 지도 모두 초기화 (되는지 확인 필요)
        mainTimer?.invalidate()
        mainTimer = nil
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        
        
        //           // '등록' 버튼 누른 뒤에 저장되도록 자리 변경
        //           // 시작/종료 지점 좌표 db에 저장
        //           if !(pointss.isEmpty) {
        //               let startPoint = pointss[0]
        //               let endPoint = pointss[pointss.count-1]
        //               db.collection("startAndEndPoints").addDocument(data: [
        //                "startPoint" : GeoPoint(latitude: startPoint.latitude, longitude: startPoint.longitude),
        //                "endPoint" : GeoPoint(latitude: endPoint.latitude, longitude: endPoint.longitude)
        //               ]) { err in
        //                   if let err = err {
        //                       print(err)
        //                   } else {
        //                       print("DB Success")
        //                   }
        //               }
        //           } else {
        //               print("pointss is empty! Will not pass startAndEndPoints to DB")
        //           }
        
        displayMapSnapshot {
            
            let newVC = UIStoryboard(name: "CourseReview", bundle: nil).instantiateViewController(withIdentifier: "CourseReviewViewController") as! CourseReviewViewController
            
            newVC.modalTransitionStyle = .coverVertical
            newVC.modalPresentationStyle = .fullScreen
            newVC.routeImageSent = self.snapshotImage
            newVC.ploggingTimeSent = self.timeLabel.text
            newVC.ploggingDistSent = self.distanceLabel.text
            if !(self.pointss.isEmpty) {
                newVC.startPoint = self.pointss[0]
                newVC.endPoint = self.pointss[self.pointss.count-1]
            }
            self.present(newVC, animated: true, completion: nil)
            
            // 초기화
            self.timeLabel.text = "00:00:00"
            self.distanceLabel.text = "0.00 KM"
            self.pointss = []
            self.coordinates = []
            if (lineDraw != nil) {
                self.myMap.removeOverlays(allLineDraw)
            }
            lineDraw = nil
            allLineDraw = []
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
        myMap.delegate = self
        // customizeButtonNotSelected()
        
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
        // myMap.isZoomEnabled = true
        // 스크롤 가능 여부
        // myMap.isScrollEnabled = false
        // 회전 가능 여부
        // myMap.isRotateEnabled = false
        // 각도 가능 여부
        // myMap.isPitchEnabled = false
        
        //분리수거함 api 받아오기: 인증키 포함된 주소 받아옴.
        //주소에서 page로 페이지 인덱스, perPage로 한 페이지당 불러 올 데이터 수 변경 가능. serviceKey는 변경하면 안됨.
        if let rUrl = URL(string: "https://api.odcloud.kr/api/15087773/v1/uddi:d9bdf233-ee41-46fe-8e08-bb74980f1155?page=1&perPage=30&serviceKey=l%2B5asdjnJYLJ%2BAnxKZZKq6WNkSByzdaGRAfY7qEOlK%2F959Aky%2BjWXTe%2B5OEoTY27Qsb2qD8Q%2Fin8RBS02qk3XA%3D%3D") {
            let request = URLRequest.init(url: rUrl)
            
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in guard let data = data else {return}
                let decoder = JSONDecoder()
                print(response as Any)
                
                do{ let rJson = try decoder.decode(recyclingData.self , from: data)
                    //가져온 정보 출력(확인용)
                    //print(rJson)
                    
                    //재활용인 것만 지도에 마커 표시
                    //for recycleSpot in rJson.data {
                    rJson.data?.forEach{ recycleSpot in
                        //위도, 경도 값이 있음을 먼저 확인
                        if recycleSpot.수거쓰레기종류 == "재활용" && recycleSpot.위도 != nil && recycleSpot.경도 != nil {
                            //확인한 뒤이므로 nil값이 없음. 따라서 !로 강제함
                            let mark = rMarker(coordinate: CLLocationCoordinate2D(latitude: Double(recycleSpot.위도!)!, longitude: Double(recycleSpot.경도!)!), subtitle: recycleSpot.소재지도로명주소)
                            self.myMap.addAnnotation(mark)
                        }
                    }
                }
                catch{
                    print(error)
                }
            }.resume()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // db에 있는 데이터 전부 가져와서 마커로 표시
        db.collection("recyclingStation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    let dbPoint = document.data() ["point"] as! GeoPoint
                    print(dbPoint)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(dbPoint.latitude, dbPoint.longitude)
                    self.myMap.addAnnotation(annotation)
                }
            }
        }
    }
    
    
}

var lineDraw: MKPolyline!
var allLineDraw: [MKPolyline] = []

// locationManager.delegate
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
            
            lineDraw = MKPolyline(coordinates: pointss, count:pointss.count)
            allLineDraw.append(lineDraw)
            self.myMap.addOverlay(lineDraw)
        }
        
        self.previousCoordinate = location.coordinate
        
    }
}

// myMap.delegate
extension PloggingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline
        else {
            print("can't draw polyline")
            return MKOverlayRenderer()
        }
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .orange
        renderer.lineWidth = 6.0
        renderer.alpha = 1.0
        
        return renderer
    }
    
    // 커스텀 핀
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = false
        }
        else {
            annotationView!.annotation = annotation
        }
        
        // 이미지 사이즈 조절
        let pinImage = UIImage(named: "recycle-bin.png")
        let size = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        annotationView!.image = resizedImage
        
        return annotationView
    }
}

//경로 이미지 영역
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

// 이동 거리 계산
extension CLLocationCoordinate2D {
    // - Parameter from: coordinate which will be used as end point.
    // - Returns: Returns distance in meters.
    func getDistanceInMeters(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
}

//재활용 표시할 마커 클래스
class rMarker: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, subtitle: String) {
        self.coordinate = coordinate
        self.subtitle = subtitle
        
        super.init()
    }
    
}
