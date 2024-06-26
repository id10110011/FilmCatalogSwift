import SwiftUI

struct SliderView: View {
    @State var movie: MovieInfo
    
    var body: some View {
        TabView {
            ForEach(movie.pictureNames, id: \.self) { image in
                AsyncImage(url: URL(string: image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 0.8 * UIScreen.main.bounds.width, height: 180)
                            .clipped()
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .frame(height: 270)
    }
}
