//
//  LocationManager.swift

import UIKit
import CoreLocation

typealias LocationManagerSuccess = (_ location: CLLocation) -> Void
typealias LocationManagerFailure = (_ error: NSError) -> Void
typealias LocationManagerStatusHandler = (_ status: CLAuthorizationStatus) -> Void

final class LocationManager: NSObject, CLLocationManagerDelegate {

    private struct Constants {
        static let minimumHorizontalAccuracy = 500
        static let UserLocationDictionaryKey = "UserLocationDictionaryKey"
        struct NotificationNames {
            static let UserLocationUpdate = "UserLocationUpdate"
        }
    }

    // MARK: - Instance variables

    /// Use this class as Singleton
    static let sharedInstance = LocationManager()

    // MARK: Private

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()

    private var onUpdateLocationSuccess: LocationManagerSuccess?
    private var onUpdateLocationFailure: LocationManagerFailure?
    private var onStatusChange: LocationManagerStatusHandler?

    // MARK: Initializaton

    override private init() {}

    // MARK: Public methods

    final func startUpdatingLocation() {
        #if os(tvOS)
        #else
            locationManager.startUpdatingLocation()
        #endif
    }

    final func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    final func getCurrentDeviceLocation(_ success: @escaping LocationManagerSuccess, failure: @escaping LocationManagerFailure) {
        #if os(tvOS)
        #else
            locationManager.startUpdatingLocation()
            onUpdateLocationFailure = failure
            onUpdateLocationSuccess = success
        #endif
    }

    final func isAccessGranted() -> Bool {
        return CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied
            && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.notDetermined
    }

    final func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    final func requestAuthorizationWithCompletion(_ completion: LocationManagerStatusHandler?) {
        locationManager.requestWhenInUseAuthorization()
        self.onStatusChange = completion
    }

    /**
     stored location, which we got from the last delegate call

     :return a tuple with a location and a timestamp as NSDate
     */
    final var currentUserLocation: (location: CLLocation, timeStamp: Date)?

    /**
     Get the last stored location if not older than the value of the parameter in fraction of seconds

     :return a location or nil
     */
    final func currentUserLocationNotOlderThan(seconds: Double) -> CLLocation? {
        if let info = currentUserLocation {
            let now = Date()
            if now.timeIntervalSince(info.timeStamp) < seconds {
                return info.location
            } else {
                // just trigger a "defensive" location update, if we timed out
                // so next time, we will have a fresher location...
                if isAccessGranted() {
                    startUpdatingLocation()
                }
            }
        }
        return nil
    }

    // MARK: CLLocationManagerDelegate

    final func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.first {
            if lastLocation.horizontalAccuracy < CLLocationAccuracy(Constants.minimumHorizontalAccuracy) {
                currentUserLocation = (location: lastLocation, timeStamp: Date())

                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: Constants.NotificationNames.UserLocationUpdate),
                    object: self,
                    userInfo: [Constants.UserLocationDictionaryKey: lastLocation]
                )

                onUpdateLocationSuccess?(lastLocation)
                onUpdateLocationSuccess = nil
                locationManager.stopUpdatingLocation()
            }
        }
    }

    final func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onUpdateLocationFailure?(error as NSError)
        onUpdateLocationFailure = nil
    }

    final func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.notDetermined {
            onStatusChange?(status)
            onStatusChange = nil
        }
    }
}
