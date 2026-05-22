# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.25-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.25-reF1nd/sing-box-1.14.0-alpha.25-reF1nd-darwin-arm64.tar.gz"
      sha256 "e7a4a79cb32b5acf7e4397c94c3c439b651ee1a8f1b7477757e2a179a401dfa8"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.25-reF1nd/sing-box-1.14.0-alpha.25-reF1nd-darwin-amd64.tar.gz"
      sha256 "3ab7764531d81c87cd9755ce5819a331e0c527c9b021b9358c2ed6f19ee26526"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.25-reF1nd/sing-box-1.14.0-alpha.25-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "ffba145ccdb88772ae8d65a593f94adf9d6003f498abfce1ce4cba06e6da7092"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.25-reF1nd/sing-box-1.14.0-alpha.25-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "425b79b73951363db2915220174de992e81723ef286f91fbea63c602bc2adabc"
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
