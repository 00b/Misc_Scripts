#Removes users that are in group1 if they are in group 2.  
#change saftey to "Off" to make the changes. Otherwise it will only put who would be removed.  
$saftey = "On"

$group1Name = "Group1" #users will be removed form this group if they are also in $group2Name
$group2Name = "GroupB"

$group1Members = Get-ADGroupMember -Identity $group1Name
$Group1users = $group1Members | Select-Object -ExpandProperty SamAccountName
$group2Members = Get-ADGroupMember -Identity $group2Name
$Group2users = $group2Members | Select-Object -ExpandProperty SamAccountName
$count=0
 foreach ($user in $Group1users) {
    #Write-Host "User: $user"
    if ($Group2users -contains $user) {
        $count++
        if ($saftey -match "On") {
        Write-Host "$user would be removed from $group1name"
        }
        if ($saftey -match "Off"){
            try {
            Remove-ADGroupMember -Identity $group1Name -Members $user -Confirm:$false
            Write-Host "Removed user '$user' from group '$group1Name'."
            } 
            catch {
            Write-Warning "Failed to remove user '$user' from group '$group1Name': $($_.Exception.Message)"
            }
        }
    }
 }
 Write-Host "Matches: $count" 
