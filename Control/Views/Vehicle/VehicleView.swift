//
//  VehiclesItem.swift
//  Control
//
//  Created by Will DeBerry on 7/7/20.
//

import SwiftUI

struct VehicleView: View {
    @EnvironmentObject var controlModel: ControlModel
    var vehicle: Vehicle
    var model: String

    var body: some View {
        NavigationView {
            if controlModel.isLoading {
                ProgressView("Loading...")
            } else {
                VStack(spacing: 15) {
                    HStack {
                        DetailsView(vehicle: vehicle, model: model)
                            .padding([.leading, .bottom], 30)
                            .padding([.trailing], 15)

                        BatteryProgress(chargeState: $controlModel.chargeState)
                            .frame(width: 125.0, height: 125.0)
                            .padding([.trailing, .bottom], 30)
                            .padding([.leading], 15)
                            .shadow(radius: 10.0, x: 10, y: 10)
                    }
                    Divider()

                    ActionsView(vehicle: vehicle)
                    Spacer()
                }
                .navigationBarHidden(true)
            }
        }
        .navigationTitle(model)
        .onAppear(perform: getChargeData)
    }

    private func getChargeData() {
        controlModel.api.getChargeState(id: vehicle.idS) { chargeState in
            if let chargeState = chargeState {
                DispatchQueue.main.async {
                    controlModel.chargeState = chargeState
                    controlModel.isLoading = false
                }
            }
        }
    }
}

struct VehiclesItem_Previews: PreviewProvider {
    static var previews: some View {
        VehicleView(vehicle: vehicle1, model: "Model 3")
            .environmentObject(
                ControlModel(
                    isLoading: false,
                    vehicles: [vehicle1, vehicle2],
                    chargeState: sampleChargeState,
                    vehicleState: sampleVehicleState
                )
            )
    }
}