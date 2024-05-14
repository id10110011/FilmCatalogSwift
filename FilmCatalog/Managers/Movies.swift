import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MovieInfo: Identifiable, Decodable {
    var id: String {
        self.name
    }
    
    var movieRef: DocumentReference?
    let name: String
    let description: String
    let pictureNames: [String]
}

class MoviesManager {
    static let shared = MoviesManager()
    
    func getMovies() async throws -> [MovieInfo] {
        var movies: [MovieInfo] = []
        
        let querySnapshot = try await Firestore.firestore().collection("movies").getDocuments()
        for document in querySnapshot.documents {
            if var movie = try? document.data(as: MovieInfo.self) {
                movie.movieRef = document.reference
                movies.append(movie)
            }
        }
        
        return movies
    }
    
    func getFavs() async throws -> [DocumentReference] {
        let userAuth = AuthManager.shared.getAuthenticatedUser()
        let email = userAuth!.email
        let querySnapshot = try await Firestore.firestore().collection("favorites").document(email).getDocument().get("refArray")
    
        
        return querySnapshot as! [DocumentReference]
    }
    
    func getFavourites() async throws -> [MovieInfo] {
        var favourites: [MovieInfo] = []
        
        let favouritesRef = try await getFavs()
        for favourite in favouritesRef {
            var movie = try await favourite.getDocument().data(as: MovieInfo.self)
            movie.movieRef = favourite
            favourites.append(movie)
        }
        
        return favourites
    }
    
    func isMovieFavourite(ref: DocumentReference) async throws -> Bool {
        let favourites = try await getFavs()
        
        for favourite in favourites {
            if (favourite == ref) {
                return true
            }
        }
        return false
    }
    
    func addToFavourites(ref: DocumentReference) async throws {
        let userAuth = AuthManager.shared.getAuthenticatedUser()
        let email = userAuth!.email
        var favourites = try await getFavs()
        
        favourites.append(ref)
        try await Firestore.firestore().collection("favorites").document(email).setData(["refArray": favourites])
    }
    
    func removeFromFavourites(ref: DocumentReference) async throws {
        let userAuth = AuthManager.shared.getAuthenticatedUser()
        let userInfo = try await UsersManager.shared.getUser(email: userAuth!.email)
        var favorites = try await getFavs()
        
        favorites.removeAll { $0 == ref }
        
        try await Firestore.firestore().collection("favorites").document(userInfo!.email).setData(["refArray": favorites])
    }
}
