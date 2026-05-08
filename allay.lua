return {
  name = "allay-rednet-transport",
  version = "1.0.0",
  description = "rednet:// source transport for allay. Install on any computer that wants to fetch packages over rednet.",
  author = "alfa",
  license = "MIT",

  base_url = "https://raw.githubusercontent.com/alfaoz/allay-rednet-transport/main",

  files = {
    lib = {
      ["init.lua"] = "init.lua",
    },
  },
  hashes = {},

  -- This package's job is to install a transport file. The lib slot puts it
  -- on package.path; allay's core loads it on next startup.
  -- The cleaner approach (transport: kind) would use a custom kind. For now
  -- the user must restart allay (reboot) after installing.
  post_install_message = "Reboot to activate the rednet:// source transport.",
}
