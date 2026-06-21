# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.33-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.33-reF1nd/sing-box-1.14.0-alpha.33-reF1nd-darwin-arm64.tar.gz"
      sha256 "dd18d8c78eea9a9b3e29086b3fc11e49f1faa7b1ec92a8710089524c47ba0a57"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.33-reF1nd/sing-box-1.14.0-alpha.33-reF1nd-darwin-amd64.tar.gz"
      sha256 "d6884b14624cf82085792e393f0559511c86dde9ca708aa3a8de0d0fd0b32f79"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.33-reF1nd/sing-box-1.14.0-alpha.33-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "624b0ed48b6d26b1bb37420888a7beeaaa0df6ebefe13b9a537f7ebbc4d5eef8"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.33-reF1nd/sing-box-1.14.0-alpha.33-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "b6249e0df6966d0abed77fe1b1928c0677888528cf8e44d948f8118af3824e4f"
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
