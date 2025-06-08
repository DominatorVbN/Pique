//
//  ContentView.swift
//  Pique
//
//  Created by Amit Samant on 07/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Scroll effects") {
                    NavigationLink("Circular carousel") {
                        CircularCarouselView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Circular carousel")
                    }
                    NavigationLink("Parallax carousel") {
                        ParallaxCarouselView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Parallax carousel")
                    }
                }
                Section("Visual effects") {
                    NavigationLink("Hue rotation") {
                        HueRotationView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Hue rotation")
                    }
                    NavigationLink("Hue and scale") {
                        HueAndScaleView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Hue and scale")
                    }
                }
                Section("Mesh gradients") {
                    NavigationLink("Mesh gradients") {
                        MeshGradientView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Mesh gradients")
                    }
                }
                
                Section("Transitions") {
                    NavigationLink("Transitions") {
                        TransitionsView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Transitions")
                    }
                }
                
                Section("Text renderer") {
                    NavigationLink("Text renderer") {
                        TextRendererView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Text renderer")
                    }
                }
                
                Section("Shaders") {
                    NavigationLink("Custom fill") {
                        CustomFillView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Custom fill")
                    }
                    
                    NavigationLink("Color effect") {
                        ColorEffectView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Color effect")
                    }
                    
                    NavigationLink("Distortion effect") {
                        DistortionEffectView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Distortion effect")
                    }
                    NavigationLink("Layer effect") {
                        LayerEffectView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Layer effect")
                    }
                }
            }
            .navigationTitle("👀 Pique")
        }
    }
}

#Preview {
    ContentView()
}
