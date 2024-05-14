import SwiftUI
import FirebaseFirestore

struct MovieDetailsView: View {
    @State var movie: MovieInfo
    @State var isFavourite = false
    @State var isLoading = false
    
    func handleClick() async {
        do {
            isLoading = true
            
            defer {
                isLoading = false
            }
            
            if (isFavourite) {
                try await MoviesManager.shared.removeFromFavourites(ref: movie.movieRef!)
            } else {
                try await MoviesManager.shared.addToFavourites(ref: movie.movieRef!)
            }
            
            isFavourite.toggle()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.95)
                .ignoresSafeArea(.all)
            VStack {
                Text(movie.name)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                if (movie.pictureNames.count > 0) {
                    SliderView(movie: movie)
                } else {
                    Text("No photos yet")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                        .padding(.vertical, 20)
                }
                
                Text("Desctiption")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 6)
                
                ScrollView {
                    Text(movie.description)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 0.8 * UIScreen.main.bounds.width)
                }
                .padding(.bottom, 20)
                
                Spacer()
                
                ButtonView(action: handleClick, text: isFavourite ? "Remove from Favourites" : "Add to Favourites", disabled: isLoading)
                    .padding(.bottom, 30)
            }
        }
        .onAppear() {
            Task {
                isLoading = true
                isFavourite = try await MoviesManager.shared.isMovieFavourite(ref: movie.movieRef!)
                isLoading = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailsView(movie: MovieInfo(movieRef: nil, name: "Street", description: "Movie is about street fighters and ther life", pictureNames: []))
    }
}
