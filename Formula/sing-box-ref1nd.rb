# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.16-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.16-reF1nd/sing-box-1.14.0-alpha.16-reF1nd-darwin-arm64.tar.gz"
      sha256 "ee1bdc429f4f0a7f0f867a51af6f43e4965ba1e80c7f86e50dc8583b7e708860"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.16-reF1nd/sing-box-1.14.0-alpha.16-reF1nd-darwin-amd64.tar.gz"
      sha256 "05ad265170063792a16eef6b68d225d46bf3f7bccc073f913a8b65dbd5fb6512"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.16-reF1nd/sing-box-1.14.0-alpha.16-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "c2de80fc2b67f53c7ad5e7d896c33515c341f67871133e6850cbeffd9e357f72"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.16-reF1nd/sing-box-1.14.0-alpha.16-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "bb4c5691eaf9419e2a33e2c2db1e477955a2984a8807bf40e7bfc7915767a2f5"
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
