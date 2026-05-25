class TbAdmin < Formula
  desc "TokenBuddy seller operator administration CLI"
  homepage "https://github.com/zhouchangui/TokenBuddy"
  url "https://github.com/zhouchangui/TokenBuddy/releases/download/v0.1.5/tb-admin-0.1.5-aarch64-apple-darwin.tar.gz"
  sha256 "eeae0cf856b7858ccd003ee7294e50c871bc485c6189ae0b5ca4a96f328c2716"
  version "0.1.5"

  def install
    pkg = Dir["#{buildpath}/tb-admin-0.1.5-*"].first
    pkg = buildpath if pkg.nil?
    bin.install "#{pkg}/bin/tb-admin"
    prefix.install "#{pkg}/config" if File.directory?("#{pkg}/config")
  end

  def caveats
    <<~EOS
      The formula installs tb-admin into Homebrew's bin directory.
      If tb-admin is not on PATH, run:
        eval "$(brew shellenv)"

      Example config:
        #{opt_prefix}/config/tb-admin.example.toml

      Default config path:
        ~/.config/tokenbuddy/admin.toml
    EOS
  end

  test do
    system "#{bin}/tb-admin", "--help"
  end
end
