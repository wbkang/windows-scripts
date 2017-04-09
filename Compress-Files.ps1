param(
    [Array]$SourcePaths="C:\",
    [Array]$WhiteList=@("iso", "exe", "cso", "bin", "img", "dll"),
    [Array]$BlackList=@("vdi", "vmdk"),
    [Int]$SizeLimitInGB=30,
    [Int]$MinimumFileAgeInDays=180
)

$WhiteList = $WhiteList | % { "." + $_  }
$BlackList = $BlackList | % { "." + $_  }

Get-ChildItem -File -Path $SourcePaths -Recurse | % {
  if ($WhiteList -contains $_.Extension.ToLower()) {
    echo "$_ matches the whitelist"
    compact /c $_.FullName
    return
  }
  if ($BlackList -contains $_.Extension.ToLower()) {
    echo "$_ matches the blacklist"
    compact /u $_.FullName
    return
  }
  if ($_.Length -gt ($SizeLimitInGB * 1024 * 1024 * 1024)) {
    echo "$_ is too big"
    compact /u $_.FullName
    return
  }
  if ($_.CreationTime -lt (Get-Date).AddDays(-1 * $MinimumFileAgeInDays)) {
    echo "$_ is old enough"
    compact /c $_.FullName
  }
}