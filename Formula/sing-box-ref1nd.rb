# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.32-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.32-reF1nd/sing-box-1.14.0-alpha.32-reF1nd-darwin-arm64.tar.gz"
      sha256 "28796b626965fceec6bd73c6b899dbc34592955a1d9bfbdaf299d0387365e5be"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.32-reF1nd/sing-box-1.14.0-alpha.32-reF1nd-darwin-amd64.tar.gz"
      sha256 "2a508286eacdad11a18fc5b0618bcd9393263eceda739fa18ebaaf62bb6219ff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.32-reF1nd/sing-box-1.14.0-alpha.32-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "45b7e549a2392debf1414a83536ceaf66855660886d648849523f2d36bdf4e19"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.32-reF1nd/sing-box-1.14.0-alpha.32-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "bbebd8f27a19521700e9209fb89cea39eaaaa6bb399c069e13fc4e5cec9b33bb"
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
