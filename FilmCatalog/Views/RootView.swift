import SwiftUI

struct RootView: View {
    @State var isAuthenticated: Bool = false
    
    var body: some View {
        if isAuthenticated {
            TabView {
                ProfileView(isAuthenticated: $isAuthenticated)
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
                MoviesListView()
                    .tabItem {
                        Image(systemName: "macpro.gen1")
                        Text("Movies")
                    }
                FavouritesView()
                    .tabItem {
                        Image(systemName: "bookmark.fill")
                        Text("Favourites")
                    }
            }
            .accentColor(.green)
            .onAppear() {
                UITabBar.appearance().barTintColor = .black
            }
        } else {
            SignInView(isAuthenticated: $isAuthenticated)
                .onAppear {
                    if AuthManager.shared.getAuthenticatedUser() != nil {
                        isAuthenticated = true
                    }
                }
        }
    }
}

#Preview {
    RootView()
}
