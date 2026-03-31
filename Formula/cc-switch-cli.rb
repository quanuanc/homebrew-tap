class CcSwitchCli < Formula
  desc "A cross-platform CLI All-in-One assistant tool for Claude Code, Codex & Gemini CLI"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  version "5.2.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/SaladDay/cc-switch-cli/releases/download/v5.2.1/cc-switch-cli-darwin-arm64.tar.gz"
      sha256 "fd065a4b81fabd4ce7b7077bcc932aef194af02604c51ea8097c0eda7ca77985"

      def install
        bin.install "cc-switch" => "cc-switch"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/SaladDay/cc-switch-cli/releases/download/v5.2.1/cc-switch-cli-darwin-x64.tar.gz"
      sha256 "02d04589c92fb5b65856f93696c80ff4f5aef6cada356e0751fd395bb169ab61"

      def install
        bin.install "cc-switch" => "cc-switch"
      end
    end
  end

  def post_install
    # Remove quarantine attribute from the binary
    chmod "+x", bin/"cc-switch"
    system_command "/usr/bin/xattr",
                   args: ["-cr", bin/"cc-switch"],
                   sudo: false
  end

  def caveats
    <<~EOS
      cc-switch has been installed!

      To get started, run:
        cc-switch --help

      Learn more at: https://github.com/SaladDay/cc-switch-cli
    EOS
  end

  test do
    system "#{bin}/cc-switch", "--version"
  end
end
