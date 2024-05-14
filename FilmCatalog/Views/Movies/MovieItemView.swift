import SwiftUI

struct MovieItemView: View {
    @State var movie: MovieInfo

    var body: some View {
        NavigationLink(destination: MovieDetailsView(movie: movie).toolbarRole(.editor)) {
            VStack {
                Text(movie.name)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 200)
            }
            .background(Color.green)
            .cornerRadius(16)
            .frame(width: 0.9 * UIScreen.main.bounds.width)
            .padding(.bottom)
        }
    }
}

#Preview {
    NavigationStack {
        MovieItemView(movie: MovieInfo(movieRef: nil, name: "Street", description: "Movie is about street fighters and ther life", pictureNames: []))
    }
}
