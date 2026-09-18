# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.15.0-alpha.6-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.6-reF1nd/sing-box-1.15.0-alpha.6-reF1nd-darwin-arm64.tar.gz"
      sha256 "171421c6ded04a11c01641d9828330ca9fabbd5d882fa120a925926e8615f726"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.6-reF1nd/sing-box-1.15.0-alpha.6-reF1nd-darwin-amd64.tar.gz"
      sha256 "a48d9ef83f03cf0d322a848f8a016e2740998d6fa284928e5272d931830c7ec3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.6-reF1nd/sing-box-1.15.0-alpha.6-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "aa683673cde38f322228f7aad9afc2120ef91cc80a69b30fec987f35366132a8"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.6-reF1nd/sing-box-1.15.0-alpha.6-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "1a507f422485e4b6924cc451d7d8d671135d59ea762aa93b822000644484f35e"
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
