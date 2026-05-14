# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.23-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.23-reF1nd/sing-box-1.14.0-alpha.23-reF1nd-darwin-arm64.tar.gz"
      sha256 "801b9dad0e9aa84b6f97f33e330f6afadc5abc9d8777c52692f47803046e04a7"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.23-reF1nd/sing-box-1.14.0-alpha.23-reF1nd-darwin-amd64.tar.gz"
      sha256 "479206462fa4c62e61aa985c1beb4e270b2e095b092f1f333d8c96fe9969e90e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.23-reF1nd/sing-box-1.14.0-alpha.23-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "aa2fe6e304b0dd1afe32b1a907fbce9d4d4481a2b7e6617e6b2c2154de1d7772"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.23-reF1nd/sing-box-1.14.0-alpha.23-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "72c30a0e9f3e9b12ddba207fffdbf64d87103cb4d30606a9fb8af064f0a65566"
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
