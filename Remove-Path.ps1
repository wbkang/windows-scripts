param(
    [Parameter(mandatory=$true)]
    [string]$BinPath,
    [string]$Scope="User"
)

function Get-CanonicalPath($Path) {
    $Path = [System.IO.Path]::Combine( ((pwd).Path), ($Path) )
    $Path = [System.IO.Path]::GetFullPath($Path);
    return $Path;
}


[string]$UserPath = [environment]::GetEnvironmentVariable("PATH", $Scope)

if (-not $UserPath) {
    Write-Host "No PATH variable; Doing nothing."
    return
}
else {
    $CurrentPaths = [System.Collections.Generic.List[String]]$UserPath.Split(";")
    $NewPaths = [System.Collections.Generic.List[String]]@()
    foreach ($Path in $CurrentPaths) {
        if ((Get-CanonicalPath($Path)) -ne (Get-CanonicalPath($BinPath))) {
            $NewPaths.Add($Path)
        }
    }

    
    $NewPath = [String]::Join(";", $NewPaths)

    [environment]::SetEnvironmentVariable("PATH", $NewPath, $Scope)
    Write-Host "New Path is $NewPath"
}

