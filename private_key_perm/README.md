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
<br>

2. Navigate to the Key Location
Example:
```powershell
  cd "C:\Users\YourUsername\Documents\Keys"
```
Replace the path with the location of your private key.

<br>

3. Remove Inherited Permissions
```powershell
  icacls "privatekey.ppk" /inheritance:r
```
This removes inherited permissions from the file.

<br>

4. Grant Full Control to the Current User
```powershell
  icacls "privatekey.ppk" /grant:r "$env:COMPUTERNAME\$env:USERNAME:F"
```
This grants full control to the file owner only.

<br>

### Recommended One-Liner
Run the following command to perform both actions at once:
```powershell  
  icacls "privatekey.ppk" /inheritance:r /grant:r "$env:COMPUTERNAME\$env:USERNAME:F"
```

## Verify Permissions
To view the current permissions:
```powershell
  icacls "privatekey.ppk"
```
You should see only your user account listed with Full Control permissions.

<br>

Result
After updating the file permissions:
- PuTTY accepts the key
- OpenSSH accepts the key
- Security warning disappears
- SSH authentication works normally

---
