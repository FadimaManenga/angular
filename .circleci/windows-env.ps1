# Install nodejs and yarn via Chocolatey.
choco install nodejs --version 10.16.0 --no-progress
choco install yarn --version 1.16.0 --no-progress

# Install Bazel pre-reqs on Windows
# https://docs.bazel.build/versions/master/install-windows.html
# https://docs.bazel.build/versions/master/windows.html
choco install msys2 --version 20180531.0.0 --no-progress --package-parameters "/NoUpdate"
# Install MSYS2 packages
C:\tools\msys64\usr\bin\bash.exe -l -c "pacman --needed --noconfirm -S zip unzip patch diffutils git"
# Python is needed for Bazel Python targets
choco install python --version 3.5.1 --no-progress
# VS Build Tools are needed for Bazel C++ targets (like com_google_protobuf)
choco install visualstudio2019buildtools --version 16.1.2.0 --no-progress --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.Component.VC.Runtime.UCRTSDK --add Microsoft.VisualStudio.Component.Windows10SDK.17763"

# Add PATH modifications to the Powershell profile. This is the win equivalent of .bash_profile.
# https://docs.microsoft.com/en-us/previous-versions//bb613488(v=vs.85)
new-item -path $profile -itemtype file -force
# Paths for nodejs, npm, yarn, and msys2. Use single quotes to prevent interpolation.
# Add before the original path to use msys2 instead of the installed gitbash.
Add-Content $profile '$Env:path = "${Env:ProgramFiles}\nodejs\;C:\Users\circleci\AppData\Roaming\npm\;${Env:ProgramFiles(x86)}\Yarn\bin\;C:\Users\circleci\AppData\Local\Yarn\bin\;C:\tools\msys64\usr\bin\;" + $Env:path'
# Environment variables for Bazel
Add-Content $profile '$Env:BAZEL_SH = "C:\tools\msys64\usr\bin\bash.exe"'
Add-Content $profile '$Env:BAZEL_VC = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\BuildTools\VC\"'

# Remove the CircleCI checkout SSH override, because it breaks cloning repositories through Bazel.
# See https://circleci.com/gh/angular/angular/401454 for an example.
# TODO: is this really needed? Maybe there's a better way. It doesn't happen on Linux or on Codefresh.
git config --global --unset url.ssh://git@github.com.insteadOf

