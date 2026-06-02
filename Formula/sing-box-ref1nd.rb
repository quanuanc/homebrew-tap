# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.28-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.28-reF1nd/sing-box-1.14.0-alpha.28-reF1nd-darwin-arm64.tar.gz"
      sha256 "16a68b4ad1062379330ec3dac76fc99bfab3971a2103f315fb3d04da55230538"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.28-reF1nd/sing-box-1.14.0-alpha.28-reF1nd-darwin-amd64.tar.gz"
      sha256 "ef8dbee55819c1a712394632c5764f5c649f95bbfb2fdabbc58df5ff40903598"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.28-reF1nd/sing-box-1.14.0-alpha.28-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "bc596b8e95bac9da6e5482796f54009dcf53b900b0fc2b5c849932fe3a2b8d22"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.28-reF1nd/sing-box-1.14.0-alpha.28-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "02b5484877a1a013561edf5700ff09dc73564b26ecb82da29a71960b0a518637"
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
