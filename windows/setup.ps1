if(Get-Command scoop -ErrorAction SilentlyContinue){
    Wirte-Host "scoop已安装，跳过"
}else{
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

scoop bucket add extras
scoop bucket add nonportable
scoop bucket add nerd-fonts
scoop install extras/googlechrome
scoop install nonportable/virtualbox-np
scoop install extras/idea
scoop install extras/vscode
scoop install nerd-fonts/0xProto-NF
scoop install nerd-fonts/0xProto-NF-Mono
scoop install nerd-fonts/0xProto-NF-Propo
scoop install extras/bitwarden
scoop install main/git
scoop install main/oh-my-posh
scoop install extras/lazy-posh-git

New-NetFirewallRule -DisplayName "custom rdp 33890" -Direction Inbound -LocalPort 33890 -Protocol TCP -Action Allow
