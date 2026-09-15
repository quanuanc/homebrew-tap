# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.15.0-alpha.4-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.4-reF1nd/sing-box-1.15.0-alpha.4-reF1nd-darwin-arm64.tar.gz"
      sha256 "bf193df07906499811c790e91a205dbdd6c8a30a51b3bf03812d7b2e63e2c53c"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.4-reF1nd/sing-box-1.15.0-alpha.4-reF1nd-darwin-amd64.tar.gz"
      sha256 "c6bef582614ddb864bc0a404631870595e28d9d1181dffb61bb67a33ea217c3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.4-reF1nd/sing-box-1.15.0-alpha.4-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "51904b5c26b78d67bb516ddf3bdb131ecdafc1bfcf7c284c45d4f0ba9a346a89"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.4-reF1nd/sing-box-1.15.0-alpha.4-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "b3fc77ab7336aea9ae07543094b2a5fd084c980e93211d99433ed003fe9561c6"
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
