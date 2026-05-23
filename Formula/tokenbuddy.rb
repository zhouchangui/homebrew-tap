class Tokenbuddy < Formula
  desc "TokenBuddy buyer CLI and local proxy daemon"
  homepage "https://github.com/zhouchangui/TokenBuddy"
  url "https://raw.githubusercontent.com/zhouchangui/homebrew-tap/main/dist/tokenbuddy-0.1.1-aarch64-apple-darwin.tar.gz"
  sha256 "81e0702b1e78f1bb9f94cc0b192d6a4a7b2ee3aca2d719cc74d93a10685f183a"
  version "0.1.1"

  def install
    pkg = Dir["#{buildpath}/tokenbuddy-0.1.1-*"].first
    bin.install "#{pkg}/bin/tb"
    bin.install "#{pkg}/bin/tb-proxyd"
    prefix.install "#{pkg}/config"
  end

  service do
    run [opt_bin/"tb-proxyd", "--bind-addr", "127.0.0.1:17820"]
    keep_alive true
    working_dir var
    log_path var/"log/tokenbuddy/tb-proxyd.log"
    error_log_path var/"log/tokenbuddy/tb-proxyd.log"
    environment_variables PATH: std_service_path_env
  end

  def post_install
    (var/"log/tokenbuddy").mkpath
    system "brew", "services", "restart", name if OS.mac?
  rescue
    opoo "tb-proxyd service was installed but not started. Run: brew services start #{name}"
  end

  def caveats
    <<~EOS
      The formula installs tb and tb-proxyd into Homebrew's bin directory.
      If tb is not on PATH, run:
        eval "$(brew shellenv)"

      tb-proxyd is configured as a Homebrew service:
        brew services start #{name}
        brew services restart #{name}
        brew services stop #{name}
    EOS
  end

  test do
    system "#{bin}/tb", "--help"
    system "#{bin}/tb-proxyd", "--help"
  end
end
