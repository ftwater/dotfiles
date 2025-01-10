<#
.SYNOPSIS
Windows 环境初始化脚本

.DESCRIPTION
该脚本用于自动配置Windows开发环境，包括：
- 安装scoop包管理器
- 安装常用开发工具
- 配置RDP远程桌面
- 记录安装日志

.PARAMETER None
该脚本为交互式脚本，无需参数

.EXAMPLE
.\setup.ps1
直接运行脚本即可开始环境配置

.NOTES
作者: Cline
版本: 1.0.0
创建日期: 2024-01-01
最后修改: 2024-01-01
#>

# 初始化日志
$logFile = "$env:USERPROFILE\setup.log"
Start-Transcript -Path $logFile -Append
Write-Host "安装日志将保存到: $logFile" -ForegroundColor Cyan

# 定义可选的软件包
$allPackages = @{
    "Google Chrome" = "extras/googlechrome"
    "VirtualBox" = "nonportable/virtualbox-np"
    "IntelliJ IDEA" = "extras/idea"
    "VS Code" = "extras/vscode"
    "0xProto Nerd Font" = "nerd-fonts/0xProto-NF"
    "0xProto Mono Nerd Font" = "nerd-fonts/0xProto-NF-Mono"
    "0xProto Propo Nerd Font" = "nerd-fonts/0xProto-NF-Propo"
    "Bitwarden" = "extras/bitwarden"
    "Git" = "main/git"
    "Oh My Posh" = "main/oh-my-posh"
    "Lazy Posh Git" = "extras/lazy-posh-git"
}

# 显示选择菜单
Write-Host "`n请选择要安装的软件包（输入编号，多个用逗号分隔，all表示全部）：" -ForegroundColor Yellow
$index = 1
$allPackages.GetEnumerator() | ForEach-Object {
    Write-Host "$index. $($_.Key)"
    $index++
}

# 获取用户选择
$choices = Read-Host "`n请输入选择"
if ($choices -eq "all") {
    $selectedPackages = $allPackages.Values
} else {
    $selectedIndexes = $choices -split ',' | ForEach-Object { [int]$_ - 1 }
    $selectedPackages = $allPackages.Values | Select-Object -Index $selectedIndexes
}

# 强制添加scoop和sudo到安装列表
$requiredPackages = @("sudo")
$selectedPackages = $requiredPackages + $selectedPackages | Select-Object -Unique

# 检查并安装scoop
if(Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "scoop已安装，跳过" -ForegroundColor Green
} else {
    try {
        Write-Host "正在安装scoop..." -ForegroundColor Cyan
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        Write-Host "scoop安装成功" -ForegroundColor Green
    } catch {
        Write-Host "scoop安装失败: $_" -ForegroundColor Red
        Stop-Transcript
        exit 1
    }
}

# 添加必要的bucket
$buckets = @("extras", "nonportable", "nerd-fonts")
foreach ($bucket in $buckets) {
    try {
        Write-Host "正在添加bucket: $bucket" -ForegroundColor Cyan
        scoop bucket add $bucket
    } catch {
        Write-Host "添加bucket $bucket 失败: $_" -ForegroundColor Red
    }
}

# 安装sudo
try {
    Write-Host "正在安装sudo..." -ForegroundColor Cyan
    scoop install sudo
} catch {
    Write-Host "sudo安装失败: $_" -ForegroundColor Red
}

# 安装进度跟踪
$total = $selectedPackages.Count
$current = 0

# 批量安装软件包
foreach ($package in $selectedPackages) {
    $current++
    $percent = [math]::Round(($current / $total) * 100)
    Write-Progress -Activity "正在安装软件包" -Status "$package ($current/$total)" -PercentComplete $percent
    
    try {
        Write-Host "正在安装 $package..." -ForegroundColor Cyan
        scoop install $package
        Write-Host "$package 安装成功" -ForegroundColor Green
    } catch {
        Write-Host "$package 安装失败: $_" -ForegroundColor Red
    }
}

# 配置RDP
try {
    Write-Host "正在配置RDP..." -ForegroundColor Cyan
    New-NetFirewallRule -DisplayName "custom rdp 33890" -Direction Inbound -LocalPort 33890 -Protocol TCP -Action Allow
    sudo New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations' -Name "DWMFRAMEINTERVAL" -Value 15 -PropertyType DWORD
    Write-Host "RDP配置完成" -ForegroundColor Green
} catch {
    Write-Host "RDP配置失败: $_" -ForegroundColor Red
}

# 显示安装摘要
Write-Host "`n安装摘要：" -ForegroundColor Yellow
Write-Host "已安装软件包：" -ForegroundColor Cyan
$selectedPackages | ForEach-Object { Write-Host "- $_" }

Write-Host "`n所有操作已完成，详细日志请查看: $logFile" -ForegroundColor Green
Stop-Transcript
