# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.37-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.37-reF1nd/sing-box-1.14.0-alpha.37-reF1nd-darwin-arm64.tar.gz"
      sha256 "321b138e487f0c1b8cf9177bdc5c0932186e721b9e01684b5a8604978aa1ab98"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.37-reF1nd/sing-box-1.14.0-alpha.37-reF1nd-darwin-amd64.tar.gz"
      sha256 "0aeaa9680cdcb316e27a6f1b11c9046a9b7e4b35c5aae8e69ac66deb01e29d01"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.37-reF1nd/sing-box-1.14.0-alpha.37-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "bfb8357c76c362d8c826d923ffd8ba07827ba70ac172c56a5fd4752ddbe2997d"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.37-reF1nd/sing-box-1.14.0-alpha.37-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "a6d4f1bfaddcd601ce9cf52f99e8f2837d9c9f89bf9368714e7d7fdd3fd23daa"
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
