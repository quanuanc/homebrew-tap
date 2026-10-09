# This file is updated by .github/scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.15.0-alpha.11-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.11-reF1nd/sing-box-1.15.0-alpha.11-reF1nd-darwin-arm64.tar.gz"
      sha256 "7b502c038e0bd5459c81702e7b14be78037f27dfebd94f0ae45fd2d67fc13122"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.11-reF1nd/sing-box-1.15.0-alpha.11-reF1nd-darwin-amd64.tar.gz"
      sha256 "e4643d57f2ac05cca4a892c79c083df1cf7d54c9c06064114ce411cb53d91004"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.11-reF1nd/sing-box-1.15.0-alpha.11-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "4affe1df3ec83beb251dadf234cbed74e0d03d2c2683f6cfe4233d0893f7b824"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.11-reF1nd/sing-box-1.15.0-alpha.11-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "e22fa94f5e380600ed5b8865884b68c15d9336ad5bbab96765dbfac8c2050a15"
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
