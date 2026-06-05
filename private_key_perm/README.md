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

```powershell
cd "C:\Users\YourUsername\Documents\Key"
```
### or wherever your privatekey.ppk is located


### Fix the permissions (Recommended commands)
Best one-liner
```powershell
icacls "privatekey.ppk" /inheritance:r /grant:r "$env:USERNAME:F"
```

### Or step by step:
```powershell
icacls "privatekey.ppk" /inheritance:r
icacls "privatekey.ppk" /grant:r "$env:USERNAME:F"
```
