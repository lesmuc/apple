//
//  ContentView.swift
//  AppleRepositories
//
//  Created by Udo Von Eynern on 16.06.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = RepositoriesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.loadingState {
                    case .loading:
                        ProgressView()
                    case .loaded:
                        List(viewModel.items, id: \.self) {
                            ItemView(repository: $0)
                        }
                    case .failed:
                        Text(viewModel.error?.localizedDescription ?? "").padding(10)
                    case .none:
                        Spacer()
                }
            }
            .navigationBarTitle("Apple Repositories")
        }
        .onAppear {
            self.viewModel.fetchItems()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
