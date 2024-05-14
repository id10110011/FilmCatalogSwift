import SwiftUI

struct FavouritesView: View {
    @State var favourites: [MovieInfo] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Favourites")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 24)
                        .padding(.top, 64)
                    
                    if favourites.count > 0 {	 	
                        ForEach(favourites) { movie in
                            MovieItemView(movie: movie)
                        }
                    } else {
                        Text("Nothing to show")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                        
                        Text("You can add some on the \"Cars\" tab")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(.bottom, 24)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color.black.opacity(0.95))
            .ignoresSafeArea(.all)
            .onAppear() {
                Task {
                    do {
                        favourites = try await MoviesManager.shared.getFavourites()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavouritesView()
    }
}
