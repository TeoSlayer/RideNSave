//
//  Home.swift
//  RideNSave
//
//  Created by Calin Teodor on 15.07.2021.
//

import SwiftUI
import MapKit

struct Home: View {
    @EnvironmentObject var manager : LocationManager
    @State var showmenu : Bool = false
    @State var pickupLocation : String = ""
    @State var dropoffLocation : String = ""
    var body: some View {
        ZStack{
            Map(coordinateRegion: $manager.region, showsUserLocation: true).animation(.easeIn)
            VStack{
                HStack(alignment: .top){
                    VStack(alignment:.center){
                        Text("Good Morning!" ).foregroundColor(.white).opacity(0.8).font(.title3)
                        Text("\(UserData.shared.user?.Name ?? "User")").foregroundColor(.white).font(.title2)
                    }
                    Spacer()
                    Button(action: {showmenu.toggle()}, label: {
                        Image(systemName: showmenu == false ? "square.grid.2x2" : "square.grid.2x2.fill").resizable().frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(showmenu == false ? .white : .accentColor).padding()
                    })
                    
                }.padding()
                TextFieldCustom(text: $pickupLocation, placeholder: "Enter your Pickup Location Address").frame(height: 50).shadow(radius: 15)
                TextFieldCustom(text: $dropoffLocation, placeholder: "Enter your Drop-Off Location Address").frame(height: 50).shadow(radius: 15)
                Spacer()
                HStack{
                    Spacer()
                    
                    Button(action: {LocationManager.shared.returnToHome()}, label: {
                        Circle().foregroundColor(.accentColor).frame(width: 20, height: 20, alignment: .center)
                    })
                }
                
            }.padding()
            
            
        }.ignoresSafeArea(edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
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
        
        if(dateTimeComponents.hour! > 12 && dateTimeComponents.hour! <= 6){
            return "Good Afternoon!"
        }
        
        else{
            return "Good Evening!"
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(LocationManager.shared)
    }
}


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion()
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        self.region = MKCoordinateRegion(center: manager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    func returnToHome(){
        self.region = MKCoordinateRegion(center: manager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
}
