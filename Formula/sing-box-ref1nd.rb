# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.21-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.21-reF1nd/sing-box-1.14.0-alpha.21-reF1nd-darwin-arm64.tar.gz"
      sha256 "f1d5acf316c079b7021d4b7bc561211a75909652ff592951d5b0891a4935b96d"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.21-reF1nd/sing-box-1.14.0-alpha.21-reF1nd-darwin-amd64.tar.gz"
      sha256 "0bfc5111f58e12efa74fa00ca4cb0c9874d13c3b09e9f2dbbc5ab589e9bb5b76"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.21-reF1nd/sing-box-1.14.0-alpha.21-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "c5a6e314c2f93fb74876786f73b3d0a2508bfade2933941fd8e8e483fb1eaad1"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.21-reF1nd/sing-box-1.14.0-alpha.21-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "3e2c22e33824ed5ca258837fd7da2191668a5140bfe02b5ed29607490177fb5e"
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
