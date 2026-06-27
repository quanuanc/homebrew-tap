# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.36-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.36-reF1nd/sing-box-1.14.0-alpha.36-reF1nd-darwin-arm64.tar.gz"
      sha256 "fd003a39ec075679923b44ed3aec94b0631d63e81254a5fa5681e6f1b82c7bb7"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.36-reF1nd/sing-box-1.14.0-alpha.36-reF1nd-darwin-amd64.tar.gz"
      sha256 "5ffde404996aa3cf8305dcaf7372b5579460a48cc1e0e59bcd2428e950a3aa48"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.36-reF1nd/sing-box-1.14.0-alpha.36-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "0fc6561c9d423b524addcec0b412f26e3005159e567325a964727a64fc178a49"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.36-reF1nd/sing-box-1.14.0-alpha.36-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "7371e6fe5ef832c19eb854654e1905be2f97b0f29a4662faef671139143efc86"
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
