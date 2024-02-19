if(Get-Command scoop -ErrorAction SilentlyContinue){
    Wirte-Host "scoop已安装，跳过"
}else{
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

