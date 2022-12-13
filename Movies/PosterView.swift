//
//  PosterView.swift
//  Movies
//
//  Created by MahmoudFares on 11/12/2022.
//

import SwiftUI

struct PosterView: View {
    
    init(
        image: String,
        width: CGFloat,
        height: CGFloat
    ) {
        self.image = image
        self.width = width
        self.height = height
    }
    
    var image: String
    var width: CGFloat
    var height: CGFloat
    
    private var url: URL? {
        URL(string: image)
    }
    
    var body: some View {
        AsyncImage(url: url,
                   scale: 0.75,
                   transaction: .init(animation: .easeInOut)
        ) { phase in
            // handle phase for image in all cases
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .frame(width: width, height: height)
                    .cornerRadius(8)
                    .clipped()
            case  .failure:
                Image("linear-video-play")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .frame(width: width, height: height)
                    .background(Color.gray)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 8
                        )
                    )
            case  .empty:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .frame(width: width, height: height)
                    .background(Color.gray)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 8
                        )
                    )
            @unknown default:
                Text("N/A")
                    .frame(width: width, height: height)
            }
        }
    }
}

struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView(image: "",width: 100, height: 100)
    }
}

