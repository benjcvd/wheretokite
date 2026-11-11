import MapKit
import SwiftUI
import KiteCore

/// The spot's wind drawn on a map (WHE-156): the beach line from the catalogue and one arrow
/// for the wind, tip on the launch, tail upwind. No animated flow: one forecast point per spot.
enum ShoreAngleStyle {
    /// Green when the wind comes from the water or along the beach, orange when it turns
    /// side-offshore, red offshore; white when the beach direction is unknown.
    static func color(_ relativeAngle: Double?) -> Color {
        guard let a = relativeAngle else { return .white }
        switch a {
        case ..<100: return Color(red: 0.25, green: 0.85, blue: 0.45)
        case ..<130: return .orange
        default: return .red
        }
    }

    /// "18 kn · side-onshore", or "18 kn · SW" when the beach direction is unknown.
    static func label(_ s: MapWind.Summary) -> String {
        let how = s.relativeAngle.map(Vocab.angle) ?? Vocab.compass(s.directionDeg)
        return String(localized: "\(Int(s.speedKn.rounded())) kn · \(how)", comment: "Wind on the spot map: speed and angle to the beach")
    }
}

struct SpotWindOverlay: MapContent {
    let spot: Spot
    let wind: MapWind.Summary
    /// Arrow length on the ground; sized for the spot page's 4 km map.
    var lengthM: Double = 1100

    private var at: Coordinate { Coordinate(latitude: spot.latitude, longitude: spot.longitude) }
    private func cl(_ c: [Coordinate]) -> [CLLocationCoordinate2D] {
        c.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    var body: some MapContent {
        if let facing = MapWind.seaFacing(spot, side: wind.side) {
            let shore = cl(MapWind.shoreLine(at: at, seaFacingDeg: facing, halfLengthM: lengthM * 0.8))
            MapPolyline(coordinates: shore)
                .stroke(.black.opacity(0.55), style: StrokeStyle(lineWidth: 7, lineCap: .round))
            MapPolyline(coordinates: shore)
                .stroke(.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
        }
        let arrow = MapWind.arrow(at: at, fromDeg: wind.directionDeg, lengthM: lengthM)
        let color = ShoreAngleStyle.color(wind.relativeAngle)
        let outline = StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)
        let stroke = StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
        MapPolyline(coordinates: cl(arrow.shaft)).stroke(.black.opacity(0.45), style: outline)
        MapPolyline(coordinates: cl(arrow.head)).stroke(.black.opacity(0.45), style: outline)
        MapPolyline(coordinates: cl(arrow.shaft)).stroke(color, style: stroke)
        MapPolyline(coordinates: cl(arrow.head)).stroke(color, style: stroke)
        Annotation("", coordinate: cl([arrow.shaft[0]])[0], anchor: .center) {
            Text("\(Int(wind.speedKn.rounded())) kn", comment: "Wind speed at the tail of the map's wind arrow")
                .font(.caption.weight(.bold))
                .monospacedDigit()
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(color, in: Capsule())
                .foregroundStyle(.black)
        }
        .annotationTitles(.hidden)
    }
}

/// Full-screen spot map: pan, zoom, map / satellite, and an hour slider over the session
/// that turns the arrow.
struct SpotMapScreen: View {
    let rec: SpotRecommendation
    @Environment(\.dismiss) private var dismiss
    @State private var index: Double
    @State private var satellite = true
    @State private var position: MapCameraPosition

    init(rec: SpotRecommendation) {
        self.rec = rec
        let first = MapWind.highlightedHours(rec).first?.wind.localTime
        _index = State(initialValue: Double(rec.hours.firstIndex { $0.wind.localTime == first } ?? 0))
        _position = State(initialValue: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: rec.spot.latitude, longitude: rec.spot.longitude),
            latitudinalMeters: 4000, longitudinalMeters: 4000)))
    }

    private var hour: HourScore? {
        rec.hours.indices.contains(Int(index)) ? rec.hours[Int(index)] : nil
    }

    var body: some View {
        Map(position: $position) {
            Marker(rec.spot.name, systemImage: "wind",
                   coordinate: CLLocationCoordinate2D(latitude: rec.spot.latitude, longitude: rec.spot.longitude))
                .tint(ScoreStyle.color(rec.finalScore))
            if let h = hour, let wind = MapWind.summary([h]) {
                SpotWindOverlay(spot: rec.spot, wind: wind)
            }
        }
        .mapStyle(satellite ? .hybrid(elevation: .realistic) : .standard(elevation: .realistic))
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Picker("Map style", selection: $satellite) {
                    Text("Map").tag(false)
                    Text("Satellite").tag(true)
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 220)
                .padding(3)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
                .accessibilityIdentifier("spotMapStyle")
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .frame(width: 36, height: 36)
                        .background(.regularMaterial, in: Circle())
                }
                .accessibilityLabel("Close")
                .accessibilityIdentifier("spotMapClose")
            }
            .padding(.horizontal)
            .padding(.top, 4)
        }
        .safeAreaInset(edge: .bottom) { hourPanel }
    }

    @ViewBuilder private var hourPanel: some View {
        if let h = hour, let wind = MapWind.summary([h]) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Text(String(format: "%02d:00", h.wind.hour))
                        .font(.title3.weight(.bold))
                        .monospacedDigit()
                    WindArrow(directionDeg: h.wind.directionDeg)
                        .foregroundStyle(WindStyle.color(h.wind.speedKn))
                    Text("\(Int(h.wind.speedKn.rounded())) kn · gusts \(Int(h.wind.gustKn.rounded()))", comment: "Hourly wind")
                        .font(.headline)
                        .monospacedDigit()
                    Spacer(minLength: 0)
                }
                .accessibilityElement(children: .combine)
                .accessibilityIdentifier("spotMapHour")
                if let a = wind.relativeAngle {
                    Label {
                        Text(Vocab.angle(a).prefix(1).localizedUppercase + Vocab.angle(a).dropFirst())
                    } icon: {
                        Image(systemName: "circle.fill").foregroundStyle(ShoreAngleStyle.color(a))
                    }
                    .font(.subheadline.weight(.semibold))
                }
                if rec.hours.count > 1 {
                    Slider(value: $index, in: 0...Double(rec.hours.count - 1), step: 1) {
                        Text("Hour")
                    } minimumValueLabel: {
                        Text(verbatim: "\(rec.hours.first!.wind.hour)h").font(.caption).monospacedDigit()
                    } maximumValueLabel: {
                        Text(verbatim: "\(rec.hours.last!.wind.hour)h").font(.caption).monospacedDigit()
                    }
                    .accessibilityValue(String(format: "%02d:00", h.wind.hour))
                    .accessibilityIdentifier("spotMapHourSlider")
                }
            }
            .padding(16)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
}
