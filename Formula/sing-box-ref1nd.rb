# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.50-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.50-reF1nd/sing-box-1.14.0-alpha.50-reF1nd-darwin-arm64.tar.gz"
      sha256 "b0f3fc0b1bd9c19f7f596845ef14d333c3b3b41db95ee04a6222cb4514b5f8f8"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.50-reF1nd/sing-box-1.14.0-alpha.50-reF1nd-darwin-amd64.tar.gz"
      sha256 "ae4951bde39b370e86a9977bb20847ee0944b9b4ed5f7b5d84b8db5afb9700d6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.50-reF1nd/sing-box-1.14.0-alpha.50-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "332ecf28047f0ce5fbb28582ecfbe5a61c9203b7f394bb3d9b813759e786e1fc"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.50-reF1nd/sing-box-1.14.0-alpha.50-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "fe3dc133f17116b0a0c5ac1939c57aa53cfe42d157fd352254a1524a3301c5eb"
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
