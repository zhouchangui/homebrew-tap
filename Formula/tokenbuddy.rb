class Tokenbuddy < Formula
  desc "TokenBuddy buyer CLI and local proxy daemon"
  homepage "https://github.com/zhouchangui/TokenBuddy"
  url "https://raw.githubusercontent.com/zhouchangui/homebrew-tap/main/dist/tokenbuddy-0.1.1-aarch64-apple-darwin.tar.gz"
  sha256 "09edddc51e6b77297fe5625d46cac27121a6996657d7bc05870da238b82069f1"
  version "0.1.1"

  def install
    pkg = Dir["#{buildpath}/tokenbuddy-0.1.1-*"].first
    pkg = buildpath if pkg.nil?
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
        eval "export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
export FPATH;
eval "$(/usr/bin/env PATH_HELPER_ROOT="/opt/homebrew" /usr/libexec/path_helper -s)"
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";"

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
