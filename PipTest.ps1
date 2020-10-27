Param(
    [int]$count,
    [string]$namePrefix,
    [string]$rgName,
    [string]$location
)

#login
Login-AzureRmAccount

#start stopwatch
[System.Reflection.Assembly]::LoadWithPartialName(“System.Diagnostics”)
$sw = new-object system.diagnostics.stopwatch
$sw.Start()

#create jobs and start them
for($i=1;$i -le $count;$i++){

    $sb = {
        Param($namePrefix,$i,$rgName,$location)
        $dontcare = New-AzureRmPublicIpAddress -Name "$($namePrefix)$($i)" -ResourceGroupName $rgName -Location $location -AllocationMethod Dynamic
    }

    New-Variable -Name "create$($namePrefix)$($i)" -Value ([PowerShell]::Create())
    $null = (Get-Variable -Name "create$($namePrefix)$($i)" -ValueOnly).AddScript($sb).AddArgument($namePrefix).AddArgument($i).AddArgument($rgName).AddArgument($location)
    New-Variable -Name "jobCreate$($namePrefix)$($i)" -Value ((Get-Variable -Name "create$($namePrefix)$($i)" -ValueOnly).BeginInvoke())
    If ((Get-Variable -Name "jobCreate$($namePrefix)$($i)" -ValueOnly)) {Write-Host "Job for PublicIpAddress $($namePrefix)$($i) - started" -ForegroundColor Green}
}

#wait for jobs to complete
$jobsrunning=$true
while($jobsrunning){
    $runningcount=0
    $runningnames=$null

    for($i=1;$i -le $count;$i++){

        If(!(Get-Variable -Name "jobCreate$($namePrefix)$($i)" -ValueOnly).IsCompleted){
            $runningcount++
            [string]$runningnames+="jobCreate$($namePrefix)$($i), "
        }
        Else{
            (Get-Variable -Name "create$($namePrefix)$($i)" -ValueOnly).EndInvoke((Get-Variable -Name "jobCreate$($namePrefix)$($i)" -ValueOnly))
            (Get-Variable -Name "create$($namePrefix)$($i)" -ValueOnly).Dispose()
        }
    }

    if ($runningcount -gt 0){
        Write-Progress -Id "1" -Activity "waiting for jobs" -Status "$runningcount of $count jobs are still running" -CurrentOperation $runningnames
    }
    else{
        $jobsrunning=$false
    }

    start-sleep -Milliseconds 250
}

#stop the stopwatch and report
$sw.Stop()
write-host "Completed in $($sw.Elapsed.Minutes) minutes, $($sw.Elapsed.Seconds) seconds"
