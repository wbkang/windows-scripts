param(
    [Parameter(mandatory=$true)]
    [string]$BinPath,
    [string]$Scope="User",
    [Boolean]$AddToHead=$true
)

function Get-CanonicalPath($Path) {
    $Path = [System.IO.Path]::Combine( ((pwd).Path), ($Path) )
    $Path = [System.IO.Path]::GetFullPath($Path);
    return $Path;
}

$BinPath = Get-CanonicalPath $BinPath

if (-not (Test-Path $BinPath)) {
    throw "$BinPath is not a directory"
}

[string]$UserPath = [environment]::GetEnvironmentVariable("PATH", $Scope)

if (-not $UserPath) {
    Write-Host "Setting a new PATH variable"
    [environment]::SetEnvironmentVariable("PATH", $BinPath, $Scope)
}
else {
    $CurrentPaths = [System.Collections.Generic.List[String]]$UserPath.Split(";")

    foreach ($Path in $CurrentPaths) {
        if ((Get-CanonicalPath($Path)) -eq $BinPath) {
            Write-Host "$BinPath already in PATH. Not doing anything"
            return
        }
    }

    if ($AddToHead) {
        $CurrentPaths.Insert(0, $BinPath)
    }
    else {
        $CurrentPaths.add($BinPath)
    }
    $NewPath = [String]::Join(";", $CurrentPaths)

    [environment]::SetEnvironmentVariable("PATH", $NewPath, $Scope)
    Write-Host "New Path is $NewPath"
}

