# PowerShell script to backup VMware or Hyper-V Environments using Veeam Backup and Replication
# The PowerShell extension for this is included by default in version 9.0

###### Modify these variables to fit your environment #####
$target = "192.168.1.100" # vCenter, ESXi or Hyper-V IP Address
$account = "domain\username" # Account with full permissions for $target and $dest
$VMs = "UBUDEV" # VM name, only one VM per VeeamZip in the free edition
$dest = "\\path\to\network\share" # UNC path for backups 
$retention = "In2Weeks"  #Retention time: Never, Tonight, In2days, In2Weeks, In1Month
# Add -DisableQuiesce after the $vm variable in the Start-VBRZip command if you have issues
#############################################################

# Add the Veeam Backup and Replication Snap-in
Add-PSSnapin VeeamPSSnapin

# Disconnect from Veeam Backup and Replication server in case it is already connected
Disconnect-VBRServer

# Connect to the Veeam Backup and Replication server (localhost)
Connect-VBRServer

# Set server equal to the VMware or Hyper-V Server
$server = Get-VBRServer -Name $target

# Get credentials we specified in Veeam GUI
$creds = Get-VBRCredentials -Name $account

# Entity which we are backing up, contains server and VM names
# Find-VBRViEntity (for VMware) or Find-VBRHvEntity (for Hyper-V)
$vm = Find-VBRViEntity -Server $server -Name $VMs

# Encryption key added in Veeam GUI
$key = Get-VBREncryptionKey

# Start VeeamZip job
Start-VBRZip -Folder $dest -Entity $vm -EncryptionKey $key -AutoDelete $retention -RunAsync

# If you want to use a local path instead:
# Start-VBRZip -Folder "C:\Backup" -Entity $vm $vm -EncryptionKey $key -AutoDelete $retention -RunAsync

# Take a nap
Sleep 5

# Disconnect once job is submitted
Disconnect-VBRServer