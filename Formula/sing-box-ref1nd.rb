# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.20-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.20-reF1nd/sing-box-1.14.0-alpha.20-reF1nd-darwin-arm64.tar.gz"
      sha256 "41f4798d5a18dbb11d11f4e831c0774c731933bcbb7dea9116318a9135eb0f95"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.20-reF1nd/sing-box-1.14.0-alpha.20-reF1nd-darwin-amd64.tar.gz"
      sha256 "11051396e0cab90aff7808c3e1633ba6a3f0d87d486f5cbfeb74809a78d6e20a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.20-reF1nd/sing-box-1.14.0-alpha.20-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "f0d78a03b007f2e438a50c26f58ba6265d07ecd405eb058ed638cf5120b9a5a9"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.20-reF1nd/sing-box-1.14.0-alpha.20-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "33479365f70dbef51e2b355520fef2119371799c17def077563dc623f3a165a5"
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
