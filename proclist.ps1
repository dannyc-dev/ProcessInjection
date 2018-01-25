#https://superuser.com/questions/285413/is-there-a-windows-command-that-returns-the-list-of-64-and-32-process
[System.Diagnostics.Process[]] $processes64bit = @()
[System.Diagnostics.Process[]] $processes32bit = @()

foreach($process in get-process) {
    $modules = $process.modules
    foreach($module in $modules) {
        $file = [System.IO.Path]::GetFileName($module.FileName).ToLower()
        if($file -eq "wow64.dll") {
            $processes32bit += $process
            break
        }
    }

    if(!($processes32bit -contains $process)) {
        $processes64bit += $process
    }
}

write-host "32-bit Processes:"
$processes32bit | sort-object Name | format-table Name, Id -auto

write-host ""
write-host "64-bit Processes:"
$processes64bit | sort-object Name | format-table Name, Id -auto
