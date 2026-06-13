# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.31-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.31-reF1nd/sing-box-1.14.0-alpha.31-reF1nd-darwin-arm64.tar.gz"
      sha256 "e46d8e3218f3a69f9da1cc5d73885e8bd3b8c0096f43e448868fa8661e82cb3a"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.31-reF1nd/sing-box-1.14.0-alpha.31-reF1nd-darwin-amd64.tar.gz"
      sha256 "cd7b0af6652ce1db4412c2cfa1d7c15b056dbe7eabe377bc26f0b7c0d53c07a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.31-reF1nd/sing-box-1.14.0-alpha.31-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "254420fc9195bccd6cd5f08a50eaff64e520b846f02bdf870549b3a9e62bbc03"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.31-reF1nd/sing-box-1.14.0-alpha.31-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "27a761a8060c130e6a1c65fde7fe1bfb984274731a201ddcd9de15ab41eacfdc"
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
