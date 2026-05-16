# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.24-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.24-reF1nd/sing-box-1.14.0-alpha.24-reF1nd-darwin-arm64.tar.gz"
      sha256 "eb5307df2acf41a4dd6694815da18f7eac9c61c550d2a96f9dea33cf65433cbc"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.24-reF1nd/sing-box-1.14.0-alpha.24-reF1nd-darwin-amd64.tar.gz"
      sha256 "094c491dfd22d8792ded3d60534cd663597ebc80dcd6700e358d06ab1b048be3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.24-reF1nd/sing-box-1.14.0-alpha.24-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "007551568652d9c38be1c53f3a69d3f19910914ee05bc3b2a7eadf4ba1ac3a67"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.24-reF1nd/sing-box-1.14.0-alpha.24-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "33c5ec5ff41966e3318f20edc1e4e70d2de9fe0e043b07e7ac80e74b4986098c"
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
