# This file is updated by .github/scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.15.0-alpha.10-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.10-reF1nd/sing-box-1.15.0-alpha.10-reF1nd-darwin-arm64.tar.gz"
      sha256 "b76754db8aa66956298c477ff7691491f82297808f23e6ca2e2141de57b6b580"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.10-reF1nd/sing-box-1.15.0-alpha.10-reF1nd-darwin-amd64.tar.gz"
      sha256 "6cec51820733da0e3fa882d11669bdda69354a48369ea43720747bb76b8a69c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.10-reF1nd/sing-box-1.15.0-alpha.10-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "19adaf050df861107622677fbd9d833a7e83cb89268f25442c47ad023073d38f"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.10-reF1nd/sing-box-1.15.0-alpha.10-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "eb9dd25bf7ed73826c15980a5084fad9d0d962d0987a84f718beb705797e4683"
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
