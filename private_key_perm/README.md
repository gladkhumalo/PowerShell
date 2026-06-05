# Fixing "Bad Permissions" on SSH Private Key (Windows + PuTTY)

A common issue when using PuTTY, OpenSSH, or other SSH clients on Windows is receiving an error like:

> WARNING: UNPROTECTED PRIVATE KEY FILE!  
> Bad permissions. Try removing permissions for user: UNKNOWN/...

This happens because your private key file (`.ppk` or `.pem`) has permissions that allow other users to read it.

---

## Why This Happens
SSH clients enforce strict security requirements for private keys.

If Windows permissions allow other users or groups to read the file, SSH will refuse to use the key and display a permissions error.

---

### Solution
1. Open PowerShell as Administrator
Search for PowerShell, right-click it, and select:
```
Run as Administrator
```

2. Navigate to the Key Location
Example:
```powershell
cd "C:\Users\YourUsername\Documents\Keys"
```


Replace the path with the location of your private key.
