# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.29-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.29-reF1nd/sing-box-1.14.0-alpha.29-reF1nd-darwin-arm64.tar.gz"
      sha256 "8ca4425644c9403b963414073ca38176a073ecc31a1d2ea6fc5641e626a59606"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.29-reF1nd/sing-box-1.14.0-alpha.29-reF1nd-darwin-amd64.tar.gz"
      sha256 "1bf98e67819f9687b8e4f9e6cf275b68b3d3a71432bf696f74bb890372aaf06a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.29-reF1nd/sing-box-1.14.0-alpha.29-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "0a63b87733349892f7a2546c6c68f29d52fb8a3ea21c819f61a461bcc4278a60"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.29-reF1nd/sing-box-1.14.0-alpha.29-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "59c61beeff50f9874ca026ab9f1c7994243814c90a3c67ff5a9b0618ed1b1cf5"
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
