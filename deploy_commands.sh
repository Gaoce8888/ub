#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # 恢复默认颜色

# 打印带颜色的标题
print_header() {
    echo -e "${BLUE}====================================================${NC}"
    echo -e "${YELLOW}             Ubuntu 命令大全部署工具                ${NC}"
    echo -e "${BLUE}====================================================${NC}"
    echo ""
}

# 打印成功消息
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# 打印错误消息
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# 打印信息
print_info() {
    echo -e "${BLUE}➜ $1${NC}"
}

# 显示帮助信息
show_help() {
    echo "Ubuntu 命令大全部署工具"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -l, --local         部署到本地系统"
    echo "  -r, --remote        部署到远程服务器"
    echo "  -b, --backup        备份当前配置"
    echo "  -s, --restore       从备份恢复"
    echo "  -u, --update        更新现有安装"
    echo "  -g, --github        上传到GitHub并生成一键部署指令"
    echo "  -v, --version       显示版本信息"
    echo "  -h, --help          显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 --local          部署到本地系统"
    echo "  $0 --remote         部署到远程服务器"
    echo "  $0 --github         上传到GitHub并生成一键部署指令"
    echo ""
}

# 显示版本信息
show_version() {
    echo "Ubuntu 命令大全部署工具 v1.0"
    echo "Copyright (c) 2023"
}

# 本地部署函数
deploy_local() {
    print_header
    print_info "开始本地部署..."
    
    # 部署目录
    DEPLOY_DIR="$HOME/ub_command_menu"
    
    # 创建部署目录
    print_info "创建部署目录..."
    mkdir -p "$DEPLOY_DIR"
    if [ $? -eq 0 ]; then
        print_success "部署目录创建成功"
    else
        print_error "部署目录创建失败"
        exit 1
    fi
    
    # 当前脚本所在目录
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 复制脚本文件
    print_info "复制脚本文件..."
    cp "$SCRIPT_DIR/ub_commands.sh" \
       "$SCRIPT_DIR/preset_manager.sh" \
       "$SCRIPT_DIR/virtual_env_manager.sh" \
       "$SCRIPT_DIR/script_auth_manager.sh" \
       "$DEPLOY_DIR/"
    
    if [ $? -eq 0 ]; then
        print_success "脚本文件复制成功"
    else
        print_error "脚本文件复制失败"
        exit 1
    fi
    
    # 设置执行权限
    print_info "设置脚本执行权限..."
    chmod +x "$DEPLOY_DIR/ub_commands.sh" \
             "$DEPLOY_DIR/preset_manager.sh" \
             "$DEPLOY_DIR/virtual_env_manager.sh" \
             "$DEPLOY_DIR/script_auth_manager.sh"
    
    if [ $? -eq 0 ]; then
        print_success "执行权限设置成功"
    else
        print_error "执行权限设置失败"
        exit 1
    fi
    
    # 创建数据目录
    print_info "创建数据目录..."
    mkdir -p "$DEPLOY_DIR/data"
    if [ $? -eq 0 ]; then
        print_success "数据目录创建成功"
    else
        print_error "数据目录创建失败"
        exit 1
    fi
    
    # 配置快捷键
    print_info "配置快捷键..."
    
    # 检查 .bashrc 中是否已存在配置
    if grep -q "# UB 命令大全快捷键" ~/.bashrc; then
        print_info "快捷键已配置，跳过此步骤"
    else
        # 添加快捷键配置到 .bashrc
        cat >> ~/.bashrc << 'EOL'

# UB 命令大全快捷键
bind -x '"\C-f":"$HOME/ub_command_menu/ub_commands.sh"'

# 数字键 6 快捷键 (F6功能键)
bind -x '"\e[17~":"$HOME/ub_command_menu/ub_commands.sh"'

# 数字键 6 别名配置
alias 6="$HOME/ub_command_menu/ub_commands.sh"
EOL
        if [ $? -eq 0 ]; then
            print_success "快捷键配置成功"
        else
            print_error "快捷键配置失败"
            exit 1
        fi
    fi
    
    echo ""
    echo -e "${GREEN}====================================================${NC}"
    echo -e "${GREEN}      Ubuntu 命令大全脚本部署成功!                  ${NC}"
    echo -e "${GREEN}====================================================${NC}"
    echo ""
    echo -e "使用方法:"
    echo -e "  1. 重新加载配置: ${YELLOW}source ~/.bashrc${NC}"
    echo -e "  2. 按 ${YELLOW}数字键6${NC} 或 ${YELLOW}Ctrl+F${NC} 启动命令菜单"
    echo ""
    echo -e "详细说明请查看: ${YELLOW}README.md${NC}"
    echo ""
}

# 远程部署函数
deploy_remote() {
    print_header
    print_info "开始远程部署..."
    
    # 要求输入远程服务器信息
    read -p "请输入远程服务器IP: " REMOTE_IP
    read -p "请输入远程服务器用户名: " REMOTE_USER
    read -p "请输入远程部署目录 [/home/$REMOTE_USER/ub_command_menu]: " REMOTE_DIR
    
    # 设置默认部署目录
    if [ -z "$REMOTE_DIR" ]; then
        REMOTE_DIR="/home/$REMOTE_USER/ub_command_menu"
    fi
    
    # 当前脚本所在目录
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 检查远程服务器连接
    print_info "检查远程服务器连接..."
    ssh -q -o BatchMode=yes -o ConnectTimeout=5 $REMOTE_USER@$REMOTE_IP "echo 2>&1" >/dev/null
    if [ $? -eq 0 ]; then
        print_success "远程服务器连接成功"
    else
        print_error "无法连接到远程服务器，请检查IP和用户名"
        exit 1
    fi
    
    # 创建远程部署目录
    print_info "创建远程部署目录..."
    ssh $REMOTE_USER@$REMOTE_IP "mkdir -p $REMOTE_DIR"
    if [ $? -eq 0 ]; then
        print_success "远程部署目录创建成功"
    else
        print_error "远程部署目录创建失败"
        exit 1
    fi
    
    # 复制脚本文件到远程服务器
    print_info "复制脚本文件到远程服务器..."
    scp "$SCRIPT_DIR/ub_commands.sh" \
        "$SCRIPT_DIR/preset_manager.sh" \
        "$SCRIPT_DIR/virtual_env_manager.sh" \
        "$SCRIPT_DIR/script_auth_manager.sh" \
        "$SCRIPT_DIR/install.sh" \
        "$REMOTE_USER@$REMOTE_IP:$REMOTE_DIR/"
    
    if [ $? -eq 0 ]; then
        print_success "脚本文件复制成功"
    else
        print_error "脚本文件复制失败"
        exit 1
    fi
    
    # 设置远程脚本执行权限
    print_info "设置远程脚本执行权限..."
    ssh $REMOTE_USER@$REMOTE_IP "chmod +x $REMOTE_DIR/*.sh"
    if [ $? -eq 0 ]; then
        print_success "远程脚本执行权限设置成功"
    else
        print_error "远程脚本执行权限设置失败"
        exit 1
    fi
    
    # 远程执行安装脚本
    print_info "远程执行安装脚本..."
    ssh $REMOTE_USER@$REMOTE_IP "$REMOTE_DIR/install.sh"
    if [ $? -eq 0 ]; then
        print_success "远程安装成功"
    else
        print_error "远程安装失败"
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}====================================================${NC}"
    echo -e "${GREEN}      Ubuntu 命令大全脚本远程部署成功!              ${NC}"
    echo -e "${GREEN}====================================================${NC}"
    echo ""
    echo -e "远程服务器: ${YELLOW}$REMOTE_USER@$REMOTE_IP${NC}"
    echo -e "部署目录: ${YELLOW}$REMOTE_DIR${NC}"
    echo ""
    echo -e "使用方法:"
    echo -e "  1. 登录到远程服务器"
    echo -e "  2. 重新加载配置: ${YELLOW}source ~/.bashrc${NC}"
    echo -e "  3. 按 ${YELLOW}数字键6${NC} 或 ${YELLOW}Ctrl+F${NC} 启动命令菜单"
    echo ""
}

# 备份当前配置
backup_config() {
    print_header
    print_info "开始备份当前配置..."
    
    # 备份目录
    BACKUP_DIR="$HOME/ub_command_backup"
    BACKUP_FILE="$BACKUP_DIR/ub_command_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    
    # 创建备份目录
    print_info "创建备份目录..."
    mkdir -p "$BACKUP_DIR"
    if [ $? -eq 0 ]; then
        print_success "备份目录创建成功"
    else
        print_error "备份目录创建失败"
        exit 1
    fi
    
    # 检查是否存在ub_command_menu目录
    if [ ! -d "$HOME/ub_command_menu" ]; then
        print_error "未发现 ub_command_menu 目录，无法备份"
        exit 1
    fi
    
    # 创建备份文件
    print_info "创建备份文件..."
    tar -czf "$BACKUP_FILE" -C "$HOME" "ub_command_menu"
    if [ $? -eq 0 ]; then
        print_success "备份文件创建成功"
    else
        print_error "备份文件创建失败"
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}====================================================${NC}"
    echo -e "${GREEN}      Ubuntu 命令大全脚本备份成功!                  ${NC}"
    echo -e "${GREEN}====================================================${NC}"
    echo ""
    echo -e "备份文件: ${YELLOW}$BACKUP_FILE${NC}"
    echo ""
}

# 从备份恢复
restore_config() {
    print_header
    print_info "开始从备份恢复..."
    
    # 备份目录
    BACKUP_DIR="$HOME/ub_command_backup"
    
    # 检查备份目录是否存在
    if [ ! -d "$BACKUP_DIR" ]; then
        print_error "未发现备份目录 $BACKUP_DIR"
        exit 1
    fi
    
    # 列出所有备份文件
    print_info "可用的备份文件:"
    BACKUP_FILES=($BACKUP_DIR/ub_command_backup_*.tar.gz)
    if [ ${#BACKUP_FILES[@]} -eq 0 ]; then
        print_error "未发现备份文件"
        exit 1
    fi
    
    for i in "${!BACKUP_FILES[@]}"; do
        echo "  $((i+1)). $(basename ${BACKUP_FILES[$i]})"
    done
    
    # 选择备份文件
    read -p "请选择要恢复的备份文件 [1-${#BACKUP_FILES[@]}]: " BACKUP_CHOICE
    if [ -z "$BACKUP_CHOICE" ] || [ $BACKUP_CHOICE -lt 1 ] || [ $BACKUP_CHOICE -gt ${#BACKUP_FILES[@]} ]; then
        print_error "无效的选择"
        exit 1
    fi
    
    SELECTED_BACKUP=${BACKUP_FILES[$((BACKUP_CHOICE-1))]}
    
    # 备份当前配置
    print_info "备份当前配置..."
    CURRENT_BACKUP="$BACKUP_DIR/ub_command_current_$(date +%Y%m%d_%H%M%S).tar.gz"
    if [ -d "$HOME/ub_command_menu" ]; then
        tar -czf "$CURRENT_BACKUP" -C "$HOME" "ub_command_menu"
        print_success "当前配置已备份到 $CURRENT_BACKUP"
    else
        print_info "当前不存在配置，跳过备份"
    fi
    
    # 恢复选择的备份
    print_info "恢复备份 $(basename $SELECTED_BACKUP)..."
    # 删除当前配置
    rm -rf "$HOME/ub_command_menu"
    # 解压备份文件
    tar -xzf "$SELECTED_BACKUP" -C "$HOME"
    if [ $? -eq 0 ]; then
        print_success "备份恢复成功"
    else
        print_error "备份恢复失败"
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}====================================================${NC}"
    echo -e "${GREEN}      Ubuntu 命令大全脚本恢复成功!                  ${NC}"
    echo -e "${GREEN}====================================================${NC}"
    echo ""
    echo -e "已恢复备份: ${YELLOW}$(basename $SELECTED_BACKUP)${NC}"
    echo ""
    echo -e "使用方法:"
    echo -e "  1. 重新加载配置: ${YELLOW}source ~/.bashrc${NC}"
    echo -e "  2. 按 ${YELLOW}数字键6${NC} 或 ${YELLOW}Ctrl+F${NC} 启动命令菜单"
    echo ""
}

# 更新现有安装
update_installation() {
    print_header
    print_info "开始更新现有安装..."
    
    # 检查是否存在ub_command_menu目录
    if [ ! -d "$HOME/ub_command_menu" ]; then
        print_error "未发现 ub_command_menu 目录，无法更新"
        exit 1
    fi
    
    # 当前脚本所在目录
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 备份当前配置
    print_info "备份当前配置..."
    BACKUP_DIR="$HOME/ub_command_backup"
    CURRENT_BACKUP="$BACKUP_DIR/ub_command_before_update_$(date +%Y%m%d_%H%M%S).tar.gz"
    mkdir -p "$BACKUP_DIR"
    tar -czf "$CURRENT_BACKUP" -C "$HOME" "ub_command_menu"
    print_success "当前配置已备份到 $CURRENT_BACKUP"
    
    # 更新脚本文件
    print_info "更新脚本文件..."
    cp "$SCRIPT_DIR/ub_commands.sh" \
       "$SCRIPT_DIR/preset_manager.sh" \
       "$SCRIPT_DIR/virtual_env_manager.sh" \
       "$SCRIPT_DIR/script_auth_manager.sh" \
       "$HOME/ub_command_menu/"
    
    if [ $? -eq 0 ]; then
        print_success "脚本文件更新成功"
    else
        print_error "脚本文件更新失败"
        exit 1
    fi
    
    # 设置执行权限
    print_info "设置脚本执行权限..."
    chmod +x "$HOME/ub_command_menu/ub_commands.sh" \
             "$HOME/ub_command_menu/preset_manager.sh" \
             "$HOME/ub_command_menu/virtual_env_manager.sh" \
             "$HOME/ub_command_menu/script_auth_manager.sh"
    
    if [ $? -eq 0 ]; then
        print_success "执行权限设置成功"
    else
        print_error "执行权限设置失败"
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}====================================================${NC}"
    echo -e "${GREEN}      Ubuntu 命令大全脚本更新成功!                  ${NC}"
    echo -e "${GREEN}====================================================${NC}"
    echo ""
    echo -e "备份文件: ${YELLOW}$CURRENT_BACKUP${NC}"
    echo ""
    echo -e "使用方法:"
    echo -e "  1. 重新加载配置: ${YELLOW}source ~/.bashrc${NC}"
    echo -e "  2. 按 ${YELLOW}数字键6${NC} 或 ${YELLOW}Ctrl+F${NC} 启动命令菜单"
    echo ""
}

# 上传到GitHub仓库并生成一键部署指令
upload_to_github() {
    print_header
    print_info "准备上传到GitHub并生成一键部署指令..."
    
    # 检查是否安装了git
    if ! command -v git &> /dev/null; then
        print_error "未安装git，请先安装："
        echo -e "${YELLOW}sudo apt update && sudo apt install -y git${NC}"
        exit 1
    fi
    
    # 获取GitHub用户名和仓库名
    read -p "请输入GitHub用户名: " GITHUB_USER
    read -p "请输入GitHub仓库名 [ubuntu-commands]: " GITHUB_REPO
    
    if [ -z "$GITHUB_USER" ]; then
        print_error "GitHub用户名不能为空"
        exit 1
    fi
    
    if [ -z "$GITHUB_REPO" ]; then
        GITHUB_REPO="ubuntu-commands"
    fi
    
    # 检查是否已配置git
    if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
        print_info "配置git用户信息..."
        read -p "请输入您的姓名: " GIT_NAME
        read -p "请输入您的邮箱: " GIT_EMAIL
        
        git config --global user.name "$GIT_NAME"
        git config --global user.email "$GIT_EMAIL"
    fi
    
    # 创建临时目录
    print_info "创建临时工作目录..."
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    
    # 当前脚本所在目录
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 复制所有脚本文件到临时目录
    print_info "复制脚本文件到临时目录..."
    cp "$SCRIPT_DIR/ub_commands.sh" \
       "$SCRIPT_DIR/preset_manager.sh" \
       "$SCRIPT_DIR/virtual_env_manager.sh" \
       "$SCRIPT_DIR/script_auth_manager.sh" \
       "$SCRIPT_DIR/install.sh" \
       "$SCRIPT_DIR/deploy_commands.sh" \
       "$TMP_DIR/"
    
    # 如果存在README.md，也复制
    if [ -f "$SCRIPT_DIR/README.md" ]; then
        cp "$SCRIPT_DIR/README.md" "$TMP_DIR/"
    else
        # 创建简单的README.md
        cat > "$TMP_DIR/README.md" << 'EOF'
# Ubuntu 命令大全

这是一个专为 Ubuntu 设计的命令大全脚本，主要针对项目部署环境，提供了丰富的命令分类和功能。

## 一键安装

使用以下命令一键安装：

```bash
curl -fsSL https://raw.githubusercontent.com/USERNAME/REPO/main/install.sh | bash
```

或者：

```bash
wget -O- https://raw.githubusercontent.com/USERNAME/REPO/main/install.sh | bash
```

## 使用方法

安装完成后：

1. 重新加载配置: `source ~/.bashrc`
2. 按数字键6或Ctrl+F启动命令菜单
3. 或者直接输入`6`并按回车键启动命令菜单

详细说明请参考完整的文档。
EOF
        sed -i "s/USERNAME/$GITHUB_USER/g" "$TMP_DIR/README.md"
        sed -i "s/REPO/$GITHUB_REPO/g" "$TMP_DIR/README.md"
    fi
    
    # 如果存在LICENSE，也复制
    if [ -f "$SCRIPT_DIR/LICENSE" ]; then
        cp "$SCRIPT_DIR/LICENSE" "$TMP_DIR/"
    fi
    
    # 创建一键部署脚本
    print_info "创建一键部署脚本..."
    cat > "$TMP_DIR/one_click_install.sh" << 'EOF'
#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # 恢复默认颜色

echo -e "${BLUE}====================================================${NC}"
echo -e "${YELLOW}      Ubuntu 命令大全一键安装程序                  ${NC}"
echo -e "${BLUE}====================================================${NC}"
echo ""

# 检查系统
echo -e "${BLUE}➜ 检查系统...${NC}"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
        echo -e "${GREEN}✓ 检测到 Ubuntu 系统: $VERSION_ID${NC}"
    else
        echo -e "${YELLOW}! 检测到非 Ubuntu 系统: $ID $VERSION_ID${NC}"
        echo -e "${YELLOW}! 此脚本设计用于 Ubuntu 系统，其他系统可能会有兼容性问题${NC}"
        read -p "是否继续安装? (y/n): " CONTINUE
        if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
            echo -e "${RED}✗ 安装已取消${NC}"
            exit 1
        fi
    fi
else
    echo -e "${YELLOW}! 无法确定操作系统类型${NC}"
    read -p "是否继续安装? (y/n): " CONTINUE
    if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
        echo -e "${RED}✗ 安装已取消${NC}"
        exit 1
    fi
fi

# 创建临时目录
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# 下载安装脚本
echo -e "${BLUE}➜ 下载安装脚本...${NC}"
GITHUB_USER="GITHUB_USER_PLACEHOLDER"
GITHUB_REPO="GITHUB_REPO_PLACEHOLDER"
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main"

SCRIPTS=("ub_commands.sh" "preset_manager.sh" "virtual_env_manager.sh" "script_auth_manager.sh" "install.sh")

# 下载所有脚本
for SCRIPT in "${SCRIPTS[@]}"; do
    if command -v curl &> /dev/null; then
        curl -sO "$BASE_URL/$SCRIPT"
    elif command -v wget &> /dev/null; then
        wget -q "$BASE_URL/$SCRIPT"
    else
        echo -e "${RED}✗ 未找到 curl 或 wget 命令${NC}"
        echo -e "${YELLOW}请先安装 curl 或 wget:${NC}"
        echo -e "${YELLOW}sudo apt update && sudo apt install -y curl${NC}"
        exit 1
    fi
done

# 运行安装脚本
echo -e "${BLUE}➜ 运行安装脚本...${NC}"
bash install.sh

# 清理临时文件
echo -e "${BLUE}➜ 清理临时文件...${NC}"
cd ~
rm -rf "$TMP_DIR"

echo ""
echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}      Ubuntu 命令大全一键安装完成!                  ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo ""
echo -e "使用方法:"
echo -e "  1. 重新加载配置: ${YELLOW}source ~/.bashrc${NC}"
echo -e "  2. 按 ${YELLOW}数字键6${NC} 或 ${YELLOW}Ctrl+F${NC} 启动命令菜单"
echo -e "  3. 或者直接输入 ${YELLOW}6${NC} 并按回车键启动命令菜单"
echo ""
EOF

    # 替换占位符
    sed -i "s/GITHUB_USER_PLACEHOLDER/$GITHUB_USER/g" "$TMP_DIR/one_click_install.sh"
    sed -i "s/GITHUB_REPO_PLACEHOLDER/$GITHUB_REPO/g" "$TMP_DIR/one_click_install.sh"
    chmod +x "$TMP_DIR/one_click_install.sh"
    
    # 初始化git仓库
    print_info "初始化Git仓库..."
    git init
    git add .
    git commit -m "初始提交 Ubuntu命令大全脚本"
    
    # 创建GitHub仓库（可选）
    read -p "是否需要创建新的GitHub仓库？(y/n): " CREATE_REPO
    if [ "$CREATE_REPO" = "y" ] || [ "$CREATE_REPO" = "Y" ]; then
        print_info "请在浏览器中访问以下网址创建新仓库："
        echo -e "${YELLOW}https://github.com/new${NC}"
        echo -e "仓库名称: ${YELLOW}$GITHUB_REPO${NC}"
        echo -e "确保创建为公开(Public)仓库"
        read -p "仓库创建好后按回车继续..."
    fi
    
    # 添加远程仓库并推送
    print_info "添加GitHub远程仓库..."
    git remote add origin "https://github.com/$GITHUB_USER/$GITHUB_REPO.git"
    
    # 推送到GitHub
    print_info "推送到GitHub..."
    git push -u origin main || git push -u origin master
    
    # 检查是否成功
    if [ $? -eq 0 ]; then
        print_success "成功推送到GitHub仓库"
        
        # 生成一键部署命令
        echo ""
        echo -e "${GREEN}====================================================${NC}"
        echo -e "${GREEN}      一键部署命令已生成                           ${NC}"
        echo -e "${GREEN}====================================================${NC}"
        echo ""
        echo -e "使用以下命令可以一键安装部署："
        echo -e "${YELLOW}curl -fsSL https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/one_click_install.sh | bash${NC}"
        echo ""
        echo -e "或者："
        echo -e "${YELLOW}wget -O- https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/one_click_install.sh | bash${NC}"
        echo ""
        echo -e "GitHub仓库地址："
        echo -e "${YELLOW}https://github.com/$GITHUB_USER/$GITHUB_REPO${NC}"
        echo ""
    else
        print_error "推送到GitHub失败，请检查用户名和仓库名是否正确，以及是否有权限"
        echo -e "您可以手动执行以下命令："
        echo -e "${YELLOW}cd $TMP_DIR${NC}"
        echo -e "${YELLOW}git remote set-url origin https://github.com/$GITHUB_USER/$GITHUB_REPO.git${NC}"
        echo -e "${YELLOW}git push -u origin main${NC}"
        exit 1
    fi
    
    # 清理临时目录
    cd "$SCRIPT_DIR"
    rm -rf "$TMP_DIR"
}

# 主函数
main() {
    # 如果没有参数，显示帮助信息
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    # 处理参数
    case "$1" in
        -l|--local)
            deploy_local
            ;;
        -r|--remote)
            deploy_remote
            ;;
        -b|--backup)
            backup_config
            ;;
        -s|--restore)
            restore_config
            ;;
        -u|--update)
            update_installation
            ;;
        -g|--github)
            upload_to_github
            ;;
        -v|--version)
            show_version
            ;;
        -h|--help)
            show_help
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"
