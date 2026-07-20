# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.48-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.48-reF1nd/sing-box-1.14.0-alpha.48-reF1nd-darwin-arm64.tar.gz"
      sha256 "5251ed0b88540ab432604f06a70e0fdfab79e169fdd6ae84b5aa384515504156"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.48-reF1nd/sing-box-1.14.0-alpha.48-reF1nd-darwin-amd64.tar.gz"
      sha256 "91b487ec38222fbc708990f965c010cff039c172772054d09339614a9d8a13b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.48-reF1nd/sing-box-1.14.0-alpha.48-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "045d9a44014782b218330e2b09e40b911695491d380ad471226cd07128c704a1"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.48-reF1nd/sing-box-1.14.0-alpha.48-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "75157b6160f40716cf609cb2127b006b0e4235ecd993ce2c392782da9980227b"
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
