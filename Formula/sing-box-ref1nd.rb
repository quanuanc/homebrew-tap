# This file is updated by .github/scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.15.0-alpha.13-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.13-reF1nd/sing-box-1.15.0-alpha.13-reF1nd-darwin-arm64.tar.gz"
      sha256 "54bb6a5634bd8b4c7d54c68204ceb70f2ed01d134d6905405e8b82368bc0545a"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.13-reF1nd/sing-box-1.15.0-alpha.13-reF1nd-darwin-amd64.tar.gz"
      sha256 "65f564e09bff803306ab89ea6ec4cbcc5943fdaf540474fd559b539c49f8db2e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.13-reF1nd/sing-box-1.15.0-alpha.13-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "8f8daef82a927f2373ce55f678f604ba6e3ef6a57572a6d2776e937614a8c1f4"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.13-reF1nd/sing-box-1.15.0-alpha.13-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "44f37b90d208fbfb981e197edbf60401a93d718b9e0a719889e42eb5c5129945"
    end
  end

  conflicts_with "sing-box", because: "both install a sing-box binary"

  def install
    binary = Dir["**/sing-box"].find { |path| File.file?(path) && File.executable?(path) }
    odie "sing-box binary not found in release archive" if binary.nil?

    bin.install binary => "sing-box"

    license_file = Dir["**/LICENSE"].find { |path| File.file?(path) }
    doc.install license_file if license_file
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
    run_type :immediate
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box version")
  end
end
