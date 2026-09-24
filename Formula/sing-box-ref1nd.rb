# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.15.0-alpha.8-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.8-reF1nd/sing-box-1.15.0-alpha.8-reF1nd-darwin-arm64.tar.gz"
      sha256 "6165e921d338b2bac76640239abdf8c31159e0c8e9853547c87c8248d184cef6"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.8-reF1nd/sing-box-1.15.0-alpha.8-reF1nd-darwin-amd64.tar.gz"
      sha256 "a950b5ef15fd0912a27edecaf2ad8259bab523e42935d1328098ae597ea87d21"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.8-reF1nd/sing-box-1.15.0-alpha.8-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "fd3bdc52642e6ebea45c157835d01874f38efb6651789764805cc9fcfec0eb29"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.8-reF1nd/sing-box-1.15.0-alpha.8-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "a08752135b7ed15014a571ef97c604762625ebe4b5407866ce5b129872440b95"
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
