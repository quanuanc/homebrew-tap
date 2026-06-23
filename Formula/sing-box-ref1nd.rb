# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.34-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.34-reF1nd/sing-box-1.14.0-alpha.34-reF1nd-darwin-arm64.tar.gz"
      sha256 "23c09fa054a43a1b772357d1dd4096313521289892c172765da985cfaeb92c25"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.34-reF1nd/sing-box-1.14.0-alpha.34-reF1nd-darwin-amd64.tar.gz"
      sha256 "2af26180e9695ccfefe093818ff2322dc1c81207000dfffb4d0e7847f9d277d3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.34-reF1nd/sing-box-1.14.0-alpha.34-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "afa6fa20ea8c7daad5e4cfd83e0e58fe4b1daf7c6f3bd8cc3d6b464415c3d9ea"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.34-reF1nd/sing-box-1.14.0-alpha.34-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "b9e403de315d12c300c5f9b45a284a3e82c49a842061bd03e0aebb5957589cc8"
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
