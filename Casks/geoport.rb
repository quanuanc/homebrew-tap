cask "geoport" do
  version "4.0.2"
  sha256 "f27ffd28d9c8cfd0afa56190cd67e6aa4b9a119b1903cedea25c8111a8e9cded"

  url "https://github.com/davesc63/GeoPort/releases/download/v#{version}/GeoPort-arm-v#{version}.dmg"
  name "GeoPort"
  desc "GeoPort: Your Location, Anywhere! The iOS location simulator"
  homepage "https://github.com/davesc63/GeoPort"

  app "GeoPort-mac.app"

  uninstall quit: "org.davesc63.GeoPort"

end
