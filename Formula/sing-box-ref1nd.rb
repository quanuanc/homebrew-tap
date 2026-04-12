# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.11-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.11-reF1nd/sing-box-1.14.0-alpha.11-reF1nd-darwin-arm64.tar.gz"
      sha256 "6342ab2cbbe9ad71ce8b9ab883bd39d7632a93d05dd2a2752afd9e147a2786bb"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.11-reF1nd/sing-box-1.14.0-alpha.11-reF1nd-darwin-amd64.tar.gz"
      sha256 "e714dc3acdc8e2ce3119d81f9fae8c0ca04480cb37e05251ef56fc341177dc57"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.11-reF1nd/sing-box-1.14.0-alpha.11-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "b3cd162ce26e56abdaadac4a7c7fcce4cdbb5afce464b23ed757730be91c13b1"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.11-reF1nd/sing-box-1.14.0-alpha.11-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "87af76faeccf0ec9643237ae4a8b1c09b14577a4f974bc0b105344d7286f6bb8"
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
