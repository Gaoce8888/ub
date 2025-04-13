#!/bin/bash

# 脚本授权工具
# 提供一键授权所有脚本文件的功能

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # 无颜色

# 清屏函数
clear_screen() {
    clear
}

# 显示标题
show_header() {
    echo -e "${BLUE}┌───────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│                                               │${NC}"
    echo -e "${BLUE}│${YELLOW}           脚本授权工具                      ${BLUE}│${NC}"
    echo -e "${BLUE}│                                               │${NC}"
    echo -e "${BLUE}└───────────────────────────────────────────────┘${NC}"
    echo ""
}

# 一键授权指定目录下所有sh脚本
authorize_all_scripts() {
    clear_screen
    show_header
    echo -e "${CYAN}一键授权脚本:${NC}"
    
    echo -e "${YELLOW}请输入要授权的目录路径 (默认为当前目录):${NC} "
    read dir_path
    
    # 如果未输入路径，使用当前目录
    dir_path=${dir_path:-$(pwd)}
    
    # 展开路径中的~符号
    dir_path="${dir_path/#\~/$HOME}"
    
    # 检查目录是否存在
    if [[ ! -d "$dir_path" ]]; then
        echo -e "\n${RED}错误: 目录不存在!${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
        return
    fi
    
    echo -e "\n${YELLOW}请选择授权模式:${NC}"
    echo -e "${CYAN}1. 仅授权.sh文件${NC}"
    echo -e "${CYAN}2. 授权所有可执行脚本文件${NC}"
    echo -e "${CYAN}3. 自定义文件模式${NC}"
    echo -e "\n${YELLOW}请选择 [1-3]:${NC} "
    read -n 1 mode_option
    
    file_pattern=""
    case $mode_option in
        1) file_pattern="*.sh" ;;
        2) file_pattern="*" ;;
        3)
            echo -e "\n${YELLOW}请输入文件模式 (例如: *.py *.js):${NC} "
            read custom_pattern
            file_pattern="$custom_pattern"
            ;;
        *)
            echo -e "\n${RED}无效选项!${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
            ;;
    esac
    
    echo -e "\n${YELLOW}是否递归处理子目录? (y/n)${NC} "
    read -n 1 recursive_option
    
    recursive_flag=""
    if [[ $recursive_option == "y" || $recursive_option == "Y" ]]; then
        recursive_flag="-R"
    fi
    
    echo -e "\n${YELLOW}请选择权限模式:${NC}"
    echo -e "${CYAN}1. 用户可执行 (u+x)${NC}"
    echo -e "${CYAN}2. 用户和组可执行 (ug+x)${NC}"
    echo -e "${CYAN}3. 所有人可执行 (a+x)${NC}"
    echo -e "${CYAN}4. 自定义权限${NC}"
    echo -e "\n${YELLOW}请选择 [1-4]:${NC} "
    read -n 1 perm_option
    
    perm_mode=""
    case $perm_option in
        1) perm_mode="u+x" ;;
        2) perm_mode="ug+x" ;;
        3) perm_mode="a+x" ;;
        4)
            echo -e "\n${YELLOW}请输入权限模式 (例如: 755):${NC} "
            read custom_perm
            perm_mode="$custom_perm"
            ;;
        *)
            echo -e "\n${RED}无效选项!${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
            ;;
    esac
    
    echo -e "\n${GREEN}正在授权脚本...${NC}"
    
    # 根据不同的权限模式和文件模式执行不同的命令
    if [[ $mode_option == "2" ]]; then
        # 对所有可执行脚本文件授权
        if [[ $perm_option == "4" ]]; then
            # 使用自定义数字权限模式
            find "$dir_path" $recursive_flag -type f -name "$file_pattern" -exec sh -c 'file "{}" | grep -q "script"' \; -exec chmod $perm_mode "{}" \;
        else
            # 使用符号权限模式
            find "$dir_path" $recursive_flag -type f -name "$file_pattern" -exec sh -c 'file "{}" | grep -q "script"' \; -exec chmod $perm_mode "{}" \;
        fi
    else
        # 对指定模式的文件授权
        if [[ $perm_option == "4" ]]; then
            # 使用自定义数字权限模式
            find "$dir_path" $recursive_flag -type f -name "$file_pattern" -exec chmod $perm_mode "{}" \;
        else
            # 使用符号权限模式
            find "$dir_path" $recursive_flag -type f -name "$file_pattern" -exec chmod $perm_mode "{}" \;
        fi
    fi
    
    # 统计授权的文件数量
    if [[ $mode_option == "2" ]]; then
        file_count=$(find "$dir_path" $recursive_flag -type f -name "$file_pattern" -exec sh -c 'file "{}" | grep -q "script"' \; -print | wc -l)
    else
        file_count=$(find "$dir_path" $recursive_flag -type f -name "$file_pattern" | wc -l)
    fi
    
    echo -e "\n${GREEN}授权完成! 共处理 $file_count 个文件.${NC}"
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 查看脚本权限
view_script_permissions() {
    clear_screen
    show_header
    echo -e "${CYAN}查看脚本权限:${NC}"
    
    echo -e "${YELLOW}请输入要查看的目录路径 (默认为当前目录):${NC} "
    read dir_path
    
    # 如果未输入路径，使用当前目录
    dir_path=${dir_path:-$(pwd)}
    
    # 展开路径中的~符号
    dir_path="${dir_path/#\~/$HOME}"
    
    # 检查目录是否存在
    if [[ ! -d "$dir_path" ]]; then
        echo -e "\n${RED}错误: 目录不存在!${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
        return
    fi
    
    echo -e "\n${YELLOW}请选择文件模式:${NC}"
    echo -e "${CYAN}1. 仅显示.sh文件${NC}"
    echo -e "${CYAN}2. 显示所有可执行脚本文件${NC}"
    echo -e "${CYAN}3. 自定义文件模式${NC}"
    echo -e "\n${YELLOW}请选择 [1-3]:${NC} "
    read -n 1 mode_option
    
    file_pattern=""
    case $mode_option in
        1) file_pattern="*.sh" ;;
        2) file_pattern="*" ;;
        3)
            echo -e "\n${YELLOW}请输入文件模式 (例如: *.py *.js):${NC} "
            read custom_pattern
            file_pattern="$custom_pattern"
            ;;
        *)
            echo -e "\n${RED}无效选项!${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
            ;;
    esac
    
    echo -e "\n${YELLOW}是否递归处理子目录? (y/n)${NC} "
    read -n 1 recursive_option
    
    recursive_flag=""
    if [[ $recursive_option == "y" || $recursive_option == "Y" ]]; then
        recursive_flag="-R"
    fi
    
    echo -e "\n${GREEN}脚本文件权限:${NC}"
    
    # 根据不同的文件模式显示权限
    if [[ $mode_option == "2" ]]; then
        # 显示所有可执行脚本文件的权限
        find "$dir_path" $recursive_flag -type f -name "$file_pattern" -exec sh -c 'file "{}" | grep -q "script" && echo -e "$(ls -la "{}" | awk "{print \$1, \$9}")"' \;
    else
        # 显示指定模式文件的权限
        find "$dir_path" $recursive_flag -type f -name "$file_pattern" -exec ls -la {} \; | awk '{print $1, $9}'
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 授权单个脚本
authorize_single_script() {
    clear_screen
    show_header
    echo -e "${CYAN}授权单个脚本:${NC}"
    
    echo -e "${YELLOW}请输入脚本文件路径:${NC} "
    read script_path
    
    # 展开路径中的~符号
    script_path="${script_path/#\~/$HOME}"
    
    # 检查文件是否存在
    if [[ ! -f "$script_path" ]]; then
        echo -e "\n${RED}错误: 文件不存在!${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
        return
    fi
    
    echo -e "\n${YELLOW}请选择权限模式:${NC}"
    echo -e "${CYAN}1. 用户可执行 (u+x)${NC}"
    echo -e "${CYAN}2. 用户和组可执行 (ug+x)${NC}"
    echo -e "${CYAN}3. 所有人可执行 (a+x)${NC}"
    echo -e "${CYAN}4. 自定义权限${NC}"
    echo -e "\n${YELLOW}请选择 [1-4]:${NC} "
    read -n 1 perm_option
    
    perm_mode=""
    case $perm_option in
        1) perm_mode="u+x" ;;
        2) perm_mode="ug+x" ;;
        3) perm_mode="a+x" ;;
        4)
            echo -e "\n${YELLOW}请输入权限模式 (例如: 755):${NC} "
            read custom_perm
            perm_mode="$custom_perm"
            ;;
        *)
            echo -e "\n${RED}无效选项!${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
            ;;
    esac
    
    echo -e "\n${GREEN}正在授权脚本...${NC}"
    
    # 执行授权
    chmod $perm_mode "$script_path"
    
    echo -e "\n${GREEN}授权完成!${NC}"
    echo -e "${YELLOW}文件: $script_path${NC}"
    echo -e "${YELLOW}权限: $(ls -la "$script_path" | awk '{print $1}')${NC}"
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 脚本授权菜单
script_auth_menu() {
    while true; do
        clear_screen
        show_header
        echo -e "${CYAN}脚本授权管理:${NC}"
        echo -e "${YELLOW}1.${NC} 一键授权所有脚本"
        echo -e "${YELLOW}2.${NC} 授权单个脚本"
        echo -e "${YELLOW}3.${NC} 查看脚本权限"
        echo -e "${YELLOW}0.${NC} 返回主菜单"
        echo ""
        echo -e "${CYAN}请输入选项 [0-3]:${NC} "
        
        read -n 1 option
        case $option in
            1) authorize_all_scripts ;;
            2) authorize_single_script ;;
            3) view_script_permissions ;;
            0) return ;;
            *) 
                echo -e "\n${RED}无效选项! 请重新选择.${NC}"
                sleep 1
                ;;
        esac
    done
}

# 导出函数
export -f script_auth_menu
export -f authorize_all_scripts
export -f authorize_single_script
export -f view_script_permissions
