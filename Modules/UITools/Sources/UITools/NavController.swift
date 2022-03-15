//
//  File.swift
//  
//
//  Created by ILIYA on 24.09.2021.
//

import Foundation
import SwiftUI

// MARK: - Public API

public struct NavControllerView<Content>: View where Content: View {
    
    @ObservedObject private var viewModel: NavControllerViewModel
    
    private let content: Content
    
    public init(@ViewBuilder content: @escaping ()->Content) {
        viewModel = NavControllerViewModel()
        self.content = content()
    }
    
    public var body: some View {
        let isRoot = viewModel.currentScreen == nil
        return ZStack {
            if isRoot {
                content
                    .environmentObject(viewModel)
            }
            else {
                viewModel.currentScreen!.nextScreen
                    .environmentObject(viewModel)
            }
        }
    }
    
}

public struct NavPushButton<Label, Destination>: View where Label: View, Destination: View {
    
    @EnvironmentObject private var viewModel: NavControllerViewModel
    
    private let destination: Destination
    private let label: Label
    private var action: (() -> Void)?
    
    public init(
        action: (() -> Void)? = nil,
        destination: Destination,
        @ViewBuilder label: @escaping ()->Label
    ) {
        self.destination = destination
        self.action = action
        self.label = label()
    }
    
    public var body: some View {
#if os(iOS)
        label.onTapGesture {
            action?()
            viewModel.push(destination)
        }
#endif
    }
}

public struct NavPopButton<Label>: View where Label: View {
    
    @EnvironmentObject private var viewModel: NavControllerViewModel
    
    private let destination: PopDestination
    private let label: Label
    
    public init(destination: PopDestination, @ViewBuilder label: @escaping ()->Label) {
        self.destination = destination
        self.label = label()
    }
    
    public var body: some View {
#if os(iOS)
        label.onTapGesture {
            viewModel.pop(to: destination)
        }
#endif
    }
}



// MARK: - Private API

final class NavControllerViewModel: ObservableObject {
    
    @Published fileprivate var currentScreen: Screen?
    private var screenStack  = ScreenStack() {
        didSet {
            currentScreen = screenStack.top()
        }
    }
    
    init() {
        
    }
    
    // API
    func push<S: View>(_ screenView: S) {
        let screen = Screen(id: UUID().uuidString, nextScreen: AnyView(screenView))
        screenStack.push(screen)
    }
    
    func pop(to: PopDestination) {
        switch to {
        case .root:
            screenStack.popToRoot()
        case .previous:
            screenStack.popTopPrevious()
        }
    }
    
}

// MARK: - Enums

public enum PopDestination {
    case previous
    case root
}


// MARK: - Nav Stack Logic

private struct ScreenStack {
    
    private var screens: [Screen] = .init()
    
    func top() -> Screen? {
        screens.last
    }
    
    mutating func push(_ s: Screen) {
        screens.append(s)
    }
    
    mutating func popTopPrevious() {
        _ = screens.popLast()
    }
    
    mutating func popToRoot() {
        screens.removeAll()
    }
    
}

struct Screen: Identifiable, Equatable {
    
    let id: String
    let nextScreen: AnyView
    
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        return lhs.id == rhs.id
    }
    
}
