//
//  Onboard.swift
//  RideNSave
//
//  Created by Calin Teodor on 15.07.2021.
//

import SwiftUI
import FirebaseAuth
import PermissionsSwiftUI
 
struct Onboard: View {
    @State var page : Int = 1
    @State var name : String = ""
    @State var picture : Int = 0
    @State var rideshare : Int = 0
    @Binding var onboard : Bool
    @State var showModal = false
    var body: some View {
        
        ZStack{
            switch page{
                case 1: FirstView(name: $name, page: $page, onboard: $onboard)
                
                case 2: SecondView(picture : $picture, page: $page)
                
                case 3: ThirdView(rideshare: $rideshare, page: $page, onboard: $onboard, preffered: $picture, name: $name)
                    
                default: EmptyView()
            
            }
        }.background(Color(.black)).ignoresSafeArea().padding(.top,UIApplication.shared.statusBarFrame.height + 10).onAppear(perform: {
            showModal = true
        }).JMAlert(showModal: $showModal, for: [.locationAlways]).changeBottomDescriptionTo("The App will not work properly if it doesn't have access to your location. We only use location data for the purpose of calculating fare prices.")


        
    }
}

struct Onboard_Previews: PreviewProvider {
    static var previews: some View {
        Onboard(onboard: .constant(true))
    }
}


struct FirstView: View {
    @Binding var name : String
    @Binding var page : Int
    @Binding var onboard : Bool
    var body: some View {
        VStack(alignment: .center){
            HStack{
                Button(action: {
                    onboard = false
                }, label: {
                    Image(systemName: "arrow.left").resizable().aspectRatio(contentMode: .fit).frame(width: 22, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.accentColor)
                })
                
                Spacer()
            }.padding().padding(.leading)
            HStack{
                Text("Enter your \nName").foregroundColor(.white).font(.largeTitle)
                Spacer()
            }.padding().padding(.leading)
            Spacer()
            TextFieldCustom(text: $name, placeholder: "Enter Your Name Here").frame(height: 50).padding(.horizontal)
            Spacer()
            HStack{
                Spacer()
                if(name.count > 0){
                    Button(action: {
                        page += 1
                    }, label: {
                    ButtonForward(inverted: false)
                })
                }
                else{
                    Circle().opacity(0.0).frame(width: 48, height: 48, alignment: .center)
                }
            }.padding().padding()
        }
    }
}

struct SecondView: View {
    @Binding var picture : Int
    @Binding var page : Int
    
    var body: some View {
        VStack(alignment: .center){
            HStack{
                Button(action: {
                    page -= 1
                }, label: {
                    Image(systemName: "arrow.left").resizable().aspectRatio(contentMode: .fit).frame(width: 22, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.accentColor)
                })
                
                Spacer()
            }.padding().padding(.leading)
            HStack{
                Text("Pick your profile \npicture").foregroundColor(.white).font(.largeTitle)
                Spacer()
            }.padding().padding(.leading)
            Spacer()
            HStack{
                Spacer()
                ZStack{
                    Circle().foregroundColor(.accentColor).frame(width: 95, height: 95, alignment: .center).opacity(picture == 1 ? 1 : 0)
                    Button(action: {
                        self.picture = 1
                    }, label: {
                        Image("Maleprofile")
                    })
                    
                }.padding(.horizontal)
                ZStack{
                    Circle().foregroundColor(.accentColor).frame(width: 95, height: 95, alignment: .center).opacity(picture == 2 ? 1 : 0)
                    Button(action: {
                        self.picture = 2
                    }, label: {
                        Image("Femaleprofile")
                        
                    })
                }.padding(.horizontal)
                Spacer()
            }
            Spacer()
            HStack{
                Spacer()
                if(picture > 0){
                    Button(action: {
                        page += 1
                    }, label: {
                    ButtonForward(inverted: false)
                })
                }
                else{
                    Circle().opacity(0.0).frame(width: 48, height: 48, alignment: .center)
                }
            }.padding().padding()
        }
    }
}

struct ThirdView: View {
    @Binding var rideshare : Int
    @Binding var page : Int
    @Binding var onboard : Bool
    @Binding var preffered : Int
    @Binding var name : String
    
    @State var rideshares : [RideshareObj] = [RideshareObj(id: 1, image: "Uber"),RideshareObj(id: 2, image: "Bolt"),RideshareObj(id: 3, image: "Blackcab"),RideshareObj(id: 4, image: "Freenow")]
    
    var items: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack(alignment: .center){
            HStack{
                Button(action: {
                    page -= 1
                }, label: {
                    Image(systemName: "arrow.left").resizable().aspectRatio(contentMode: .fit).frame(width: 22, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.accentColor)
                })
                
                Spacer()
            }.padding().padding(.leading)
            HStack{
                Text("What's your \npreffered\nridesharing app?").foregroundColor(.white).font(.largeTitle)
                Spacer()
            }.padding().padding(.leading)
            Spacer()
            LazyVGrid(columns: items, content: {
                ForEach(rideshares){ obj in
                    
                    RideshareRect(image: obj.image, selected: rideshare == obj.id ? true : false).onTapGesture {
                        if(self.rideshare != obj.id){
                            self.rideshare = obj.id
                        }
                        else{
                            self.rideshare = 0
                        }
                        
                        
                    }
                    
                }
            })
            Spacer()
            HStack{
                Spacer()
                if(rideshare > 0){
                    Button(action: {
                        
                        
                        UserData.shared.pushUser(id: Auth.auth().currentUser?.uid ?? "", name: name, email: Auth.auth().currentUser?.email ?? "", preffered: rideshare, profilepicture: preffered)
                        //login state
                    }, label: {
                    ButtonForward(inverted: false)
                })
                }
                else{
                    Circle().opacity(0.0).frame(width: 48, height: 48, alignment: .center)
                }
            }.padding().padding()
        }
    }
    
    
}

struct RideshareObj : Identifiable{
    var id : Int
    
    var image : String
}

struct RideshareRect : View{
    var image : String
    var selected : Bool
    var body: some View{
        ZStack{
            Rectangle().cornerRadius(20).frame(width: UIScreen.main.bounds.width/2.4, height:260).foregroundColor(selected == true ? .accentColor : .gray)
            Rectangle().cornerRadius(15).frame(width: UIScreen.main.bounds.width/2.4-10, height:250).foregroundColor(.black).overlay(
                VStack(alignment: .center){
                    HStack{
                        Spacer()
                        if(selected){
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.accentColor).frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding([.horizontal,.top])
                        }
                        else{
                            ZStack{
                                Circle().frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.gray)
                                Circle().frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                            }.padding([.horizontal,.top])
                        }
                    }
                    Spacer()
                    Image(image)
                    Spacer()
                
            })
        }
    }
}
