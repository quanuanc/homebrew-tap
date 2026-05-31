# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.27-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.27-reF1nd/sing-box-1.14.0-alpha.27-reF1nd-darwin-arm64.tar.gz"
      sha256 "0525b8634129b70715b5c7b4447e2756b48f1785efffaee80c2f710d9613a84c"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.27-reF1nd/sing-box-1.14.0-alpha.27-reF1nd-darwin-amd64.tar.gz"
      sha256 "a7ed9a78ab7ae7e80cd9a5bf7a31b8a00e4e929010b6ac1865362a0482f4dbca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.27-reF1nd/sing-box-1.14.0-alpha.27-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "b264311959df8f98b309f50a4307d90cd7faa22ad492622f2535a55066fa09e9"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.27-reF1nd/sing-box-1.14.0-alpha.27-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "08cb8e62d6836cbe8607fddf80069d1a3b735a688781585d74824bd2b16599ce"
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
