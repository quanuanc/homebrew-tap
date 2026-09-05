# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.15.0-alpha.2-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.2-reF1nd/sing-box-1.15.0-alpha.2-reF1nd-darwin-arm64.tar.gz"
      sha256 "c4ff3b87a1090882ae3373b46e030dde1f7b3a99adc86ed9e30110a0841018dc"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.2-reF1nd/sing-box-1.15.0-alpha.2-reF1nd-darwin-amd64.tar.gz"
      sha256 "b7ebdb1a0f5a7565fd1b97c09039e29681ddeaf66380ed33a907c455abae3044"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.2-reF1nd/sing-box-1.15.0-alpha.2-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "b0af4f03023f8c79dc451b58ddb81251f665a4bb6808fd536e9b188a47a87fa3"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.2-reF1nd/sing-box-1.15.0-alpha.2-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "e03ea06d05e6ad3faa30b1905035cb6630a138b318e75442db626097a627d945"
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
