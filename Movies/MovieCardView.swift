

import SwiftUI
import ComposableArchitecture

// MARK: Movie Card Reducer

struct MovieCard: ReducerProtocol {
    // MARK: State
    struct State: Equatable, Identifiable {
        var id: Int {
            movie.id
        }
        var movie: Movie
        
        var title: String {
            movie.title
        }
        
        var year: String {
            movie.releaseDate
        }
        
        var image: String {
            movie.fullPosterPath
        }
    }
    
    // MARK: Action
    enum Action: Equatable {
        case onAppear
        case onTapped(Movie)
    }
    
    // MARK: Reducer
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}

struct MovieCardView: View {
    /// store Take MovieCard Reducer type of ReducerProtocol
    let store: StoreOf<MovieCard>
    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: {
                viewStore.send(.onTapped(viewStore.movie))
            }, label: {
                HStack(alignment: .top) {
                    PosterView(
                        image: viewStore.image,
                        width: 150,
                        height: 200
                    )
                    VStack(
                        alignment: .leading,
                        spacing: 5
                    ) {
                        Text(viewStore.title)
                            .lineLimit(2)
                            .fontWeight(.bold)
                        Text(viewStore.year)
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    Spacer()
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            })
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
        
    }
}

#if DEBUG
struct MovieCardView_Previews: PreviewProvider {
   static let store: StoreOf<MovieCard> =
        .init(
            initialState: .init(movie: .mock),
        reducer: MovieCard()
        )
    static var previews: some View {
        MovieCardView(store: store)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
