cask "dotnet-sdk5-0-400" do
  version "5.0.404,5.0.13"
  sha256 "19c0b93790fbc90ee39e11b9d304a91f1bc37468ab56076dba46b6e68b520385"

  url "https://download.visualstudio.microsoft.com/download/pr/8e682576-6d5e-4702-aed4-b7f77bb0dbc3/c7269d8dc54d73fbba942f38da843f60/dotnet-sdk-#{version.before_comma}-osx-x64.pkg"
  name ".NET Core SDK #{version.before_comma}"
  desc "This cask follows releases from https://github.com/dotnet/core/tree/master"
  homepage "https://www.microsoft.com/net/core#macos"

  livecheck do
    skip "See https://github.com/isen-ng/homebrew-dotnet-sdk-versions/blob/master/CONTRIBUTING.md#automatic-updates"
  end

  depends_on macos: "> :sierra"

  pkg "dotnet-sdk-#{version.before_comma}-osx-x64.pkg"

  postflight do
    FileUtils.ln_sf("/usr/local/share/dotnet/x64/dotnet", "#{HOMEBREW_PREFIX}/bin/dotnetx64") \
    unless Hardware::CPU.intel?
  end

  uninstall pkgutil: "com.microsoft.dotnet.dev.#{version.before_comma}.component.osx.x64"

  zap trash:   ["~/.dotnet", "~/.nuget", "/etc/paths.d/dotnet", "/etc/paths.d/dotnet-cli-tools"],
      pkgutil: [
        "com.microsoft.dotnet.hostfxr.#{version.after_comma}.component.osx.x64",
        "com.microsoft.dotnet.sharedframework.Microsoft.NETCore.App.#{version.after_comma}.component.osx.x64",
        "com.microsoft.dotnet.pack.apphost.#{version.after_comma}.component.osx.x64",
        "com.microsoft.dotnet.sharedhost.component.osx.x64",
      ]

  caveats "If you are installing this x64 binary on an Apple M1 (arm64) machine, the x64 version of `dotnet`"\
          "command will be symlinked as `dotnetx64`\n\n"\
          "Uninstalling the offical dotnet-sdk casks will remove the shared runtime dependencies, "\
          "so you\'ll need to reinstall the particular version cask you want from this tap again "\
          "for the `dotnet` command to work again."
end