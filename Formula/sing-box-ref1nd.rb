# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.45-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.45-reF1nd/sing-box-1.14.0-alpha.45-reF1nd-darwin-arm64.tar.gz"
      sha256 "1f205155cd5a54191ee137dc1b4279e63d5cdd65cc0480fb7acf3d3a8bfd657b"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.45-reF1nd/sing-box-1.14.0-alpha.45-reF1nd-darwin-amd64.tar.gz"
      sha256 "92056ce95bd58ab8764c9728a9f692cde67c14dd298446ba866389735a33f8b2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.45-reF1nd/sing-box-1.14.0-alpha.45-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "b7f40d23bfdb3860edcb1cc65f2bec594e2d3f2dcbcdb1def5ff39f14c3a635a"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.45-reF1nd/sing-box-1.14.0-alpha.45-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "01cd7e994e3da2cbaf974aafaf78867e72c5bbb55e37c684fddb4220330275a9"
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
