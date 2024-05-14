import SwiftUI

struct MoviesListView: View {
    @State var movies: [MovieInfo] = []
    @State private var search: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Movies list")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 64)
                    
                    TextField("", text: $search, prompt: Text("Search...").foregroundColor(.white))
                        .padding(10)
                        .font(.system(size: 18))
                        .frame(width: 0.9 * UIScreen.main.bounds.width)
                        .foregroundColor(.white)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.white, lineWidth: 2))
                        .padding(.bottom, 24)
                    
                    ForEach(getFilteredMovies(movies: movies)) { movie in
                        MovieItemView(movie: movie)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 100)
            }
            .background(Color.black.opacity(0.95))
            .ignoresSafeArea(.all)
            .onAppear() {
                Task {
                    do {
                        movies = try await MoviesManager.shared.getMovies()
                    }
                }
            }
        }
    }
    
    func getFilteredMovies(movies: [MovieInfo]) -> [MovieInfo] {
        guard !search.isEmpty else {
            
            return movies
        }
        
        return movies.filter { movie in
            movie.name.lowercased().contains(search.lowercased())
        }
    }
}

#Preview {
    NavigationStack {
        MoviesListView()
    }
}
