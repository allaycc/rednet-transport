# allay-rednet-transport

Adds `rednet://` source support to [allay](https://github.com/alfaoz/allay).
After installing, you can add a rednet-hosted source:

    allay source add rednet://my-station

Then `allay install <package>` fetches over rednet from the host whose
label is `my-station`. The host runs [allay-server](https://github.com/alfaoz/allay-server).

## Install

    allay install allay-rednet-transport

Reboot afterwards so allay picks up the new transport.

## Wire protocol

Speaks the rednet protocol `allay-source`:

```
client -> host: { action = "get", path = "<file>" }
host -> client: { ok = true, content = "<file content>" }
host -> client: { ok = false, err = "<error message>" }
```

Used by both this transport and the allay-server reference implementation.

## License

MIT.
