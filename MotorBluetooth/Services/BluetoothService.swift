//
//  BluetoothService.swift
//  MotorBluetooth
//
//  Created by Diego Santacruz on 4/11/24.
//

import IOBluetooth

class BluetoothService : NSObject, ObservableObject {
    @Published var statusMessage: String = "Desconectado"
    @Published var devicesNames: [String] = []
    @Published var isConnected: Bool = false
    @Published var isLoadingConnect: Bool = false
    
    private var device: IOBluetoothDevice?
    private var rfcommChannel: IOBluetoothRFCOMMChannel?
    
    
    func getDevices() {
        devicesNames = IOBluetoothDevice.pairedDevices()
            .compactMap { ($0 as? IOBluetoothDevice)?.name }
    }
    
    func connect(deviceName: String) {
        isLoadingConnect = true
        isConnected = false
        rfcommChannel = nil
        
        let devices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice]
        let device = devices?.first(where: { $0.name == deviceName })
        
        if device == nil {
            statusMessage = "Dispostivo no encontrado"
            return
        }
        
        self.device = device
        let channelID: BluetoothRFCOMMChannelID = 1
        let result = device?.openRFCOMMChannelSync(&rfcommChannel, withChannelID: channelID, delegate: self)
        
        isConnected = result == kIOReturnSuccess
        isLoadingConnect = false
        
        if isConnected {
            statusMessage = "Conectado"
        } else {
            statusMessage = "Conexión fallida"
        }
    }
    
    func disconnect() {
        guard let channel = rfcommChannel else {
            statusMessage = "Desconectado"
            return
        }
        
        channel.close()
        rfcommChannel = nil
        device = nil
        isConnected = false
        statusMessage = "Desconectado"
    }
    
    func sendMessage(_ message: String) {
            guard isConnected, let channel = rfcommChannel else {
                print("No hay conexión establecida")
                return
            }
            
            // Convertir el mensaje a Data
            guard let data = message.data(using: .utf8) else {
                print("Error al convertir el mensaje")
                return
            }
            
            var mutableData = data // Crear una copia mutable de los datos
            
            // Obtener un puntero mutable a los datos
            let result = mutableData.withUnsafeMutableBytes { bytes -> IOReturn in
                guard let baseAddress = bytes.baseAddress else {
                    return kIOReturnError
                }
                return channel.writeSync(baseAddress, length: UInt16(data.count))
            }
            
            if result == kIOReturnSuccess {
                print("Mensaje enviado: \(message)")
                
            } else {
                print("Error al enviar mensaje")
            }
        }
    
}
