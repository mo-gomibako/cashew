//
//  ContentView.swift
//  cashew
//
//  Created by mog on 2024/02/01.
//

import SwiftUI
import SwiftData
import AuthenticationServices
import GoogleSignInSwift

struct ContentView: View {
    init () {
        let customUINavBarAppearance = UINavigationBarAppearance()
        let customUITabBarAppearance = UITabBarAppearance()
        
        customUINavBarAppearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = customUINavBarAppearance
        
        customUITabBarAppearance.configureWithTransparentBackground()
        customUITabBarAppearance.backgroundColor = UIColor.black
        UITabBar.appearance().standardAppearance = customUITabBarAppearance
    }
    
    var body: some View {
        VStack {
            TabView() {
                ZStack(alignment: .bottomTrailing) {
                    HomeView()
                    LoginButton()
                        .padding(.bottom, 8)
                        .shadow(color: .black, radius: 4, x: 0, y:0)
                }
                .tabItem {
                    Label("検索", systemImage: "doc.text.magnifyingglass")
                }
                VStack {}
                .tabItem {
                    Label("募集", systemImage: "calendar")
                }
                VStack {}
                .tabItem {
                    Label("新着", systemImage: "checkmark.gobackward")
                }
                VStack {}
                .tabItem {
                    Label("注目", systemImage: "exclamationmark.arrow.circlepath")
                }
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .environment(\.colorScheme, .dark)
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var toolbarVisible = true
    
    var body: some View {
        NavigationSplitView {
            List {
                Section(header: Text("Hello"), footer: Spacer().frame(height: 48)) {
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
        
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar() {
                ToolbarItem(placement: .topBarLeading) {
                    Text("🫘")
                        .shadow(color: .black, radius: 4, x: 0, y:0)
                }
                ToolbarItem() {
                    Button(action: addItem) {
                        Label("追加", systemImage: "plus")
                            .shadow(color: .black, radius: 4, x: 0, y:0)
                    }
                }
                ToolbarItem() {
                    EditButton()
                        .shadow(color: .black, radius: 4, x: 0, y:0)
                }
            }
            .toolbar(toolbarVisible ? .visible : .hidden)
        } detail: {
            Text("Select an item")
        }
        .onAppear() {
            addItem()
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 13)
            .padding(.horizontal, 16)
            .background(.blue)
            .foregroundColor(.white)
            .font(.system(size: 14).bold())
            .clipShape(Capsule())
    }
}

struct LoginButton: View {
    @State private var isOpenSheet = false
    
    var body: some View {
        Button("ログイン") {
            isOpenSheet.toggle()
        }
        .buttonStyle(PrimaryButtonStyle())
        .sheet(isPresented: $isOpenSheet) {
            VStack {
                Image("landscape")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                LoginWithGoogleButton()
                LoginWithAppleButton()
                Button("キャンセル") {
                    isOpenSheet.toggle()
                }
            }
            .padding()
        }
    }
}

struct LoginWithAppleButton: View {
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { _ in },
            onCompletion: { _ in }
        )
        .signInWithAppleButtonStyle(.whiteOutline)
        .frame(height: 40)
    }
}

struct LoginWithGoogleButton: View {
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession: WebAuthenticationSession
    
    var body: some View {
        GoogleSignInButton(style: .wide) {
//            Task {
//                do {
//                    print(webAuthenticationSession)
//                    // Perform the authentication and await the result.
//                    let urlWithToken = try await webAuthenticationSession.authenticate(
//                        using: URL(string: "")!,
//                        callbackURLScheme: "net.momoogles.azuki",
//                        preferredBrowserSession: .ephemeral
//                    )
//                    // Call the method that completes the authentication using the
//                    // returned URL.
//                    print(urlWithToken)
//                } catch {
//                    // Respond to any authorization errors.
//                    print(error)
//                }
//            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
