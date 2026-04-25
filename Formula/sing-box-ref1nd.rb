# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.18-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.18-reF1nd/sing-box-1.14.0-alpha.18-reF1nd-darwin-arm64.tar.gz"
      sha256 "a7e03f7c1cbc39d6a2d10d2efe6d1eaba77306b3c86531c2e1f231a16bcd6a6f"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.18-reF1nd/sing-box-1.14.0-alpha.18-reF1nd-darwin-amd64.tar.gz"
      sha256 "3ee0940a9937e42ef711b467809738636e9a1d862d7299b4c6493e0a4f2c2092"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.18-reF1nd/sing-box-1.14.0-alpha.18-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "92ba7b8f64b711590aa924ae80a85863d8059e5e6864e45a660379249e7c22fc"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.18-reF1nd/sing-box-1.14.0-alpha.18-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "6c7215edc092ea9dc78279c51aa7d0b2e230154bb974106a9d97fb57602923c1"
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
