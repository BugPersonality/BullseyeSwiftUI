//
//  ContentView.swift
//  Bullseye
//
//  Created by Данил Дубов on 18.10.2020.
//

import SwiftUI

struct ContentView: View{
    //Properties
    //==========
    
    //Colors
    let midNightBlue = Color(red: 0, green: 0.2, blue: 0.4)
    
    //User interface views
    @State var alterIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var round = 1
    var sliderValueRounded: Int{
        return Int(self.sliderValue.rounded())
    }
    
    var difference: Int{
        return Int(abs(self.sliderValueRounded - self.target))
    }
    
    struct LableStyle: ViewModifier{
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
                .foregroundColor(Color.black)
                .modifier(Shadows())
        }
    }

    struct ValueStyle: ViewModifier{
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 24))
                .foregroundColor(Color.white)
                .modifier(Shadows())
        }
    }

    struct Shadows: ViewModifier{
        func body(content: Content) -> some View {
            content
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        }
    }
    
    struct ButtonLargeTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
                .foregroundColor(Color.black)
        }
    }
    
    struct ButtonSmallTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 12))
                .foregroundColor(Color.black)
        }
    }
    
    //User interface content and loyout
    var body: some View{
        NavigationView(){
            VStack{
                Spacer().navigationBarTitle("☑️ Bullseye ☑️")
                
                //Target row
                HStack {
                    Text("Put Bullseye as close as you can to:")
                        .modifier(ValueStyle())
                        .padding()
                    Text("\(self.target)")
                        .font(Font.custom("Arial Rounded MT Bold", size: 24))
                        .foregroundColor(Color.orange)
                        .modifier(Shadows())
                }
                
                Spacer()
                
                //Slider row
                HStack{
                    Text("1")
                        .modifier(ValueStyle())
                    
                    Slider(value: self.$sliderValue, in: 1...100)
                        .accentColor(Color.green)
                        .animation(.easeOut)
                    
                    Text("100")
                        .modifier(ValueStyle())
                }
                
                Spacer()

                //Button row
                Button(action:{
                    self.alterIsVisible = true
                
                }){
                    Text("Hit me !")
                        .modifier(ButtonLargeTextStyle())
                }
                .background(Image("Button"))
                .modifier(Shadows())
                
                .alert(isPresented:self.$alterIsVisible){
                    Alert(title: Text("\(alterTitleMessage())"),
                          message: Text(self.scoringMessage()),
                          dismissButton: .default(Text("Continue")){
                            startNewRound()
                          })
                    }
                
                Spacer()
                
                //Score row
                HStack{
                    Button(action:{startNewGame()}){
                        HStack{
                            Image("StartOverIcon")
                            Text("Start over")
                                .modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button"))
                    .modifier(Shadows())
                    
                    Spacer()
                    
                    Text("Score:")
                        .modifier(ValueStyle())
                    
                    Text("\(self.score)")
                        .font(Font.custom("Arial Rounded MT Bold", size: 24))
                        .foregroundColor(Color.orange)
                        .modifier(Shadows())
                    
                    Spacer()
                    
                    Text("Round:")
                        .modifier(ValueStyle())
                    
                    Text("\(self.round)")
                        .font(Font.custom("Arial Rounded MT Bold", size: 24))
                        .foregroundColor(Color.orange)
                        .modifier(Shadows())
                    
                    Spacer()
                    
                    NavigationLink(destination: AboutView()){
                        HStack{
                            Image("InfoIcon")
                            Text("Info")
                                .modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button"))
                    .modifier(Shadows())
                }
                .accentColor(midNightBlue)
                .padding(.bottom, 20)
            }
            .onAppear(){
                startNewGame()
            }
            .background(Image("Background"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func pointsForCurrentRound() -> Int{
        let maximumScore = 100
        let points: Int
        
        if self.difference == 0{
            points = 200
        }
        else if self.difference == 1{
            points = 150
        }
        else{
            points = maximumScore - self.difference
        }
        
        return points
    }
    
    func scoringMessage() -> String{
        return "The Slider's value is \(self.sliderValueRounded).\n" +
               "The target value is \(self.target).\n" +
               "Your scored \(self.pointsForCurrentRound()) in this round."
    }
    
    func alterTitleMessage() -> String{
        if self.difference == 0{
            return "Perfect !"
        }
        else if self.difference <= 5{
            return "You almost did it !"
        }
        else if self.difference <= 10{
            return "Not bad."
        }
        else{
            return "Are you even trying ?"
        }
    }
    
    func startNewRound(){
        self.score += self.pointsForCurrentRound()
        self.round += 1
        resetSliderAndTirget()
        
    }
    
    func startNewGame(){
        self.round = 1
        self.score = 0
        resetSliderAndTirget()
    }
    
    func resetSliderAndTirget(){
        self.sliderValue = Double.random(in: 1...100)
        self.target = Int.random(in: 1...100)
    }
}

//Preview
//=======

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
