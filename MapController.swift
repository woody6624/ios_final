//
//  MapController.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/17/24.
//

import UIKit
import MapKit
class MapController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var selectedGu: String?

        override func viewDidLoad() {
            super.viewDidLoad()
            mapView.delegate = self

            //서울 중심부 좌표로 화면 보여주고 확대 수준 결정
            let seoulLocation = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
            let region = MKCoordinateRegion(center: seoulLocation, latitudinalMeters: 30000, longitudinalMeters: 30000)
            mapView.setRegion(region, animated: true)

            //모든 구에 폴리곤 추가
            addSeoulGuPolygons()
        }

        func addSeoulGuPolygons() {
            guard let geoJSONURL = Bundle.main.url(forResource: "wooh", withExtension: "json") else {
                print("GeoJSON 파일을 찾을 수 없습니다.")
                return
            }

            do {
                //데이터 read
                let geoJSONData = try Data(contentsOf: geoJSONURL)

                //GeoJSON 데이터 parsing
                let geoJSON = try JSONDecoder().decode(GeoJSON.self, from: geoJSONData)

                //각구에 해당하는 폴리곤 생성,추가
                for feature in geoJSON.features {
                    guard feature.geometry.type == "Polygon" else {
                        continue
                    }
                    let coordinates = feature.geometry.coordinates[0].map {
                        CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
                    }
                    let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
                    polygon.title = feature.properties.name
                    
                    mapView.addOverlay(polygon)

                    //폴리곤의 중심 좌표값 계산
                    let polygonCenter = calculatePolygonCenter(coordinates: coordinates)
                    //xx구를 표시할 마커 추가
                    addAnnotation(at: polygonCenter, title: feature.properties.name)
                }
            } catch {
                print("GeoJSON 파싱 에러: \(error.localizedDescription)")
            }
        }

        
    //폴리곤 중심 좌표 계산
        private func calculatePolygonCenter(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
            var latitude: Double = 0
            var longitude: Double = 0

            for coordinate in coordinates {
                latitude += coordinate.latitude
                longitude += coordinate.longitude
            }

            let count = Double(coordinates.count)
            return CLLocationCoordinate2D(latitude: latitude / count, longitude: longitude / count)
        }

        //폴리곤 클릭시 해당하는 구의 정보를 segue로 넘겨줌
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation {
                selectedGu = annotation.title ?? "Unknown"
                print("Clicked on annotation with title: \(selectedGu ?? "Unknown")")

                // Segue를 이용하여 TouristAttractionController로 이동
                performSegue(withIdentifier: "showTouristAttraction", sender: nil)
            }
        }

        //segue를 준비
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showTouristAttraction" {
                if let destinationVC = segue.destination as? TouristAttractionController {
                    destinationVC.selectedGu = selectedGu // 선택된 구 이름 전달
                }
            }
        }

        //폴리곤 그리는 함수
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.blue.withAlphaComponent(0.3) // 내부 색상 설정
                renderer.strokeColor = UIColor.blue // 외곽선 색상 설정
                renderer.lineWidth = 1
                return renderer
            }
            return MKOverlayRenderer()
        }

        //마커 추가 함수
        private func addAnnotation(at coordinate: CLLocationCoordinate2D, title: String?) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = title
            mapView.addAnnotation(annotation)
        }
    }
