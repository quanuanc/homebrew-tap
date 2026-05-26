# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.26-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.26-reF1nd/sing-box-1.14.0-alpha.26-reF1nd-darwin-arm64.tar.gz"
      sha256 "b5b13328a5e21ebc770a3ef637a325fad2cb447872971f1f51dd43949bf815ba"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.26-reF1nd/sing-box-1.14.0-alpha.26-reF1nd-darwin-amd64.tar.gz"
      sha256 "4f0332c905f03916da0ac39984f7878a3a5100f1a3571416a8bb75a6d3483c37"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.26-reF1nd/sing-box-1.14.0-alpha.26-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "7bfbaf276f740cf5a615c02030b36461a303a164468246981ce7ec0dabce45bd"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.26-reF1nd/sing-box-1.14.0-alpha.26-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "13c0b37155fd5b22a5f32d8a4dfce82cabd12da2faa971e50d45f03dc311dd57"
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
