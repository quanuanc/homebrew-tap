# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.12-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.12-reF1nd/sing-box-1.14.0-alpha.12-reF1nd-darwin-arm64.tar.gz"
      sha256 "99a0116a3a31239d52429751277829142ba30508aee7e36c610015d24c52369f"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.12-reF1nd/sing-box-1.14.0-alpha.12-reF1nd-darwin-amd64.tar.gz"
      sha256 "2e620a7f220fa47c217d87a81535c62ab6f4dd34a2dc81e6258a594d3466c275"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.12-reF1nd/sing-box-1.14.0-alpha.12-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "c3cb2308f849071c04f83107b91cd66397c2bbd9e4fc7e858b131ec9e7469354"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.12-reF1nd/sing-box-1.14.0-alpha.12-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "7b576d55627b7895506d7107c7250065acd7e00631a06d5a8dee5b2ca65284e0"
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
