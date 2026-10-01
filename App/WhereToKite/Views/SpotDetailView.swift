import Charts
import MapKit
import SwiftUI
import KiteCore

struct SpotDetailView: View {
    let rec: SpotRecommendation
    let day: DayOption
    let profile: RiderProfile

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: rec.spot.latitude, longitude: rec.spot.longitude)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Map(initialPosition: .region(MKCoordinateRegion(
                    center: coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000))) {
                    Marker(rec.spot.name, systemImage: "wind", coordinate: coordinate)
                }
                .mapStyle(.hybrid)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                header
                facts
                chart
                hourly
                directionsButton

                if let notes = rec.spot.notes {
                    Text(notes).font(.footnote).foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(rec.spot.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        HStack(spacing: 14) {
            ScoreBadge(score: rec.finalScore, size: 60)
            VStack(alignment: .leading, spacing: 4) {
                Text(ScoreStyle.label(rec.finalScore)).font(.title2.bold())
                Text(rec.windSummary ?? rec.reason)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var facts: some View {
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 10) {
            GridRow {
                Fact(title: "Best window", value: rec.windowLabel ?? "–", icon: "clock")
                Fact(title: "Kite", value: rec.suggestedKite.map { "\($0.size.formatted()) m" } ?? "–", icon: "wind")
            }
            GridRow {
                Fact(title: "Drive", value: rec.driveLabel, icon: "car")
                Fact(title: "Beach faces",
                     value: rec.spot.seaFacingDeg.map { Geo.compassName($0) } ?? "Unknown",
                     icon: "water.waves")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }

    private var chart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Wind (kn)").font(.headline)
            Chart {
                if let k = rec.suggestedKite {
                    RectangleMark(yStart: .value("Min", k.minKn), yEnd: .value("Max", k.maxKn))
                        .foregroundStyle(.green.opacity(0.12))
                        .annotation(position: .overlay, alignment: .topLeading) {
                            Text("\(k.size.formatted()) m range").font(.caption2).foregroundStyle(.green)
                        }
                }
                ForEach(rec.hours, id: \.wind.localTime) { h in
                    BarMark(x: .value("Hour", h.wind.hour), y: .value("Wind", h.wind.speedKn), width: 18)
                        .foregroundStyle(ScoreStyle.color(Int(h.score * 100)).gradient)
                    PointMark(x: .value("Hour", h.wind.hour), y: .value("Gust", h.wind.gustKn))
                        .symbol(.circle)
                        .symbolSize(30)
                        .foregroundStyle(.secondary)
                }
            }
            .chartXScale(domain: (rec.hours.first?.wind.hour ?? 9) - 1 ... (rec.hours.last?.wind.hour ?? 17) + 1)
            .chartYScale(domain: 0...yMax)
            .chartXAxis {
                AxisMarks(values: rec.hours.map(\.wind.hour)) { value in
                    AxisValueLabel { if let h = value.as(Int.self) { Text("\(h)h") } }
                }
            }
            .frame(height: 180)
            Text("Bars: average wind, coloured by score · Dots: gusts")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var yMax: Double {
        let peak = max(rec.hours.map(\.wind.gustKn).max() ?? 0, rec.suggestedKite?.maxKn ?? 0)
        return (peak / 5).rounded(.up) * 5 + 5
    }

    private var hourly: some View {
        VStack(spacing: 0) {
            ForEach(rec.hours, id: \.wind.localTime) { h in
                HStack {
                    Text(String(format: "%02d:00", h.wind.hour))
                        .monospacedDigit()
                        .frame(width: 50, alignment: .leading)
                    WindArrow(directionDeg: h.wind.directionDeg)
                        .foregroundStyle(.tint)
                        .frame(width: 20)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("\(Int(h.wind.speedKn.rounded())) kn · gusts \(Int(h.wind.gustKn.rounded()))")
                            .font(.subheadline)
                            .monospacedDigit()
                        Text(hourDetail(h))
                            .font(.caption)
                            .foregroundStyle(h.flags.isEmpty ? Color.secondary : Color.orange)
                    }
                    Spacer()
                    ScoreBadge(score: Int((h.score * 100).rounded()), size: 32)
                }
                .padding(.vertical, 8)
                Divider()
            }
        }
    }

    private func hourDetail(_ h: HourScore) -> String {
        var parts = [Geo.compassName(h.wind.directionDeg)]
        if let a = h.relativeAngle { parts[0] += " " + Recommender.angleName(a) }
        if let k = h.kite { parts.append("\(k.size.formatted()) m") }
        parts += h.flags
        return parts.joined(separator: " · ")
    }

    private var directionsButton: some View {
        Button {
            let item: MKMapItem
            if #available(iOS 26, *) {
                item = MKMapItem(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), address: nil)
            } else {
                item = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            }
            item.name = rec.spot.name
            item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        } label: {
            Label("Directions", systemImage: "car.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}

private struct Fact: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Label(title, systemImage: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value).font(.body.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
