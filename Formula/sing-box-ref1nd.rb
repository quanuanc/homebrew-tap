# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.46-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.46-reF1nd/sing-box-1.14.0-alpha.46-reF1nd-darwin-arm64.tar.gz"
      sha256 "ae6cbf9a908fb820df83e41edfdbc3263daf30eea3d44b5ad345649200085c80"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.46-reF1nd/sing-box-1.14.0-alpha.46-reF1nd-darwin-amd64.tar.gz"
      sha256 "eeaea00131f73fe581d11a06dd08192968117edd017e753d76eb90ccd392b3b2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.46-reF1nd/sing-box-1.14.0-alpha.46-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "d26067dd5531e692fe7f441291414890ff280e4cb1d3daec12d8383b7553532a"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.46-reF1nd/sing-box-1.14.0-alpha.46-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "6de658849e140218aed7f63a536fbcb0a9528f3f8eaae0b33a5519e13391b936"
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
