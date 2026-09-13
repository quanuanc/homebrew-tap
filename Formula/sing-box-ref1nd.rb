# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.15.0-alpha.3-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.3-reF1nd/sing-box-1.15.0-alpha.3-reF1nd-darwin-arm64.tar.gz"
      sha256 "dba42c71924f96926dd216ef327474dfa24c9ab08a77ef38f94188280967e367"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.3-reF1nd/sing-box-1.15.0-alpha.3-reF1nd-darwin-amd64.tar.gz"
      sha256 "2ec45ef4d30ce8910cb368c5d7150f4f8915ec5dae3c6c674e588a8587304fec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.3-reF1nd/sing-box-1.15.0-alpha.3-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "f9e5483a8e6fe2e4a311413282e620185421f44c4ddc64a52876c7f5accb5597"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.3-reF1nd/sing-box-1.15.0-alpha.3-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "86e0e295d7bd397447b769b1a4b34aedb32bd3a751ae597c7cbc628595d3aebf"
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
