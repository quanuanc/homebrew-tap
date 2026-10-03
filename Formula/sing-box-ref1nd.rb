# This file is updated by .github/scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.15.0-alpha.9-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.9-reF1nd/sing-box-1.15.0-alpha.9-reF1nd-darwin-arm64.tar.gz"
      sha256 "648f058550ec38fac59910d8c364f5271d1c976946e44b4014ff38b3acd394a7"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.9-reF1nd/sing-box-1.15.0-alpha.9-reF1nd-darwin-amd64.tar.gz"
      sha256 "d980a35059d2b657f8c27d8d6a3da62bc874005a24c85c8645c2cdf11b5f66a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.9-reF1nd/sing-box-1.15.0-alpha.9-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "1a33e1562ed396532fce29dd591e4ad2c4f5c477c12f2e7e7a2e7f8fcc4ae501"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.9-reF1nd/sing-box-1.15.0-alpha.9-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "8bf9b2bc260f4b3f1d3a410cedcc73bc56ff7f3099f43828ec3d12f142c73c32"
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
