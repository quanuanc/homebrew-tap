# This file is updated by .github/scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.15.0-alpha.14-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.14-reF1nd/sing-box-1.15.0-alpha.14-reF1nd-darwin-arm64.tar.gz"
      sha256 "5e16320171aee9baa631c9c91498b2a9880800761e6843c5f94c2a424a042b69"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.14-reF1nd/sing-box-1.15.0-alpha.14-reF1nd-darwin-amd64.tar.gz"
      sha256 "06448e5d97c430dbddba1779ebcfb1ab330b490ee1dc2a18cba7f7a43f257c5e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.14-reF1nd/sing-box-1.15.0-alpha.14-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "61c6f04e804550e3bc7a853616d41540073d47dff69acc0328457b31a1235ca5"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.14-reF1nd/sing-box-1.15.0-alpha.14-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "81d9fcee07456b954bef80f3adfbb89342e1cc5ac8a6e6ae7d3574b832d12c6e"
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
