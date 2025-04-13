#!/bin/bash

# Ubuntu命令大全脚本安装器
# 通过网络指令一键安装Ubuntu命令大全脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # 无颜色

# 安装目录
INSTALL_DIR="/usr/local/bin/ub_command_menu"
SCRIPTS_DIR="/tmp/ub_command_menu_tmp"

# 显示标题
echo -e "${BLUE}┌───────────────────────────────────────────────┐${NC}"
echo -e "${BLUE}│                                               │${NC}"
echo -e "${BLUE}│${YELLOW}       Ubuntu命令大全脚本 - 网络安装器          ${BLUE}│${NC}"
echo -e "${BLUE}│                                               │${NC}"
echo -e "${BLUE}└───────────────────────────────────────────────┘${NC}"
echo ""

# 检查是否有root权限
check_root() {
    if [ "$(id -u)" != "0" ]; then
        echo -e "${RED}错误: 此脚本需要root权限才能安装到系统目录${NC}"
        echo -e "${YELLOW}请使用sudo运行此脚本${NC}"
        exit 1
    fi
}

# 显示进度条
show_progress() {
    local duration=$1
    local prefix=$2
    local size=30
    local char="█"
    
    echo -ne "${prefix} [${NC}"
    for ((i=0; i<size; i++)); do
        echo -ne " "
    done
    echo -ne "${NC}] 0%\r"
    
    for ((i=0; i<=size; i++)); do
        local pct=$((i*100/size))
        echo -ne "${prefix} [${NC}"
        for ((j=0; j<i; j++)); do
            echo -ne "${GREEN}${char}${NC}"
        done
        for ((j=i; j<size; j++)); do
            echo -ne " "
        done
        echo -ne "${NC}] ${pct}%\r"
        sleep $(echo "scale=2; ${duration}/${size}" | bc)
    done
    echo ""
}

# 创建临时目录
create_temp_dir() {
    echo -e "${CYAN}创建临时目录...${NC}"
    mkdir -p ${SCRIPTS_DIR}
    show_progress 0.5 "${CYAN}准备安装${NC}"
}

# 下载脚本文件
download_scripts() {
    echo -e "${CYAN}下载脚本文件...${NC}"
    
    # 这里应该是实际的下载URL，现在使用GitHub raw URL作为示例
    # 实际部署时需要替换为真实的URL
    local base_url="https://github.com/Gaoce8888/ub/blob/main"
    
    echo -e "${YELLOW}下载主脚本...${NC}"
    curl -s -o ${SCRIPTS_DIR}/ub_commands.sh ${base_url}/ub_commands.sh
    
    echo -e "${YELLOW}下载预设选项管理脚本...${NC}"
    curl -s -o ${SCRIPTS_DIR}/preset_manager.sh ${base_url}/preset_manager.sh
    
    echo -e "${YELLOW}下载虚拟环境管理脚本...${NC}"
    curl -s -o ${SCRIPTS_DIR}/virtual_env_manager.sh ${base_url}/virtual_env_manager.sh
    
    echo -e "${YELLOW}下载脚本授权工具...${NC}"
    curl -s -o ${SCRIPTS_DIR}/script_auth_manager.sh ${base_url}/script_auth_manager.sh
    
    echo -e "${YELLOW}下载README文件...${NC}"
    curl -s -o ${SCRIPTS_DIR}/README.md ${base_url}/README.md
    
    show_progress 2 "${CYAN}下载文件${NC}"
}

# 创建安装目录
create_install_dir() {
    echo -e "${CYAN}创建安装目录...${NC}"
    mkdir -p ${INSTALL_DIR}
    show_progress 0.5 "${CYAN}准备安装目录${NC}"
}

# 复制脚本文件到安装目录
copy_scripts() {
    echo -e "${CYAN}安装脚本文件...${NC}"
    cp ${SCRIPTS_DIR}/*.sh ${INSTALL_DIR}/
    cp ${SCRIPTS_DIR}/README.md ${INSTALL_DIR}/
    show_progress 1 "${CYAN}复制文件${NC}"
}

# 设置执行权限
set_permissions() {
    echo -e "${CYAN}设置执行权限...${NC}"
    chmod +x ${INSTALL_DIR}/*.sh
    show_progress 0.5 "${CYAN}设置权限${NC}"
}

# 创建全局命令链接
create_global_command() {
    echo -e "${CYAN}创建全局命令...${NC}"
    
    # 创建主命令链接
    cat > /usr/local/bin/ubcmd << EOF
#!/bin/bash
${INSTALL_DIR}/ub_commands.sh "\$@"
EOF
    chmod +x /usr/local/bin/ubcmd
    
    show_progress 0.5 "${CYAN}创建命令${NC}"
}

# 设置快捷键
setup_shortcut() {
    echo -e "${CYAN}设置快捷键...${NC}"
    
    # 检查是否已经设置了快捷键
    if ! grep -q "# UB 命令大全快捷键" /etc/bash.bashrc; then
        echo "" >> /etc/bash.bashrc
        echo "# UB 命令大全快捷键" >> /etc/bash.bashrc
        echo "bind -x '\"\C-f\":\"${INSTALL_DIR}/ub_commands.sh\"'" >> /etc/bash.bashrc
        echo "" >> /etc/bash.bashrc
    fi
    
    # 设置数字键 6 快捷键
    if ! grep -q "# 数字键 6 快捷键" /etc/bash.bashrc; then
        echo "# 数字键 6 快捷键" >> /etc/bash.bashrc
        echo "bind -x '\"\e[17~\":\"${INSTALL_DIR}/ub_commands.sh\"'" >> /etc/bash.bashrc
        echo "" >> /etc/bash.bashrc
    fi
    
    show_progress 1 "${CYAN}设置快捷键${NC}"
}

# 创建卸载脚本
create_uninstall_script() {
    echo -e "${CYAN}创建卸载脚本...${NC}"
    
    cat > ${INSTALL_DIR}/uninstall.sh << EOF
#!/bin/bash

# Ubuntu命令大全脚本卸载器

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # 无颜色

# 检查是否有root权限
if [ "\$(id -u)" != "0" ]; then
    echo -e "\${RED}错误: 此脚本需要root权限才能卸载${NC}"
    echo -e "\${YELLOW}请使用sudo运行此脚本${NC}"
    exit 1
fi

echo -e "\${BLUE}┌───────────────────────────────────────────────┐\${NC}"
echo -e "\${BLUE}│                                               │\${NC}"
echo -e "\${BLUE}│\${YELLOW}       Ubuntu命令大全脚本 - 卸载程序           \${BLUE}│\${NC}"
echo -e "\${BLUE}│                                               │\${NC}"
echo -e "\${BLUE}└───────────────────────────────────────────────┘\${NC}"
echo ""

echo -e "\${YELLOW}确定要卸载Ubuntu命令大全脚本吗? (y/n)${NC} "
read -n 1 confirm

if [[ \$confirm != "y" && \$confirm != "Y" ]]; then
    echo -e "\n\${CYAN}卸载已取消.${NC}"
    exit 0
fi

echo -e "\n\${CYAN}开始卸载...${NC}"

# 删除全局命令
echo -e "\${CYAN}删除全局命令...${NC}"
rm -f /usr/local/bin/ubcmd

# 删除快捷键设置
echo -e "\${CYAN}删除快捷键设置...${NC}"
sed -i '/# UB 命令大全快捷键/,+2d' /etc/bash.bashrc
sed -i '/# 数字键 6 快捷键/,+2d' /etc/bash.bashrc

# 删除安装目录
echo -e "\${CYAN}删除安装目录...${NC}"
rm -rf ${INSTALL_DIR}

echo -e "\n\${GREEN}Ubuntu命令大全脚本已成功卸载!${NC}"
echo -e "\${YELLOW}请重新加载终端或运行 'source /etc/bash.bashrc' 使更改生效.${NC}"
EOF
    
    chmod +x ${INSTALL_DIR}/uninstall.sh
    
    # 创建卸载命令链接
    cat > /usr/local/bin/ubcmd-uninstall << EOF
#!/bin/bash
sudo ${INSTALL_DIR}/uninstall.sh
EOF
    chmod +x /usr/local/bin/ubcmd-uninstall
    
    show_progress 1 "${CYAN}创建卸载程序${NC}"
}

# 清理临时文件
cleanup() {
    echo -e "${CYAN}清理临时文件...${NC}"
    rm -rf ${SCRIPTS_DIR}
    show_progress 0.5 "${CYAN}清理临时文件${NC}"
}

# 显示安装完成信息
show_completion() {
    echo -e "\n${GREEN}Ubuntu命令大全脚本已成功安装!${NC}"
    echo -e "${YELLOW}使用方法:${NC}"
    echo -e "  1. 命令行输入 ${CYAN}ubcmd${NC} 启动脚本"
    echo -e "  2. 按 ${CYAN}数字键6${NC} 或 ${CYAN}Ctrl+F${NC} 快速调出命令菜单"
    echo -e "  3. 卸载请运行 ${CYAN}ubcmd-uninstall${NC}"
    echo -e "\n${YELLOW}请重新加载终端或运行 'source /etc/bash.bashrc' 使快捷键生效.${NC}"
}

# 主函数
main() {
    check_root
    create_temp_dir
    download_scripts
    create_install_dir
    copy_scripts
    set_permissions
    create_global_command
    setup_shortcut
    create_uninstall_script
    cleanup
    show_completion
}

# 执行主函数
main
