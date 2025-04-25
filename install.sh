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
    echo -e "${YELLOW}             Ubuntu 命令大全脚本安装器              ${NC}"
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

# 主安装函数
install_ub_commands() {
    print_header
    
    print_info "开始安装 Ubuntu 命令大全脚本..."
    
    # 创建目标目录
    print_info "创建安装目录..."
    mkdir -p ~/ub_command_menu
    if [ $? -eq 0 ]; then
        print_success "目录创建成功"
    else
        print_error "目录创建失败"
        exit 1
    fi
    
    # 复制脚本文件
    print_info "复制脚本文件..."
    
    # 当前脚本所在目录
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 复制所有脚本文件
    cp "$SCRIPT_DIR/ub_commands.sh" \
       "$SCRIPT_DIR/preset_manager.sh" \
       "$SCRIPT_DIR/virtual_env_manager.sh" \
       "$SCRIPT_DIR/script_auth_manager.sh" \
       ~/ub_command_menu/
    
    if [ $? -eq 0 ]; then
        print_success "脚本文件复制成功"
    else
        print_error "脚本文件复制失败"
        exit 1
    fi
    
    # 设置执行权限
    print_info "设置脚本执行权限..."
    chmod +x ~/ub_command_menu/ub_commands.sh \
             ~/ub_command_menu/preset_manager.sh \
             ~/ub_command_menu/virtual_env_manager.sh \
             ~/ub_command_menu/script_auth_manager.sh
    
    if [ $? -eq 0 ]; then
        print_success "执行权限设置成功"
    else
        print_error "执行权限设置失败"
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

# 数字键 6 快捷键
bind -x '"\e[17~":"$HOME/ub_command_menu/ub_commands.sh"'
EOL
        if [ $? -eq 0 ]; then
            print_success "快捷键配置成功"
        else
            print_error "快捷键配置失败"
            exit 1
        fi
    fi
    
    # 检查创建数据目录
    print_info "创建数据目录..."
    mkdir -p ~/ub_command_menu/data
    if [ $? -eq 0 ]; then
        print_success "数据目录创建成功"
    else
        print_error "数据目录创建失败"
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}====================================================${NC}"
    echo -e "${GREEN}      Ubuntu 命令大全脚本安装成功!                  ${NC}"
    echo -e "${GREEN}====================================================${NC}"
    echo ""
    echo -e "使用方法:"
    echo -e "  1. 重新加载配置: ${YELLOW}source ~/.bashrc${NC}"
    echo -e "  2. 按 ${YELLOW}数字键6${NC} 或 ${YELLOW}Ctrl+F${NC} 启动命令菜单"
    echo ""
    echo -e "详细说明请查看: ${YELLOW}README.md${NC}"
    echo ""
}

# 执行安装
install_ub_commands
