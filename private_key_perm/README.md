# Fixing "Bad Permissions" on SSH Private Key (Windows + PuTTY)

A common issue when using PuTTY or OpenSSH on Windows where you see:

> WARNING: UNPROTECTED PRIVATE KEY FILE!  
> Bad permissions. Try removing permissions for user: UNKNOWN/...

This happens because your private key file (`.ppk` or `.pem`) has permissions that allow other users to read it.

---

### Problem

SSH clients (PuTTY, OpenSSH, etc.) refuse to use private keys that are readable by anyone other than the owner for security reasons.

---

### Solution (PowerShell)
1. Open PowerShell as Administrator
2. Navigate to your key folder

```powershell
cd "C:\Users\YourUsername\Documents\Key"
```
### or wherever your privatekey.ppk is located


## Fix the permissions (Recommended commands)
### Best one-liner
```powershell
icacls "privatekey.ppk" /inheritance:r /grant:r "$env:USERNAME:F"
```

### Or step by step:
```powershell
icacls "privatekey.ppk" /inheritance:r
icacls "privatekey.ppk" /grant:r "$env:USERNAME:F"
```
