# Homebrew cask for the Sticky Mac app. Published copy: amansriven/homebrew-tap,
# Casks/sticky-app.rb. On release: set `version` and `sha256` from the output of
# app/release.sh, and upload the zip to the GitHub release.
#
# The app isn't signed with a Developer ID yet, so the url points at the
# "-unsigned" zip and the caveats explain Gatekeeper's one-time "Open Anyway".
# Once it's notarized: drop "-unsigned" from the url and the Gatekeeper caveat.
cask "sticky-app" do
  version "0.3.0"
  sha256 "a9ed4d91b74f7d1b62a1f26e845f8fcc92c1714c6df7c999c05c5cc262a00219"

  url "https://github.com/amansriven/Sticky/releases/download/v#{version}/Sticky-#{version}-unsigned.zip"
  name "Sticky"
  desc "Explains why apps keep asking for permissions, and how to make them stick"
  homepage "https://github.com/amansriven/Sticky"

  depends_on formula: "amansriven/tap/sticky"
  depends_on macos: ">= :sonoma"

  app "Sticky.app"

  postflight do
    # Start the background recorder so Sticky has something to explain.
    system_command "#{HOMEBREW_PREFIX}/bin/sticky", args: ["install-agent"], must_succeed: false
  end

  uninstall quit: "dev.sticky.bar"

  zap trash: [
    "~/Library/Application Support/Sticky",
    "~/Library/Logs/Sticky",
    "~/Library/Preferences/dev.sticky.bar.plist",
  ]

  caveats <<~EOS
    Sticky's background recorder is running.

    Sticky isn't notarized by Apple yet, so the first time you open it macOS
    says it can't check it for malicious software. To open it once:
      1. Open Sticky from Applications and click Done.
      2. In System Settings → Privacy & Security, click "Open Anyway" next to
         the message about Sticky, then confirm.
    After that it opens normally. The source is at
    https://github.com/amansriven/Sticky if you'd rather build it yourself.

    To stop recording: sticky uninstall-agent
  EOS
end
