# PowerShell script to download Poppins fonts

# Create necessary directories
mkdir -p assets/fonts

# Define font files to download
$fonts = @(
    "Poppins-Regular.ttf",
    "Poppins-Bold.ttf",
    "Poppins-Medium.ttf",
    "Poppins-Light.ttf"
)

# Base URL for the fonts
$baseUrl = "https://github.com/alekexe/Poppins-Font/raw/master/"

# Download each font
foreach ($font in $fonts) {
    $url = $baseUrl + $font
    $destination = "assets/fonts/$font"
    Write-Host "Downloading $font..."
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $destination
        Write-Host "Downloaded $font successfully" -ForegroundColor Green
    } catch {
        Write-Host "Failed to download $font: $_" -ForegroundColor Red
    }
}

Write-Host "Font download complete!" -ForegroundColor Green 