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
                hero
                facts
                chart
                hourly

                if let notes = rec.spot.notes {
                    Text(notes).font(.footnote).foregroundStyle(.secondary)
                }
                if rec.spot.directionCheck == "uncertain" || rec.spot.directionCheck == "disagrees" {
                    Label("The beach direction isn't confirmed by a second map yet, so on- and offshore may be off.",
                          systemImage: "exclamationmark.triangle")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(rec.spot.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) { directionsButton }
        .toolbar(.hidden, for: .tabBar)
    }

    // MARK: Hero: map with the verdict on top

    private var hero: some View {
        VStack(spacing: 0) {
            Map(initialPosition: .region(MKCoordinateRegion(
                center: coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000))) {
                Marker(rec.spot.name, systemImage: "wind", coordinate: coordinate)
                    .tint(ScoreStyle.color(rec.finalScore))
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .frame(height: 210)

            HStack(spacing: 14) {
                ScoreRing(score: rec.finalScore, lineWidth: 6)
                    .frame(width: 58, height: 58)
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(ScoreStyle.label(rec.finalScore)) · \(day.longLabel)")
                        .font(.title3.bold())
                    Text(rec.windSummary ?? rec.verdict)
                        .font(.subheadline)
                        .opacity(0.9)
                }
                Spacer(minLength: 0)
            }
            .foregroundStyle(.white)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ScoreStyle.gradient(rec.finalScore))
            .accessibilityElement(children: .combine)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var facts: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                Fact(title: "Best window", value: rec.windowLabel ?? "–", icon: "clock.fill", tint: .blue)
                Fact(title: "Kite", value: rec.suggestedKite.map { "\($0.size.formatted()) m" } ?? "–",
                     icon: "wind", tint: .teal)
            }
            GridRow {
                Fact(title: "Drive", value: rec.driveLabel, icon: "car.fill", tint: .indigo)
                Fact(title: rec.spot.allSides.count > 1 ? "Sides face" : "Beach faces",
                     value: (rec.spot.facingSummary ?? "Unknown")
                        + (rec.spot.waterSectorDeg.map { $0 < 360 ? " · \(Int($0))°" : "" } ?? ""),
                     icon: "water.waves", tint: .cyan)
            }
        }
    }

    // MARK: Chart

    private var chart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Wind vs your kite").font(.headline)
            Chart {
                if let k = rec.suggestedKite {
                    RectangleMark(yStart: .value("Min", k.minKn), yEnd: .value("Max", k.maxKn))
                        .foregroundStyle(ScoreStyle.color(80).opacity(0.14))
                        .annotation(position: .overlay, alignment: .topLeading) {
                            Text("\(k.size.formatted()) m range").font(.caption2.weight(.semibold))
                                .foregroundStyle(ScoreStyle.color(80))
                        }
                }
                ForEach(rec.hours, id: \.wind.localTime) { h in
                    BarMark(x: .value("Hour", h.wind.hour), y: .value("Wind", h.wind.speedKn), width: 18)
                        .foregroundStyle(ScoreStyle.gradient(Int((h.score * 100).rounded())))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
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
            .frame(height: 190)
            Text("Bars: average wind (kn), coloured by score · Dots: gusts")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .card()
    }

    private var yMax: Double {
        let peak = max(rec.hours.map(\.wind.gustKn).max() ?? 0, rec.suggestedKite?.maxKn ?? 0)
        return (peak / 5).rounded(.up) * 5 + 5
    }

    // MARK: Hourly

    private var hourly: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hour by hour").font(.headline)
            VStack(spacing: 0) {
                ForEach(Array(rec.hours.enumerated()), id: \.element.wind.localTime) { i, h in
                    HStack(spacing: 10) {
                        Text(String(format: "%02d:00", h.wind.hour))
                            .font(.subheadline.weight(.semibold))
                            .monospacedDigit()
                            .frame(width: 52, alignment: .leading)
                        WindArrow(directionDeg: h.wind.directionDeg)
                            .foregroundStyle(WindStyle.color(h.wind.speedKn))
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
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .accessibilityElement(children: .combine)
                    if i < rec.hours.count - 1 { Divider().padding(.leading, 14) }
                }
            }
            .card()
        }
    }

    private func hourDetail(_ h: HourScore) -> String {
        var parts = [Geo.compassName(h.wind.directionDeg)]
        if let a = h.relativeAngle { parts[0] += " " + Recommender.angleName(a) }
        if let side = h.side, h.score > 0 { parts.append(side) }
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
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
        .prominentButton()
        .controlSize(.large)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

private struct Fact: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(tint.gradient, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.subheadline.weight(.semibold)).lineLimit(1).minimumScaleFactor(0.8)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .card()
        .accessibilityElement(children: .combine)
    }
}
