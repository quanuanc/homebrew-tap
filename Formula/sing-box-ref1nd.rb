# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.43-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.43-reF1nd/sing-box-1.14.0-alpha.43-reF1nd-darwin-arm64.tar.gz"
      sha256 "8126c6324b0f5e543b64de9a34cadd6cf673837949b97cdd867565bbd715afc1"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.43-reF1nd/sing-box-1.14.0-alpha.43-reF1nd-darwin-amd64.tar.gz"
      sha256 "0acf13935fc7967e876036160ef5da79d04178d6ac98b275c764f01932507686"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.43-reF1nd/sing-box-1.14.0-alpha.43-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "8fb62e8c10ba3dab13d20e7d37362f8d7599dac72a9ba340cbdbede9d28e7a02"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.43-reF1nd/sing-box-1.14.0-alpha.43-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "50104d0aa84e95ff5a7f779c3aa3370c75d721de97d6c5dfb80a9f8c2170b2ec"
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
