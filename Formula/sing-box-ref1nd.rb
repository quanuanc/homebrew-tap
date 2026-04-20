# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.15-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.15-reF1nd/sing-box-1.14.0-alpha.15-reF1nd-darwin-arm64.tar.gz"
      sha256 "562ea19c23159af2f594f53fab338884eb9650a32c954d79ba5b4a8b31a51984"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.15-reF1nd/sing-box-1.14.0-alpha.15-reF1nd-darwin-amd64.tar.gz"
      sha256 "2364ad87af74de5dc187444aa4cf4e31a9f775699a38e3c9d27bbc43dfc25de4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.15-reF1nd/sing-box-1.14.0-alpha.15-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "2dccf59dea787eb679ae3d376a24cbf9b261a1a42ef4e7cc4ddff4f9312cb4c0"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.15-reF1nd/sing-box-1.14.0-alpha.15-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "b5cbe301db07ed93096b9960da490e6207579fcb7129832ad9542f99a7be39e7"
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
