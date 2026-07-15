# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.44-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.44-reF1nd/sing-box-1.14.0-alpha.44-reF1nd-darwin-arm64.tar.gz"
      sha256 "0a0a50ceb3b1b129b91230da6c74bfbd67cd97074b962fa77f657afc16207bb8"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.44-reF1nd/sing-box-1.14.0-alpha.44-reF1nd-darwin-amd64.tar.gz"
      sha256 "056a9b2fde496da2e67f4aed42c9c3895da4d94fa165149170ce003824c0e908"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.44-reF1nd/sing-box-1.14.0-alpha.44-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "e23689907f20f03b5fa8f954eca05225977f6c1b7216e4b61c39c7e3d33f1b4e"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.44-reF1nd/sing-box-1.14.0-alpha.44-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "085e08a5aaf5fd22b3b7bdb1aca02ab559502e1b1ac5e2f8a49737a300aa540f"
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
