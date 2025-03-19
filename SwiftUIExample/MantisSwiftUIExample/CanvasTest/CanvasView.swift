//
//  SwiftUIView.swift
//  MantisSwiftUIExample
//
//  Created by Saiful Islam Sagor on 18/3/25.
//

import SwiftUI

struct CanvasView: View {
    @State var offset = CGPoint(x: 20, y: 50)
    var body: some View {
        Canvas { context, size in
//            context.draw(Image(systemName: "star"), at: offset)
            context.draw(Image(systemName: "star"), in: .init(origin: .init(x: offset.x/2, y: offset.y/2), size: size), style: .init(antialiased: false) )
            context.translateBy(x: 20, y: 20)
            context.fill(triangle, with: .color(.cyan))
        }
        .frame(width: 300, height: 600)
        .border(.red)
        .gesture(
            DragGesture()
                .onChanged { value in
                    offset = value.location
                }
        )
    }
    private var triangle: Path {
        Path{path in
            path.move(to: .zero)
            path.addLine(to: .init(x: 20, y: 20))
            path.addLine(to: .init(x: 20, y: 40))
            path.closeSubpath()
        }
    }
}

#Preview {
    CanvasView()
}
