//
//  ContentView.swift
//  MotorBluetooth
//
//  Created by Diego Santacruz on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bluetoothService = BluetoothService()
    @State private var selectedDeviceName: String? = "Seleccione un dispositivo"
    @State private var consoleID = UUID()
    @State private var consoleText: String = "Bienvenido...\n\nSeleccione un dispositivo para conectar.\n"
    
    var body: some View {
        VStack {
            HStack {
                Text("Estado del Bluetooth: ")
                
                if bluetoothService.isLoadingConnect {
                    ProgressView()
                }
                else {
                    Text(bluetoothService.isConnected ? "Conectado" : "Desconectado")
                        .font(.headline)
                }
            }
            
            Divider()
                .frame(width: 470)
            
            HStack {
                Picker("Dispositivos:", selection: $selectedDeviceName) {
                    Text("Seleccione un dispositivo").tag("Seleccione un dispositivo")
                    ForEach(bluetoothService.devicesNames, id: \.self) { deviceName in
                        Text(deviceName).tag(deviceName)
                    }
                }
                .frame(width: 300)
                .pickerStyle(MenuPickerStyle())
                .disabled(bluetoothService.isConnected || bluetoothService.isLoadingConnect)
                
                Button(action: {
                    bluetoothService.getDevices()
                    appendToConsole("Dispositivos actualizados...")
                }) {
                    Text("Refrescar")
                }
                .disabled(bluetoothService.isConnected || bluetoothService.isLoadingConnect)
                
                Button(action: {
                    if (bluetoothService.isConnected)
                    {
                        DispatchQueue.global(qos: .background).async {
                            bluetoothService.disconnect()
                            DispatchQueue.main.async {
                                appendToConsole("Desconectado...")
                            }
                        }
                    }
                    else
                    {
                        
                        DispatchQueue.global(qos: .background).async {
                            bluetoothService.connect(deviceName: selectedDeviceName!)
                            DispatchQueue.main.async {
                                appendToConsole("Conectado...")
                            }
                        }
                    }
                    
                }) {
                    if bluetoothService.isConnected {
                        Text("Desconectar")
                    }
                    else {
                        Text("Conectar")
                    }
                }
                .disabled(selectedDeviceName == nil || bluetoothService.isLoadingConnect)
            }
            
            Divider()
                .frame(width: 470)
            
            HStack{
                CustomButton(action: {
                    appendToConsole("Enviado: P")
                    bluetoothService.sendMessage("P")
                }) {
                    HStack(spacing: 0){
                        Text("P")
                            .fontWeight(.bold)
                        Text("arar")
                    }
                    .frame(width: 100)
                }
                .disabled(!bluetoothService.isConnected)
                
                CustomButton(action: {
                    appendToConsole("Enviado: A")
                    bluetoothService.sendMessage("A")
                }) {
                    HStack(spacing: 0){
                        Text("A")
                            .fontWeight(.bold)
                        Text("rrancar")
                    }
                    .frame(width: 100)
                }
                .disabled(!bluetoothService.isConnected)
            }
            .disabled(!bluetoothService.isConnected)
            
            HStack{
                CustomButton(action: {
                    appendToConsole("Enviado: I")
                    bluetoothService.sendMessage("I")
                }) {
                    HStack(spacing: 0){
                        Text("I")
                            .fontWeight(.bold)
                        Text("ncrementar")
                    }
                    .frame(width: 100)
                }
                .disabled(!bluetoothService.isConnected)
                
                CustomButton(action: {
                    appendToConsole("Enviado: R")
                    bluetoothService.sendMessage("R")
                }) {
                    HStack(spacing: 0){
                        Text("R")
                            .fontWeight(.bold)
                        Text("educir")
                    }
                    .frame(width: 100)
                }
                .disabled(!bluetoothService.isConnected)
            }
            
            HStack{
                CustomButton(action: {
                    appendToConsole("Enviado: C")
                    bluetoothService.sendMessage("C")
                }) {
                    HStack(spacing: 0){
                        Text("C")
                            .fontWeight(.bold)
                        Text("iclo")
                    }
                    .frame(width: 100)
                }
                .disabled(!bluetoothService.isConnected)
            }
            
            Divider()
                .frame(width: 470)
            
            HStack {
                Spacer()
                Button(action: {
                    consoleText = "";
                    consoleID = UUID()
                }) {
                    Image(systemName: "trash")
                }
            }
            .frame(width: 464)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(consoleText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(6)
                            .background(Color.black)
                            .foregroundColor(.green)
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .cornerRadius(4)
                            .id(consoleID)
                    }
                }
                .frame(height: 100)
                .onChange(of: consoleText) {
                    withAnimation {
                        proxy.scrollTo(consoleID, anchor: .bottom)
                    }
                }
            }
            .frame(width: 470)
            .background(Color.black)
            .cornerRadius(4)
            
            HStack {
                VStack {
                    HStack {
                        Text("Desarrollado por: ").font(.caption)
                        Text("Diego Santacruz").font(.caption)
                    }
                }
                Spacer()
                
                Text("v1.0.0").font(.caption)
            }
            .frame(width: 464)
            
        }
        .padding()
        .onAppear() {
            bluetoothService.getDevices()
        }
    }
    
    func appendToConsole(_ newText: String) {
        consoleText += "\(newText)\n"
        consoleID = UUID()
    }
}

#Preview {
    ContentView()
}
