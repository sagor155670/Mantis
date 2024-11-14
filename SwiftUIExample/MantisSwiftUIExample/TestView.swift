//
//  TestView.swift
//  MantisSwiftUIExample
//
//  Created by Saiful Islam Sagor on 13/11/24.
//

import SwiftUI

struct TestView: View {
    @State var centerIndex: Int = 0
    @Namespace var nameSpace
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal,showsIndicators: false){
                LazyHStack(spacing: 25){
                    ForEach(-90..<91){ index in
                        barView(index: index)
                            .id(index)
                            .anchorPreference(key: visibleBarPreference.self, value: .bounds, transform: { anchor in
                                [.init(id: index, bounds: anchor)]
                            })
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width/2 - 2)
            }
            .overlayPreferenceValue(visibleBarPreference.self, { value in
                GeometryReader { geo -> Color in
                    
                    let localFrame = geo.frame(in: .local)
                    let boundInfoList = value.map{ barItem in
                        let inBounds = localFrame.intersects(geo[barItem.bounds])
                        return (inBounds: inBounds ,barItem: barItem, index: barItem.id)
                    }
                    let visibleList = boundInfoList.filter{ $0.inBounds }
                    let barWithDistanceList = visibleList.map{ inBounds,barItem, index in
                        return (index: index, distance: abs( localFrame.midX - geo[barItem.bounds].midX))
                    }
                    let itemWithMinDistance = barWithDistanceList.min(by: { $0.distance < $1.distance })
                    guard let centerIndex = itemWithMinDistance?.index else{
                        return Color.clear
                    }
                    //                    self.setCenterIndex(withIndex: centerIndex)
                    //                    Text("\(itemWithMinDistance)")
                    return Color.clear
                }
            })
            .overlay{
                Capsule()
                    .fill(.green)
                    .frame(width: 4, height: 25)
            }
            .onChange(of: centerIndex ){  newValue in
                proxy.scrollTo(newValue,anchor: .center)
            }
            .onAppear{
                proxy.scrollTo(0, anchor: .center)
            }
        }
        
    }
    @ViewBuilder
    private func barView(index: Int) -> some View{
        let capsule =  Capsule()
            .fill(index%10 == 0 ? .red : .black)
            .frame(width: index%10 == 0 ? 4 : 2,height: index%10 == 0 ? 20 : 12)
            .overlay{
                Text("\(index)")
                    .font(.caption)
                    .frame(width: 20)
                    .offset(y: 20)
            }
        return capsule
    }
    private func setCenterIndex(withIndex index: Int){
        self.centerIndex = index
    }
}


struct barInfo{
    let id: Int
    let bounds: Anchor<CGRect>
}

struct visibleBarPreference: PreferenceKey{
    static var defaultValue: [barInfo] = []
    
    static func reduce(value: inout [barInfo], nextValue: () -> [barInfo]) {
        value.append(contentsOf: nextValue())
    }
    
    
    typealias Value = [barInfo]
}

#Preview {
    TestView()
}
