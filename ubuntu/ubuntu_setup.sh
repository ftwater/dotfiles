#!/bin/bash

# Ubuntu 开发环境一键安装脚本
# 功能：自动化安装和配置Ubuntu开发环境
# 安装组件：
#   - Google Chrome浏览器
#   - Java开发环境（JDK 8 + Maven）
#   - Neovim编辑器及相关插件
#   - Nerd字体
#   - Zsh shell及Oh My Zsh框架
#   - Snap常用开发工具
# 配置内容：
#   - Java环境变量
#   - Neovim配置文件
#   - Zsh配置文件
#   - Snap常用开发工具
# 使用说明：
#   1. 直接运行脚本：./ubuntu_setup.sh
#   2. 选择要安装的组件
#   3. 按照提示完成安装

# 统一安装脚本
# 版本: 2.0
# 作者: Cline
# 最后更新: 2024-01-01

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 初始化变量
INSTALL_CHROME=false
INSTALL_JAVA=false
INSTALL_NEOVIM=false
INSTALL_FONTS=false
INSTALL_ZSH=false
CONFIG_SNAP=false
SILENT_MODE=false
START_TIME=$(date +%s)

# 日志文件
LOG_FILE="ubuntu_setup.log"

# 函数：带颜色的日志记录
log() {
  local level=$1
  local message=$2
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  
  case $level in
    "INFO") color=$BLUE ;;
    "SUCCESS") color=$GREEN ;;
    "WARNING") color=$YELLOW ;;
    "ERROR") color=$RED ;;
    *) color=$NC ;;
  esac
  
  echo -e "${color}[${timestamp}] ${level}: ${message}${NC}" >> "$LOG_FILE"
}

# 函数：显示帮助
show_help() {
  echo -e "${GREEN}用法:${NC}"
  echo "  ./ubuntu_setup.sh [选项]"
  echo
  echo -e "${BLUE}选项:${NC}"
  echo "  --all        安装所有组件"
  echo "  --chrome     安装Google Chrome"
  echo "  --java       安装Java环境"
  echo "  --neovim     安装Neovim"
  echo "  --fonts      安装Nerd字体"
  echo "  --zsh        安装Zsh和Oh My Zsh"
  echo "  --snap       配置Snap"
  echo "  --silent     静默模式（不显示进度）"
  echo "  --help       显示帮助信息"
  echo
  echo -e "${YELLOW}示例:${NC}"
  echo "  ./ubuntu_setup.sh --all --silent"
  echo "  ./ubuntu_setup.sh --chrome --java"
  exit 0
}

# 函数：检查命令执行结果
check_command() {
  if [ $? -ne 0 ]; then
    log "ERROR" "命令执行失败: $1"
    return 1
  fi
  return 0
}

# 函数：显示进度条
show_progress() {
  local width=50
  local percent=$1
  
  # 如果总步骤为0，直接显示100%
  if [ $TOTAL_STEPS -eq 0 ]; then
    percent=100
  fi
  
  local filled=$((width * percent / 100))
  local empty=$((width - filled))
  
  if ! $SILENT_MODE; then
    printf "\r${BLUE}[${NC}"
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' ' '
    printf "${BLUE}] ${GREEN}%3d%%${NC}" $percent
  fi
}

# 捕获EXIT信号，确保退出时显示完整进度
trap 'show_progress 100' EXIT

# 函数：安装前检查
pre_install_check() {
  # 检查root权限
  if [ "$EUID" -eq 0 ]; then
    log "WARNING" "不建议使用root用户执行此脚本"
    read -p "是否继续？[y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    fi
  fi
}

# 显示菜单并选择安装项
show_menu() {
  echo -e "${GREEN}请选择要安装的组件（可多选）：${NC}"
  echo " 1) Google Chrome"
  echo " 2) Java环境"
  echo " 3) Neovim"
  echo " 4) Nerd字体"
  echo " 5) Zsh和Oh My Zsh"
  echo " 6) Snap配置"
  echo " 7) 全部安装"
  echo " 0) 退出"
  echo
  echo -e "${YELLOW}请输入选择（多个选项用空格分隔）：${NC}"
  
  read -r -a choices
  for choice in "${choices[@]}"; do
    case $choice in
      1) INSTALL_CHROME=true ;;
      2) INSTALL_JAVA=true ;;
      3) INSTALL_NEOVIM=true ;;
      4) INSTALL_FONTS=true ;;
      5) INSTALL_ZSH=true ;;
      6) CONFIG_SNAP=true ;;
      7)
        INSTALL_CHROME=true
        INSTALL_JAVA=true
        INSTALL_NEOVIM=true
        INSTALL_FONTS=true
        INSTALL_ZSH=true
        CONFIG_SNAP=true
        ;;
      0) exit 0 ;;
      *)
        log "ERROR" "无效选择: $choice"
        exit 1
        ;;
    esac
  done
}

# 显示菜单并获取选择
show_menu

# 安装前确认
echo
log "WARNING" "即将安装以下组件："
$INSTALL_CHROME && log "INFO" "  - Google Chrome"
$INSTALL_JAVA && log "INFO" "  - Java环境"
$INSTALL_NEOVIM && log "INFO" "  - Neovim"
$INSTALL_FONTS && log "INFO" "  - Nerd字体"
$INSTALL_ZSH && log "INFO" "  - Zsh和Oh My Zsh"
$CONFIG_SNAP && log "INFO" "  - Snap配置"
echo

read -p "确定要开始安装吗？[y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  log "INFO" "安装已取消"
  exit 0
fi

# 安装前检查
pre_install_check

# 统计安装项数量，至少为1
TOTAL_STEPS=$((INSTALL_CHROME + INSTALL_JAVA + INSTALL_NEOVIM + INSTALL_FONTS + INSTALL_ZSH + CONFIG_SNAP))
TOTAL_STEPS=$((TOTAL_STEPS > 0 ? TOTAL_STEPS : 1))
CURRENT_STEP=0

# 安装Google Chrome
install_chrome() {
  CURRENT_STEP=$((CURRENT_STEP + 1))
  show_progress $((CURRENT_STEP * 100 / TOTAL_STEPS))
  log "INFO" "开始安装Google Chrome ($CURRENT_STEP/$TOTAL_STEPS)..."
  
  local chrome_deb="google-chrome-stable_current_amd64.deb"
  local download_url="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  
  # 下载
  if [[ ! -f $chrome_deb ]]; then
    log "INFO" "下载Google Chrome..."
    wget -q --show-progress $download_url -O $chrome_deb
    check_command "下载Google Chrome" || return 1
  fi

  # 安装
  log "INFO" "安装Google Chrome..."
  sudo dpkg -i $chrome_deb > /dev/null
  if ! check_command "安装Google Chrome"; then
    log "INFO" "尝试修复依赖..."
    sudo apt-get -f install -y > /dev/null &&
    sudo dpkg -i $chrome_deb > /dev/null &&
    check_command "重新安装Google Chrome" || return 1
  fi

  # 清理
  rm -f $chrome_deb
  log "SUCCESS" "Google Chrome安装完成"
  return 0
}

if $INSTALL_CHROME; then
  install_chrome || {
    log "ERROR" "Google Chrome安装失败"
    exit 1
  }
fi

# 安装Java环境
install_java() {
  CURRENT_STEP=$((CURRENT_STEP + 1))
  show_progress $((CURRENT_STEP * 100 / TOTAL_STEPS))
  log "INFO" "开始安装Java环境 ($CURRENT_STEP/$TOTAL_STEPS)..."

  # 安装JDK
  log "INFO" "安装OpenJDK 8..."
  sudo apt-get install -qq -y wget tar openjdk-8-jdk
  check_command "安装OpenJDK 8" || return 1

  # 安装Maven
  local maven_version="3.9.6"
  local maven_file="apache-maven-${maven_version}-bin.tar.gz"
  local maven_url="https://dlcdn.apache.org/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz"
  
  if [[ ! -f $maven_file ]]; then
    log "INFO" "下载Maven ${maven_version}..."
    wget -q --show-progress $maven_url
    check_command "下载Maven" || return 1
  fi

  if [[ -f $maven_file ]]; then
    log "INFO" "安装Maven..."
    mkdir -p ~/tools
    tar -zxf $maven_file -C ~/tools/
    cp -f ./config/settings.xml ~/tools/apache-maven-${maven_version}/conf/
    rm -f $maven_file
    
    # 添加环境变量
    echo "export MAVEN_HOME=~/tools/apache-maven-${maven_version}" >> ~/.bashrc
    echo 'export PATH=$MAVEN_HOME/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    
    log "SUCCESS" "Maven安装完成"
    return 0
  else
    log "ERROR" "Maven安装文件不存在"
    return 1
  fi
}

if $INSTALL_JAVA; then
  install_java || {
    log "ERROR" "Java环境安装失败"
    exit 1
  }
fi

# 安装Neovim
install_neovim() {
  CURRENT_STEP=$((CURRENT_STEP + 1))
  show_progress $((CURRENT_STEP * 100 / TOTAL_STEPS))
  log "INFO" "开始安装Neovim ($CURRENT_STEP/$TOTAL_STEPS)..."

  # 更新包列表
  log "INFO" "更新包列表..."
  sudo apt-get update -qq
  check_command "更新包列表" || return 1

  # 安装Neovim
  log "INFO" "安装Neovim..."
  sudo apt-get install -qq -y git neovim
  check_command "安装Neovim" || return 1

  # 安装Packer.nvim
  log "INFO" "安装Packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim > /dev/null
  check_command "安装Packer.nvim" || return 1

  # 创建nvim配置软链接
  log "INFO" "创建nvim配置软链接..."
  mkdir -p ~/.config
  ln -sf ../common/nvim ~/.config/nvim
  check_command "创建nvim配置软链接" || return 1

  log "SUCCESS" "Neovim安装完成"
  return 0
}

if $INSTALL_NEOVIM; then
  install_neovim || {
    log "ERROR" "Neovim安装失败"
    exit 1
  }
fi

# 安装Nerd字体
install_nerd_fonts() {
  CURRENT_STEP=$((CURRENT_STEP + 1))
  show_progress $((CURRENT_STEP * 100 / TOTAL_STEPS))
  log "INFO" "开始安装Nerd字体 ($CURRENT_STEP/$TOTAL_STEPS)..."

  local font_version="3.1.1"
  local font_zip="0xProto.zip"
  local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${font_version}/${font_zip}"
  local temp_dir=$(mktemp -d)

  # 下载字体
  log "INFO" "下载Nerd字体..."
  wget -q --show-progress $font_url -P $temp_dir
  check_command "下载Nerd字体" || return 1

  # 解压字体
  log "INFO" "安装Nerd字体..."
  mkdir -p $temp_dir/fonts
  unzip -q $temp_dir/$font_zip -d $temp_dir/fonts
  mkdir -p ~/.fonts
  cp $temp_dir/fonts/*.ttf ~/.fonts/

  # 更新字体缓存
  fc-cache -fv > /dev/null
  check_command "更新字体缓存" || return 1

  # 清理
  rm -rf $temp_dir
  log "SUCCESS" "Nerd字体安装完成"
  return 0
}

if $INSTALL_FONTS; then
  install_nerd_fonts || {
    log "ERROR" "Nerd字体安装失败"
    exit 1
  }
fi

# 安装Zsh和Oh My Zsh
install_zsh() {
  CURRENT_STEP=$((CURRENT_STEP + 1))
  show_progress $((CURRENT_STEP * 100 / TOTAL_STEPS))
  log "INFO" "开始安装Zsh和Oh My Zsh ($CURRENT_STEP/$TOTAL_STEPS)..."

  # 安装Zsh
  log "INFO" "安装Zsh..."
  sudo apt-get install -qq -y curl zsh
  check_command "安装Zsh" || return 1

  # 安装Oh My Zsh
  log "INFO" "安装Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null
  check_command "安装Oh My Zsh" || return 1

  # 设置默认shell
  log "INFO" "设置Zsh为默认shell..."
  sudo chsh -s $(which zsh) $USER
  check_command "设置默认shell" || return 1

  # 安装zsh-autosuggestions
  log "INFO" "安装zsh-autosuggestions..."
  git clone -q https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  check_command "安装zsh-autosuggestions" || return 1

  # 创建zshrc配置软链接
  log "INFO" "创建zshrc配置软链接..."
  ln -sf ~/dotfiles/ubuntu/config/zshrc ~/.zshrc
  check_command "创建zshrc配置软链接" || return 1

  log "SUCCESS" "Zsh和Oh My Zsh安装完成"
  return 0
}

if $INSTALL_ZSH; then
  install_zsh || {
    log "ERROR" "Zsh和Oh My Zsh安装失败"
    exit 1
  }
fi

# 配置Snap
configure_snap() {
  CURRENT_STEP=$((CURRENT_STEP + 1))
  show_progress $((CURRENT_STEP * 100 / TOTAL_STEPS))
  log "INFO" "开始配置Snap ($CURRENT_STEP/$TOTAL_STEPS)..."

  # 安装Snap包
  local snap_packages=(
    "intellij-idea-community --classic"
    "datagrip --channel=2022.1/stable --classic"
    "postman --channel=v9/stable"
    "bitwarden"
    "code --classic"
    "obsidian --classic"
  )

  for pkg in "${snap_packages[@]}"; do
    log "INFO" "安装Snap包: ${pkg%% *}"
    sudo snap install $pkg > /dev/null
    check_command "安装Snap包: ${pkg%% *}" || return 1
  done

  log "SUCCESS" "Snap配置完成"
  return 0
}

if $CONFIG_SNAP; then
  configure_snap || {
    log "ERROR" "Snap配置失败"
    exit 1
  }
fi

# 显示总耗时
END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))
log "SUCCESS" "所有选定的安装任务已完成"
log "INFO" "总耗时: ${TOTAL_TIME}秒"
