# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.30-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.30-reF1nd/sing-box-1.14.0-alpha.30-reF1nd-darwin-arm64.tar.gz"
      sha256 "7d42a97ec7d9de81a46fbbaf628530cc3162a892c9c41ad7162b378682982c70"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.30-reF1nd/sing-box-1.14.0-alpha.30-reF1nd-darwin-amd64.tar.gz"
      sha256 "400e8a4a3d0889fd625b897d46f1c62d3fea2758ae6a5c56453d59469b200731"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.30-reF1nd/sing-box-1.14.0-alpha.30-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "15df0e1f7e795b44f036844378f02eb329a6549e8ac3cd331bcdbb8c779c38a3"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.30-reF1nd/sing-box-1.14.0-alpha.30-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "6ec83883af5ebc078968a170e307d27cffecd2ff2fa99f90e03995c5b4ccfe93"
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
