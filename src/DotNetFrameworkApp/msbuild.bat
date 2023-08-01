"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\amd64\msbuild.exe" -t:restore 
"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\amd64\msbuild.exe" /p:DeployOnBuild=true  /p:PublishProfile=Folderprofile

copy DockerFile publish


