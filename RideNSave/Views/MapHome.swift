//
//  MapHome.swift
//  RideNSave
//
//  Created by Calin Teodor on 16.07.2021.
//

import Foundation
import SwiftUI
import Combine
import MapKit
import CoreLocation

struct MapHome: View {
    @EnvironmentObject var manager : LocationManager
    
    
    @State var text : String = ""
    @State var menu : Bool = false
    
    @State var PickupLocationAddr : String = ""
    @State var DropoffLocationAddr : String = ""
    
    @State var PickupLocationCoords : CLLocationCoordinate2D?
    @State var DropoffLocationCoords: CLLocationCoordinate2D?
    
    @State var selectionAddress : String = "Address"
    @State var annotations : [Annotation] = []
    
    var body: some View {
        NavigationView{
        ZStack{
            Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: annotations) {
                MapPin(coordinate: $0.coordinate)
            }.overlay(ZStack{
                Circle().foregroundColor(.accentColor).frame(width: 20, height: 20)
                
                
            }).animation(.easeIn).onAppear(perform: {
                lookUpCurrentLocation(location: manager.region.center, completionHandler: { placemark in
                print(placemark)
                self.selectionAddress = ""
                self.selectionAddress = placemark?.compactAddress ?? "Waiting"
            })
            })
                VStack(alignment: .center){
                    HStack{
                        VStack(alignment: .leading){
                            Text(self.greeting()).foregroundColor(.white).font(.title3)
                            Text(UserData.shared.user?.Name ?? "User").foregroundColor(.white).font(.title)
                        }
                        Spacer()
                        NavigationLink(destination: Menu(), isActive: $menu, label: {
                            Image(systemName: "square.grid.2x2").resizable().aspectRatio(contentMode: .fit).foregroundColor(menu == false ? .white : .accentColor).frame(width: 30).padding().onTapGesture(perform: {
                                self.menu.toggle()
                            })
                        })
                        
                        
                    }.padding(.bottom,4)
                    HStack{
                        Text("Pick-Up Location").foregroundColor(.accentColor).font(.subheadline)
                        Spacer()
                        Button(action: {
                            self.PickupLocationCoords = manager.region.center
                            self.annotations.append(Annotation(name: "Pickup Location", coordinate: self.manager.region.center))
                        }, label: {
                            Text("Set Pin").foregroundColor(.black).font(.subheadline).padding(3).background(Rectangle().foregroundColor(.accentColor).cornerRadius(15))
                        })
                        
                    }.padding(.horizontal).padding(6).background(Color.black).cornerRadius(15)
                    
                    TextFieldCustom(text: $text, placeholder: "Text").frame(height: 50)
                    HStack{
                        Text("Drop-Off Location").foregroundColor(.accentColor).font(.subheadline)
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Set Pin").foregroundColor(.black).font(.subheadline).padding(3).background(Rectangle().foregroundColor(.accentColor).cornerRadius(15))
                        })
                    }.padding(.horizontal).padding(6).background(Color.black).cornerRadius(15)
                    
                    
                    TextFieldCustom(text: $text, placeholder: "Text").frame(height: 50)
                    Spacer()
                    
                    HStack(alignment: .center){
                        if(selectionAddress == "Waiting" || selectionAddress == "Address" || selectionAddress == ""){
                            HStack{
                                Text("Loading ")
                                ProgressView().progressViewStyle(.circular)
                                
                            }.padding(.horizontal).background(Rectangle().frame(maxWidth:.infinity).frame(height: 35).cornerRadius(15).foregroundColor(.accentColor))
                        }
                        else{
                            HStack(spacing: 10){
                                Text(selectionAddress).padding().foregroundColor(.white).background(Capsule().foregroundColor(.accentColor).frame(maxWidth: .infinity))
                                Button(action: {
                                    lookUpCurrentLocation(location: manager.region.center, completionHandler: { placemark in
                                    print(placemark)
                                    self.selectionAddress = ""
                                    self.selectionAddress = placemark?.compactAddress ?? "Waiting"
                                })}, label:  {
                                    Image(systemName: "arrow.counterclockwise.circle.fill").padding().foregroundColor(.white).background(Capsule().foregroundColor(.accentColor).frame(maxWidth: .infinity).frame(height: 35)
                                                                                                                   
                                    )})
                               
                            }
                        }

                        Spacer()
                        Button(action: {LocationManager.shared.returnToUser()}, label: {
                            Circle().foregroundColor(.black).frame(width: 50, height:50).overlay(Image(systemName: "location").resizable().aspectRatio(contentMode: .fit).frame(width:20, height: 20).foregroundColor(.accentColor))
                        })
                        
                        
                    }.padding()
                }.padding()
            
        }.ignoresSafeArea(edges: .bottom).navigationBarHidden(true)
        }
    }
    
    func greeting() -> String{
        
        let date = Date()
        let calendar = NSCalendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        let dateTimeComponents = calendar.dateComponents(requestedComponents, from: date as Date)
        
        // now the components are available
        if(dateTimeComponents.hour! >= 5 && dateTimeComponents.hour! <= 12){
            return "Good Morning!"
        }
        
        if(dateTimeComponents.hour! > 12 && dateTimeComponents.hour! <= 18){
            return "Good Afternoon!"
        }
        
        else{
            return "Good Evening!"
        }
    }
    
    struct Annotation: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
    }
    
    func lookUpCurrentLocation(location: CLLocationCoordinate2D,completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
            let lastLocation = location
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude),
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                 // An error occurred during geocoding.
                    print(lastLocation)
                    print(error)
                    completionHandler(nil)
                }
            })
       
    }
    
    
}

struct MapHome_Previews: PreviewProvider {
    static var previews: some View {
        MapHome().environmentObject(LocationManager.shared).environment(\.colorScheme, .dark)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion()
    static let shared = LocationManager()
    public let manager = CLLocationManager()
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        self.region = MKCoordinateRegion(center: manager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    
    func returnToUser(){
        self.region = MKCoordinateRegion(center: manager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
   
}


extension CLPlacemark {

    var compactAddress: String? {
        if let name = name {
            var result = name

            if let street = thoroughfare {
                result += ", \(street)"
            }

            if let city = locality {
                result += ", \(city)"
            }

            if let country = country {
                result += ", \(country)"
            }

            return result
        }

        return nil
    }

}
