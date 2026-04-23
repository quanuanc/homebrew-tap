# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.17-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.17-reF1nd/sing-box-1.14.0-alpha.17-reF1nd-darwin-arm64.tar.gz"
      sha256 "ff63b3cedd9a5a3403129a4d0829160cb05d32d8bc2c3e3842e5ba477cdccca1"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.17-reF1nd/sing-box-1.14.0-alpha.17-reF1nd-darwin-amd64.tar.gz"
      sha256 "242cd2081283b64ebaa448ab608d46b5af2337b9102b52e4ec1326ab933d1ecd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.17-reF1nd/sing-box-1.14.0-alpha.17-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "728d42fd43902fe60bb7ee5b9c23bef1463d5f86f4cbe1e704d32456e766881a"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.17-reF1nd/sing-box-1.14.0-alpha.17-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "50f0477aae847ae0ce8e6bfa1137a5f5f650f33536ccea2ec8c98e0aaeed9e42"
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
