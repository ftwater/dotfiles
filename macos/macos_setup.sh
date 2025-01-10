#!/bin/bash

# macOS 开发环境一键安装脚本
# 功能：自动化安装和配置macOS开发环境
# 安装组件：
#   - Java开发环境（JDK 8 + Maven）
#   - Neovim编辑器及相关插件
#   - Zsh shell及Oh My Zsh框架
#   - Bing每日壁纸功能
# 配置内容：
#   - Java环境变量
#   - Neovim配置文件
#   - Zsh配置文件
# 使用说明：
#   1. 直接运行脚本：./macos_setup.sh
#   2. 选择要安装的组件
#   3. 按照提示完成安装

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 进度条函数
show_progress() {
  # 静默模式只显示百分比
  if [[ $SILENT_MODE == true ]]; then
    printf "\r%3d%%" $1
    return
  fi
  
  local width=40
  local percent=$1
  local filled=$((width * percent / 100))
  local empty=$((width - filled))
  printf "\r["
  printf "%${filled}s" | tr ' ' '='
  printf "%${empty}s" | tr ' ' ' '
  printf "] %3d%%" $percent
}

# 日志函数
log() {
  local log_file="install.log"
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local log_msg="${timestamp} [INFO] $1"
  
  # 日志文件轮转
  if [[ -f "$log_file" && $(stat -f%z "$log_file") -gt 1048576 ]]; then
    mv "$log_file" "${log_file}.$(date +%Y%m%d%H%M%S)"
  fi
  
  # 输出到控制台
  echo -e "${GREEN}[INFO]${NC} $1"
  
  # 输出到日志文件
  echo "$log_msg" >> "$log_file"
}

error() {
  local log_file="install.log"
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local log_msg="${timestamp} [ERROR] $1"
  
  # 日志文件轮转
  if [[ -f "$log_file" && $(stat -f%z "$log_file") -gt 1048576 ]]; then
    mv "$log_file" "${log_file}.$(date +%Y%m%d%H%M%S)"
  fi
  
  # 输出到控制台
  echo -e "${RED}[ERROR]${NC} $1" >&2
  
  # 输出到日志文件
  echo "$log_msg" >> "$log_file"
}

# 验证安装结果
verify_installation() {
  local tool=$1
  if command -v $tool &> /dev/null; then
    log "$tool 安装验证成功"
    return 0
  else
    error "$tool 安装验证失败"
    return 1
  fi
}

# 检查命令是否存在
check_command() {
  if ! command -v $1 &> /dev/null; then
    error "$1 未安装，请先安装"
    return 1
  fi
  return 0
}

# 回滚函数
rollback() {
  error "安装失败，正在回滚..."
  # 根据安装步骤添加具体回滚逻辑
  return 0
}

# Java环境安装
install_java() {
  echo
  log "开始安装Java环境..."
  show_progress 10
  
  # 安装前确认
  read -p "确定要安装Java环境吗？(y/n) " confirm
  if [[ $confirm != "y" && $confirm != "Y" ]]; then
    log "已取消Java环境安装"
    return 0
  fi
  
  local start_time=$(date +%s)
  
  # 设置回滚点
  trap rollback EXIT
  
  # 检查依赖
  check_command brew || return 1
  check_command wget || return 1
  check_command tar || return 1
  
  # 安装基础包
  if ! brew install wget tar openjdk@8; then
    error "基础包安装失败"
    return 1
  fi
  
  # 下载Maven
  local maven_file="apache-maven-3.9.6-bin.tar.gz"
  if [[ ! -f $maven_file ]]; then
    log "正在下载Maven..."
    if ! wget -O $maven_file https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz; then
      error "Maven下载失败"
      return 1
    fi
  fi
  
  # 创建工具目录
  local tools_dir=~/tools
  if [[ ! -d $tools_dir ]]; then
    log "创建工具目录: $tools_dir"
    mkdir -p $tools_dir || {
      error "无法创建工具目录"
      return 1
    }
  fi
  
  # 解压并安装Maven
  log "正在安装Maven..."
  if tar -zxvf $maven_file -C $tools_dir && \
     cp -f ./config/settings.xml $tools_dir/apache-maven-3.9.6/conf && \
     rm -rf $maven_file; then
    log "Maven 安装成功"
    show_progress 100
    echo
    
    # 安装后验证
    verify_installation java || return 1
    verify_installation mvn || return 1
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    log "Java环境安装完成，耗时 ${duration} 秒"
  else
    error "Maven 安装失败"
    return 1
  fi
}

# Neovim安装
install_neovim() {
  echo
  log "开始安装Neovim..."
  show_progress 10
  
  # 安装前确认
  read -p "确定要安装Neovim吗？(y/n) " confirm
  if [[ $confirm != "y" && $confirm != "Y" ]]; then
    log "已取消Neovim安装"
    return 0
  fi
  
  local start_time=$(date +%s)
  
  # 设置回滚点
  trap rollback EXIT
  
  # 检查依赖
  check_command brew || return 1
  check_command git || return 1
  
  # 安装基础包
  if ! brew install git neovim; then
    error "基础包安装失败"
    return 1
  fi
  
  # 安装包管理器 packer
  local packer_dir=~/.local/share/nvim/site/pack/packer/start/packer.nvim
  if [[ ! -d $packer_dir ]]; then
    log "正在安装Packer.nvim..."
    if ! git clone --depth 1 https://github.com/wbthomason/packer.nvim $packer_dir; then
      error "Packer.nvim 安装失败"
      return 1
    fi
  fi
  
  # 安装tmux插件管理器
  local tpm_dir=~/.tmux/plugins/tpm
  if [[ ! -d $tpm_dir ]]; then
    log "正在安装TPM..."
    if ! git clone https://github.com/tmux-plugins/tpm $tpm_dir; then
      error "TPM 安装失败"
      return 1
    fi
  fi
  
  log "Neovim 安装成功"
  show_progress 100
  echo
  
  # 安装后验证
  verify_installation nvim || return 1
  verify_installation git || return 1
  
  local end_time=$(date +%s)
  local duration=$((end_time - start_time))
  log "Neovim安装完成，耗时 ${duration} 秒"
}

# Zsh和Oh My Zsh安装
install_zsh() {
  echo
  log "开始安装Zsh和Oh My Zsh..."
  show_progress 10
  
  # 安装前确认
  read -p "确定要安装Zsh和Oh My Zsh吗？(y/n) " confirm
  if [[ $confirm != "y" && $confirm != "Y" ]]; then
    log "已取消Zsh安装"
    return 0
  fi
  
  local start_time=$(date +%s)
  
  # 设置回滚点
  trap rollback EXIT
  
  # 检查依赖
  check_command brew || return 1
  check_command curl || return 1
  check_command sudo || return 1
  
  # 安装基础包
  if ! brew install curl zsh; then
    error "基础包安装失败"
    return 1
  fi
  
  # 安装oh-my-zsh
  log "正在安装oh-my-zsh..."
  if ! echo y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
    error "oh-my-zsh 安装失败"
    return 1
  fi
  
  # 设置默认shell
  if ! sudo chsh -s $(which zsh) $USER; then
    error "无法设置zsh为默认shell"
    return 1
  fi
  
  # 安装zsh-autosuggestions
  local zsh_autosuggestions_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  if [[ ! -d $zsh_autosuggestions_dir ]]; then
    log "正在安装zsh-autosuggestions..."
    if ! git clone https://github.com/zsh-users/zsh-autosuggestions $zsh_autosuggestions_dir; then
      error "zsh-autosuggestions 安装失败"
      return 1
    fi
  fi
  
  log "Zsh 和 Oh My Zsh 安装成功"
  show_progress 100
  echo
  
  # 安装后验证
  verify_installation zsh || return 1
  verify_installation curl || return 1
  
  local end_time=$(date +%s)
  local duration=$((end_time - start_time))
  log "Zsh安装完成，耗时 ${duration} 秒"
}

# Bing壁纸功能
install_bing_wallpaper() {
  log "开始设置Bing壁纸功能..."
  
  # 克隆bing_wallpaper仓库
  if [[ ! -d "bing_wallpaper" ]]; then
    log "正在克隆bing_wallpaper仓库..."
    git clone https://github.com/xiqishow/bing_wallpaper.git bing_wallpaper || {
      error "无法克隆bing_wallpaper仓库"
      return 1
    }
  fi
  
  # 进入bing_wallpaper目录
  cd bing_wallpaper || { error "无法进入bing_wallpaper目录"; return 1; }
  
  # 执行安装脚本
  ./install.sh
  
  log "Bing壁纸功能设置成功"
}

# 显示菜单并选择安装项
show_menu() {
  echo -e "${GREEN}请选择要安装的组件（可多选）：${NC}"
  echo " 1) Java环境"
  echo " 2) Neovim"
  echo " 3) Zsh和Oh My Zsh"
  echo " 4) Bing壁纸功能"
  echo " 5) 全部安装"
  echo " 0) 退出"
  echo
  echo -e "${YELLOW}请输入选择（多个选项用空格分隔）：${NC}"
  
  read -r -a choices
  for choice in "${choices[@]}"; do
    case $choice in
      1) INSTALL_JAVA=true ;;
      2) INSTALL_NEOVIM=true ;;
      3) INSTALL_ZSH=true ;;
      4) INSTALL_WALLPAPER=true ;;
      5)
        INSTALL_JAVA=true
        INSTALL_NEOVIM=true
        INSTALL_ZSH=true
        INSTALL_WALLPAPER=true
        ;;
      0) exit 0 ;;
      *)
        log "ERROR" "无效选择: $choice"
        exit 1
        ;;
    esac
  done
}

# 主菜单
main() {
  # 初始化变量
  INSTALL_JAVA=false
  INSTALL_NEOVIM=false
  INSTALL_ZSH=false
  INSTALL_WALLPAPER=false
  
  # 显示安装前确认提示
  echo -e "${YELLOW}即将安装以下组件：${NC}"
  echo " 1) Java环境"
  echo " 2) Neovim"
  echo " 3) Zsh和Oh My Zsh"
  echo " 4) Bing壁纸功能"
  echo
  echo -e "${RED}此操作将修改系统配置，请确认是否继续？(y/n) ${NC}"
  read confirm
  if [[ $confirm != "y" && $confirm != "Y" ]]; then
    log "安装已取消"
    exit 0
  fi
  
  # 显示菜单并获取选择
  show_menu
  
  # 统计安装项数量
  TOTAL_STEPS=$((INSTALL_JAVA + INSTALL_NEOVIM + INSTALL_ZSH + INSTALL_WALLPAPER))
  CURRENT_STEP=0
  
  # 执行安装
  if $INSTALL_JAVA; then
    install_java || {
      log "ERROR" "Java环境安装失败"
      exit 1
    }
  fi
  
  if $INSTALL_NEOVIM; then
    install_neovim || {
      log "ERROR" "Neovim安装失败"
      exit 1
    }
  fi
  
  if $INSTALL_ZSH; then
    install_zsh || {
      log "ERROR" "Zsh和Oh My Zsh安装失败"
      exit 1
    }
  fi
  
  if $INSTALL_WALLPAPER; then
    install_bing_wallpaper || {
      log "ERROR" "Bing壁纸功能安装失败"
      exit 1
    }
  fi
}

# 执行主函数
main
