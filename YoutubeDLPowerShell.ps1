# Set working directory to C:\YoutubeDL
$workDir = "C:\YoutubeDL"
Set-Location $workDir

# Define the path to the check file
$checkFile = "$workDir\last_update_check.txt"

# Function to update youtube-dl and write the current date to the check file
function Update-YoutubeDL {
    Start-Process -FilePath "$workDir\youtube-dl.exe" -ArgumentList "-U" -NoNewWindow -Wait
    Write-Host "youtube-dl has been updated."

    # Write today's date to the check file
    Get-Date -Format "yyyy-MM-dd" | Out-File $checkFile
}

# Check if the file exists
if (Test-Path $checkFile) {
    # File exists, read the last update date
    $lastUpdate = Get-Content $checkFile
    $lastUpdateDate = [datetime]::ParseExact($lastUpdate, "yyyy-MM-dd", $null)
    
    # Calculate the difference in days from today
    $today = Get-Date
    $daysSinceUpdate = ($today - $lastUpdateDate).Days

    # If it's been 30 days or more, update youtube-dl
    if ($daysSinceUpdate -ge 30) {
        Update-YoutubeDL
    } else {
        Write-Host "youtube-dl update not needed. Last update was $daysSinceUpdate days ago."
    }
} else {
    # File doesn't exist, perform the update and create the file
    Write-Host "No previous update check found. Running initial update..."
    Update-YoutubeDL
}

# Present options for "Audio Only" or "Video and Audio"
Write-Host "Select download option:"
Write-Host "1. Video and Audio"
Write-Host "2. Audio Only"
$option = Read-Host "Please choose 1 or 2"

# Validate user input
if ($option -eq "1") {
    # Option 1: Video and Audio

    # Prompt for YouTube URL
    $YTSource = Read-Host "Please enter the full YouTube URL (e.g. https://www.youtube.com/watch?v=lLYvq-EKrSY)"

    # Run youtube-dl.exe to list available formats
    Start-Process -FilePath "$workDir\youtube-dl.exe" -ArgumentList "-F", "$YTSource" -NoNewWindow -Wait

    # Prompt for the audio format number
    $AudioFormat = Read-Host "Please enter the audio format number (e.g. 136 for audio)"

    # Prompt for the video format number
    $VideoFormat = Read-Host "Please enter the video format number (e.g. 18 for video)"

    # Run youtube-dl.exe with the selected audio and video formats
    $ffmpegLocation = "C:\YoutubeDL\ffmpeg\bin"
    Start-Process -FilePath "$workDir\youtube-dl.exe" -ArgumentList "-f", "$AudioFormat+$VideoFormat", "--ffmpeg-location", "$ffmpegLocation", "$YTSource" -NoNewWindow -Wait

    # Open the output folder in Windows Explorer
    Start-Process -FilePath explorer.exe -ArgumentList $workDir

    Write-Host "Video and audio download complete."
}
elseif ($option -eq "2") {
    # Option 2: Audio Only

    # Prompt for YouTube URL
    $YTSource = Read-Host "Please enter the full YouTube URL (e.g. https://www.youtube.com/watch?v=lLYvq-EKrSY)"

    # Run youtube-dl.exe to download audio only in MP3 format
    $ffmpegLocation = "C:\YoutubeDL\ffmpeg\bin"
    Start-Process -FilePath "$workDir\youtube-dl.exe" -ArgumentList "-f", "bestaudio", "--extract-audio", "--audio-format", "mp3", "--audio-quality", "0", "--ffmpeg-location", "$ffmpegLocation", "$YTSource" -NoNewWindow -Wait

    # Open the output folder in Windows Explorer
    Start-Process -FilePath explorer.exe -ArgumentList $workDir

    Write-Host "Audio download complete."
}
else {
    Write-Host "Invalid option selected. Exiting..."
}

# Done
