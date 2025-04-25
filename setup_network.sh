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
    echo -e "${YELLOW}      Ubuntu 命令大全网络安装部署工具              ${NC}"
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

# 生成一键安装命令
generate_install_command() {
    print_header
    print_info "生成网络一键安装命令..."
    
    # 获取服务器地址
    read -p "请输入您的服务器IP或域名: " SERVER_ADDRESS
    if [ -z "$SERVER_ADDRESS" ]; then
        print_error "服务器地址不能为空"
        exit 1
    fi
    
    # 创建服务器端接收目录
    read -p "请输入服务器上存放安装脚本的目录 [/var/www/html/ub]: " SERVER_DIR
    if [ -z "$SERVER_DIR" ]; then
        SERVER_DIR="/var/www/html/ub"
    fi
    
    # 生成安装命令
    CURL_COMMAND="curl -fsSL http://${SERVER_ADDRESS}/ub/install.sh | bash"
    WGET_COMMAND="wget -O- http://${SERVER_ADDRESS}/ub/install.sh | bash"
    
    echo ""
    echo -e "${GREEN}====================================================${NC}"
    echo -e "${GREEN}      Ubuntu 命令大全网络安装命令                   ${NC}"
    echo -e "${GREEN}====================================================${NC}"
    echo ""
    echo -e "使用 curl 安装:"
    echo -e "${YELLOW}$CURL_COMMAND${NC}"
    echo ""
    echo -e "使用 wget 安装:"
    echo -e "${YELLOW}$WGET_COMMAND${NC}"
    echo ""
    echo -e "将此命令分享给需要安装的用户即可一键完成安装。"
    echo ""
    
    # 询问是否配置服务器
    read -p "是否要配置您的服务器以支持此安装命令? (y/n): " SETUP_SERVER
    if [ "$SETUP_SERVER" = "y" ] || [ "$SETUP_SERVER" = "Y" ]; then
        setup_server "$SERVER_ADDRESS" "$SERVER_DIR"
    else
        echo -e "您可以稍后手动配置服务器。"
    fi
}

# 配置服务器
setup_server() {
    local SERVER_ADDRESS=$1
    local SERVER_DIR=$2
    
    print_info "开始配置服务器..."
    
    # 检查是否为本地服务器
    if [[ "$SERVER_ADDRESS" == "localhost" || "$SERVER_ADDRESS" == "127.0.0.1" ]]; then
        # 本地配置
        print_info "配置本地服务器..."
        
        # 检查是否安装了 Apache 或 Nginx
        if command -v apache2 >/dev/null 2>&1 || command -v nginx >/dev/null 2>&1; then
            # 创建服务器目录
            sudo mkdir -p "$SERVER_DIR"
            if [ $? -eq 0 ]; then
                print_success "服务器目录创建成功"
            else
                print_error "服务器目录创建失败，请确保有足够的权限"
                exit 1
            fi
            
            # 复制安装脚本到服务器目录
            SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            sudo cp "$SCRIPT_DIR/install.sh" \
                   "$SCRIPT_DIR/ub_commands.sh" \
                   "$SCRIPT_DIR/preset_manager.sh" \
                   "$SCRIPT_DIR/virtual_env_manager.sh" \
                   "$SCRIPT_DIR/script_auth_manager.sh" \
                   "$SERVER_DIR/"
            
            if [ $? -eq 0 ]; then
                print_success "脚本复制到服务器目录成功"
            else
                print_error "脚本复制到服务器目录失败"
                exit 1
            fi
            
            # 设置适当的权限
            sudo chmod -R 755 "$SERVER_DIR"
            sudo chown -R www-data:www-data "$SERVER_DIR"
            
            print_success "本地服务器配置完成"
            echo -e "您现在可以通过以下命令进行一键安装:"
            echo -e "${YELLOW}curl -fsSL http://${SERVER_ADDRESS}/ub/install.sh | bash${NC}"
        else
            print_error "未检测到 Apache 或 Nginx，请先安装 Web 服务器"
            echo -e "您可以使用以下命令安装 Apache:"
            echo -e "${YELLOW}sudo apt update && sudo apt install -y apache2${NC}"
            exit 1
        fi
    else
        # 远程服务器配置
        print_info "配置远程服务器..."
        
        # 询问远程服务器登录信息
        read -p "请输入远程服务器用户名: " REMOTE_USER
        if [ -z "$REMOTE_USER" ]; then
            print_error "远程服务器用户名不能为空"
            exit 1
        fi
        
        # 检查远程服务器连接
        print_info "检查远程服务器连接..."
        ssh -q -o BatchMode=yes -o ConnectTimeout=5 $REMOTE_USER@$SERVER_ADDRESS "echo 2>&1" >/dev/null
        if [ $? -eq 0 ]; then
            print_success "远程服务器连接成功"
        else
            print_error "无法连接到远程服务器，请检查 IP 和用户名"
            exit 1
        fi
        
        # 创建临时打包目录
        print_info "打包安装脚本..."
        TMP_DIR=$(mktemp -d)
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        
        cp "$SCRIPT_DIR/install.sh" \
           "$SCRIPT_DIR/ub_commands.sh" \
           "$SCRIPT_DIR/preset_manager.sh" \
           "$SCRIPT_DIR/virtual_env_manager.sh" \
           "$SCRIPT_DIR/script_auth_manager.sh" \
           "$TMP_DIR/"
        
        # 创建一个部署脚本
        cat > "$TMP_DIR/deploy_to_web.sh" << EOF
#!/bin/bash
# 检查并安装 Apache 或 Nginx
if ! command -v apache2 >/dev/null 2>&1 && ! command -v nginx >/dev/null 2>&1; then
    echo "安装 Apache..."
    sudo apt update && sudo apt install -y apache2
fi

# 创建目标目录
sudo mkdir -p $SERVER_DIR

# 复制文件
sudo cp install.sh ub_commands.sh preset_manager.sh virtual_env_manager.sh script_auth_manager.sh $SERVER_DIR/

# 设置权限
sudo chmod -R 755 $SERVER_DIR
sudo chown -R www-data:www-data $SERVER_DIR

echo "服务器配置完成!"
EOF
        
        chmod +x "$TMP_DIR/deploy_to_web.sh"
        
        # 打包
        tar -czf "$TMP_DIR/ub_install_package.tar.gz" -C "$TMP_DIR" .
        
        # 上传到远程服务器
        print_info "上传安装包到远程服务器..."
        scp "$TMP_DIR/ub_install_package.tar.gz" "$REMOTE_USER@$SERVER_ADDRESS:~/"
        
        if [ $? -eq 0 ]; then
            print_success "安装包上传成功"
        else
            print_error "安装包上传失败"
            rm -rf "$TMP_DIR"
            exit 1
        fi
        
        # 在远程服务器上解压并执行部署脚本
        print_info "在远程服务器上部署..."
        ssh $REMOTE_USER@$SERVER_ADDRESS << EOF
mkdir -p ~/ub_tmp
tar -xzf ~/ub_install_package.tar.gz -C ~/ub_tmp
cd ~/ub_tmp
./deploy_to_web.sh
rm -rf ~/ub_tmp
rm -f ~/ub_install_package.tar.gz
EOF
        
        if [ $? -eq 0 ]; then
            print_success "远程服务器配置完成"
            echo -e "用户现在可以通过以下命令进行一键安装:"
            echo -e "${YELLOW}curl -fsSL http://${SERVER_ADDRESS}/ub/install.sh | bash${NC}"
        else
            print_error "远程服务器配置失败"
            exit 1
        fi
        
        # 清理临时目录
        rm -rf "$TMP_DIR"
    fi
}

# 创建网络安装脚本
create_network_installer() {
    print_header
    print_info "创建网络安装脚本..."
    
    # 当前脚本所在目录
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 确保存在install.sh文件
    if [ ! -f "$SCRIPT_DIR/install.sh" ]; then
        print_error "未找到 install.sh 文件，请确保它存在于当前目录"
        exit 1
    fi
    
    # 创建网络安装脚本
    cat > "$SCRIPT_DIR/network_install.sh" << 'EOF'
#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # 恢复默认颜色

# 打印标题
echo -e "${BLUE}====================================================${NC}"
echo -e "${YELLOW}      Ubuntu 命令大全网络安装程序                  ${NC}"
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
SCRIPTS=("ub_commands.sh" "preset_manager.sh" "virtual_env_manager.sh" "script_auth_manager.sh")

# 下载所有脚本
for SCRIPT in "${SCRIPTS[@]}"; do
    if command -v curl &> /dev/null; then
        curl -sO "http://${SERVER_ADDRESS}/ub/$SCRIPT"
    elif command -v wget &> /dev/null; then
        wget -q "http://${SERVER_ADDRESS}/ub/$SCRIPT"
    else
        echo -e "${RED}✗ 未找到 curl 或 wget 命令${NC}"
        echo -e "${YELLOW}请先安装 curl 或 wget:${NC}"
        echo -e "${YELLOW}sudo apt update && sudo apt install -y curl${NC}"
        exit 1
    fi
done

# 创建安装目录
echo -e "${BLUE}➜ 创建安装目录...${NC}"
mkdir -p ~/ub_command_menu
mkdir -p ~/ub_command_menu/data

# 复制脚本文件
echo -e "${BLUE}➜ 复制脚本文件...${NC}"
cp *.sh ~/ub_command_menu/

# 设置执行权限
echo -e "${BLUE}➜ 设置执行权限...${NC}"
chmod +x ~/ub_command_menu/*.sh

# 配置快捷键
echo -e "${BLUE}➜ 配置快捷键...${NC}"
if grep -q "# UB 命令大全快捷键" ~/.bashrc; then
    echo -e "${BLUE}➜ 快捷键已配置，跳过此步骤${NC}"
else
    cat >> ~/.bashrc << 'EOL'

# UB 命令大全快捷键
bind -x '"\C-f":"$HOME/ub_command_menu/ub_commands.sh"'

# 数字键 6 快捷键 (F6功能键)
bind -x '"\e[17~":"$HOME/ub_command_menu/ub_commands.sh"'

# 数字键 6 别名配置
alias 6="$HOME/ub_command_menu/ub_commands.sh"
EOL
fi

# 清理临时文件
echo -e "${BLUE}➜ 清理临时文件...${NC}"
cd ~
rm -rf "$TMP_DIR"

echo ""
echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}      Ubuntu 命令大全安装成功!                     ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo ""
echo -e "使用方法:"
echo -e "  1. 重新加载配置: ${YELLOW}source ~/.bashrc${NC}"
echo -e "  2. 按 ${YELLOW}数字键6${NC} 或 ${YELLOW}Ctrl+F${NC} 启动命令菜单"
echo -e "  3. 或者直接输入 ${YELLOW}6${NC} 并按回车键启动命令菜单"
echo ""
EOF
    
    # 替换SERVER_ADDRESS变量
    read -p "请输入服务器IP或域名: " SERVER_ADDRESS
    if [ -z "$SERVER_ADDRESS" ]; then
        print_error "服务器地址不能为空"
        exit 1
    fi
    
    sed -i "s|\${SERVER_ADDRESS}|$SERVER_ADDRESS|g" "$SCRIPT_DIR/network_install.sh"
    chmod +x "$SCRIPT_DIR/network_install.sh"
    
    if [ $? -eq 0 ]; then
        print_success "网络安装脚本创建成功: $SCRIPT_DIR/network_install.sh"
        
        # 显示一键安装命令
        echo ""
        echo -e "${GREEN}====================================================${NC}"
        echo -e "${GREEN}      一键网络安装命令                             ${NC}"
        echo -e "${GREEN}====================================================${NC}"
        echo ""
        echo -e "使用 curl 安装:"
        echo -e "${YELLOW}curl -fsSL http://${SERVER_ADDRESS}/ub/network_install.sh | bash${NC}"
        echo ""
        echo -e "使用 wget 安装:"
        echo -e "${YELLOW}wget -O- http://${SERVER_ADDRESS}/ub/network_install.sh | bash${NC}"
        echo ""
        
        # 询问是否配置服务器
        read -p "是否要将此脚本部署到服务器? (y/n): " DEPLOY_SCRIPT
        if [ "$DEPLOY_SCRIPT" = "y" ] || [ "$DEPLOY_SCRIPT" = "Y" ]; then
            # 询问服务器信息
            read -p "请输入服务器目录 [/var/www/html/ub]: " SERVER_DIR
            if [ -z "$SERVER_DIR" ]; then
                SERVER_DIR="/var/www/html/ub"
            fi
            
            setup_server "$SERVER_ADDRESS" "$SERVER_DIR"
        fi
    else
        print_error "网络安装脚本创建失败"
        exit 1
    fi
}

# 显示帮助信息
show_help() {
    echo "Ubuntu 命令大全网络安装部署工具"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -g, --generate     生成一键安装命令"
    echo "  -c, --create       创建网络安装脚本"
    echo "  -s, --setup        配置安装服务器"
    echo "  -h, --help         显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 --generate      生成一键安装命令"
    echo "  $0 --create        创建网络安装脚本"
    echo ""
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
        -g|--generate)
            generate_install_command
            ;;
        -c|--create)
            create_network_installer
            ;;
        -s|--setup)
            read -p "请输入服务器IP或域名: " SERVER_ADDRESS
            read -p "请输入服务器目录 [/var/www/html/ub]: " SERVER_DIR
            if [ -z "$SERVER_DIR" ]; then
                SERVER_DIR="/var/www/html/ub"
            fi
            setup_server "$SERVER_ADDRESS" "$SERVER_DIR"
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
