# This file is updated by scripts/update-sing-box-ref1nd.rb.
class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd build)"
  homepage "https://github.com/reF1nd/sing-box-releases"
  version "1.14.0-alpha.14-reF1nd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/reF1nd/sing-box-releases/releases"
    regex(/^v?(\d+(?:\.\d+)+-alpha\.\d+-reF1nd)$/i)
    strategy :github_releases
  end

  on_macos do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.14-reF1nd/sing-box-1.14.0-alpha.14-reF1nd-darwin-arm64.tar.gz"
      sha256 "46c6d9b1a78068bac8ec52e8e4db2bb6c2dc43ebc4c33c3cd9996be3aa70529a"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.14-reF1nd/sing-box-1.14.0-alpha.14-reF1nd-darwin-amd64.tar.gz"
      sha256 "59819d3a2a91cc4c817b3e69a82927ee490317859a0fdf4609ed0fe31b3aa5f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.14-reF1nd/sing-box-1.14.0-alpha.14-reF1nd-linux-arm64-glibc.tar.gz"
      sha256 "a245594cd1c60cddc39c72c86756035a04b8998ab0411049678a0d843d689095"
    end

    on_intel do
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.14-reF1nd/sing-box-1.14.0-alpha.14-reF1nd-linux-amd64-glibc.tar.gz"
      sha256 "725111e515dabbc5da813a86854ed3889816b01e49a76dfe8f88063557aae8f8"
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
