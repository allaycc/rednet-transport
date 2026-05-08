-- allay-rednet-transport: rednet:// transport for allay.
--
-- After installing this package, sources can be added with rednet:// URLs:
--   allay source add rednet://my-station
--
-- Talks to allay-server (or any compatible rednet host) over CC's rednet.

local M = {}

local PROTOCOL = "allay-source"
local DEFAULT_TIMEOUT = 5

local function find_modem()
  if not _G.peripheral then return nil end
  for _, side in ipairs(_G.peripheral.getNames()) do
    if _G.peripheral.getType(side) == "modem"
       and _G.peripheral.call(side, "isWireless") then
      return side
    end
  end
  return nil
end

local function ensure_modem()
  if not _G.rednet then return false, "rednet API not available" end
  if not _G.rednet.isOpen() then
    local side = find_modem()
    if not side then return false, "no wireless modem attached" end
    _G.rednet.open(side)
  end
  return true
end

function M.fetch(url)
  local rest = url:match("^rednet://(.+)$")
  if not rest then
    return nil, "rednet: malformed url: " .. url
  end

  local station, path = rest:match("^([^/]+)/(.*)$")
  if not station then
    -- Allow rednet://<station> to map to the index.
    station = rest
    path = "index.lua"
  end

  local ok, err = ensure_modem()
  if not ok then return nil, err end

  local id = _G.rednet.lookup(PROTOCOL, station)
  if not id then return nil, "rednet: no host found: " .. station end

  _G.rednet.send(id, { action = "get", path = path }, PROTOCOL)
  local sender, msg = _G.rednet.receive(PROTOCOL, DEFAULT_TIMEOUT)
  if not sender then return nil, "rednet: timeout from " .. station end
  if type(msg) ~= "table" or not msg.ok then
    return nil, "rednet: " .. (msg and msg.err or "no response")
  end
  return msg.content
end

-- This file is loaded by allay's bootstrap as a translator/provider extension.
-- When it's installed under /usr/allay/transports/, allay's transport module
-- picks it up and registers the rednet:// scheme automatically.
return M
