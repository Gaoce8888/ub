#!/bin/bash

# 虚拟环境管理脚本
# 提供创建、进入、激活和退出虚拟环境的功能

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
    echo -e "${BLUE}│${YELLOW}           虚拟环境管理工具                    ${BLUE}│${NC}"
    echo -e "${BLUE}│                                               │${NC}"
    echo -e "${BLUE}└───────────────────────────────────────────────┘${NC}"
    echo ""
}

# 创建Python虚拟环境
create_python_venv() {
    clear_screen
    show_header
    echo -e "${CYAN}创建Python虚拟环境:${NC}"
    
    echo -e "${YELLOW}请输入虚拟环境目录路径:${NC} "
    read venv_path
    
    if [[ -z "$venv_path" ]]; then
        echo -e "\n${RED}错误: 路径不能为空!${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
        return
    fi
    
    # 展开路径中的~符号
    venv_path="${venv_path/#\~/$HOME}"
    
    # 创建目录（如果不存在）
    mkdir -p "$(dirname "$venv_path")"
    
    echo -e "\n${YELLOW}选择Python版本:${NC}"
    echo -e "${CYAN}1. Python 3 (默认)${NC}"
    echo -e "${CYAN}2. 指定Python解释器路径${NC}"
    echo -e "\n${YELLOW}请选择 [1-2]:${NC} "
    read -n 1 python_option
    
    python_cmd="python3"
    if [[ $python_option == "2" ]]; then
        echo -e "\n${YELLOW}请输入Python解释器路径:${NC} "
        read python_path
        python_cmd="$python_path"
    fi
    
    echo -e "\n${GREEN}正在创建虚拟环境...${NC}"
    $python_cmd -m venv "$venv_path"
    
    if [[ $? -eq 0 ]]; then
        echo -e "\n${GREEN}虚拟环境创建成功!${NC}"
        echo -e "${YELLOW}激活命令: source $venv_path/bin/activate${NC}"
    else
        echo -e "\n${RED}创建虚拟环境失败!${NC}"
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 创建Node.js虚拟环境(nvm)
create_nodejs_env() {
    clear_screen
    show_header
    echo -e "${CYAN}创建Node.js环境(使用nvm):${NC}"
    
    # 检查nvm是否已安装
    if ! command -v nvm &> /dev/null && [[ ! -f "$HOME/.nvm/nvm.sh" ]]; then
        echo -e "${YELLOW}nvm未安装，是否安装? (y/n)${NC} "
        read -n 1 install_nvm
        
        if [[ $install_nvm == "y" || $install_nvm == "Y" ]]; then
            echo -e "\n${GREEN}正在安装nvm...${NC}"
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
            
            # 加载nvm
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        else
            echo -e "\n${RED}无法继续，需要先安装nvm.${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
        fi
    else
        # 确保nvm命令可用
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
    
    echo -e "\n${YELLOW}请选择Node.js版本:${NC}"
    echo -e "${CYAN}1. 最新LTS版本 (推荐)${NC}"
    echo -e "${CYAN}2. 最新稳定版${NC}"
    echo -e "${CYAN}3. 指定版本${NC}"
    echo -e "\n${YELLOW}请选择 [1-3]:${NC} "
    read -n 1 node_option
    
    case $node_option in
        1)
            echo -e "\n${GREEN}正在安装Node.js LTS版本...${NC}"
            nvm install --lts
            ;;
        2)
            echo -e "\n${GREEN}正在安装Node.js最新稳定版...${NC}"
            nvm install node
            ;;
        3)
            echo -e "\n${YELLOW}请输入Node.js版本 (例如: 16.14.0):${NC} "
            read node_version
            echo -e "\n${GREEN}正在安装Node.js $node_version...${NC}"
            nvm install $node_version
            ;;
        *)
            echo -e "\n${RED}无效选项!${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
            ;;
    esac
    
    if [[ $? -eq 0 ]]; then
        echo -e "\n${GREEN}Node.js环境创建成功!${NC}"
        node_version=$(node -v)
        echo -e "${YELLOW}当前Node.js版本: $node_version${NC}"
        echo -e "${YELLOW}使用命令: nvm use <版本> 切换版本${NC}"
    else
        echo -e "\n${RED}创建Node.js环境失败!${NC}"
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 创建Conda虚拟环境
create_conda_env() {
    clear_screen
    show_header
    echo -e "${CYAN}创建Conda虚拟环境:${NC}"
    
    # 检查conda是否已安装
    if ! command -v conda &> /dev/null; then
        echo -e "${YELLOW}Conda未安装，是否安装Miniconda? (y/n)${NC} "
        read -n 1 install_conda
        
        if [[ $install_conda == "y" || $install_conda == "Y" ]]; then
            echo -e "\n${GREEN}正在下载Miniconda安装脚本...${NC}"
            wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
            
            echo -e "\n${GREEN}正在安装Miniconda...${NC}"
            bash /tmp/miniconda.sh -b -p $HOME/miniconda
            
            echo -e "\n${GREEN}正在配置Conda...${NC}"
            $HOME/miniconda/bin/conda init bash
            
            # 使conda命令可用于当前会话
            export PATH="$HOME/miniconda/bin:$PATH"
        else
            echo -e "\n${RED}无法继续，需要先安装Conda.${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
        fi
    fi
    
    echo -e "\n${YELLOW}请输入环境名称:${NC} "
    read env_name
    
    if [[ -z "$env_name" ]]; then
        echo -e "\n${RED}错误: 环境名称不能为空!${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
        return
    fi
    
    echo -e "\n${YELLOW}请选择Python版本:${NC}"
    echo -e "${CYAN}1. Python 3.9${NC}"
    echo -e "${CYAN}2. Python 3.10${NC}"
    echo -e "${CYAN}3. Python 3.11${NC}"
    echo -e "${CYAN}4. 不指定Python版本${NC}"
    echo -e "\n${YELLOW}请选择 [1-4]:${NC} "
    read -n 1 python_option
    
    python_version=""
    case $python_option in
        1) python_version="python=3.9" ;;
        2) python_version="python=3.10" ;;
        3) python_version="python=3.11" ;;
        4) python_version="" ;;
        *)
            echo -e "\n${RED}无效选项!${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
            ;;
    esac
    
    echo -e "\n${GREEN}正在创建Conda环境...${NC}"
    if [[ -z "$python_version" ]]; then
        conda create -y -n $env_name
    else
        conda create -y -n $env_name $python_version
    fi
    
    if [[ $? -eq 0 ]]; then
        echo -e "\n${GREEN}Conda环境创建成功!${NC}"
        echo -e "${YELLOW}激活命令: conda activate $env_name${NC}"
        echo -e "${YELLOW}退出命令: conda deactivate${NC}"
    else
        echo -e "\n${RED}创建Conda环境失败!${NC}"
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 创建Docker容器环境
create_docker_env() {
    clear_screen
    show_header
    echo -e "${CYAN}创建Docker容器环境:${NC}"
    
    # 检查Docker是否已安装
    if ! command -v docker &> /dev/null; then
        echo -e "${YELLOW}Docker未安装，是否安装? (y/n)${NC} "
        read -n 1 install_docker
        
        if [[ $install_docker == "y" || $install_docker == "Y" ]]; then
            echo -e "\n${GREEN}正在安装Docker...${NC}"
            curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
            sudo sh /tmp/get-docker.sh
            sudo usermod -aG docker $USER
            
            echo -e "\n${GREEN}Docker安装完成. 请注销并重新登录，或重启系统使组成员身份生效.${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
        else
            echo -e "\n${RED}无法继续，需要先安装Docker.${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
        fi
    fi
    
    echo -e "\n${YELLOW}请选择容器类型:${NC}"
    echo -e "${CYAN}1. Ubuntu${NC}"
    echo -e "${CYAN}2. Alpine${NC}"
    echo -e "${CYAN}3. Python${NC}"
    echo -e "${CYAN}4. Node.js${NC}"
    echo -e "${CYAN}5. 自定义镜像${NC}"
    echo -e "\n${YELLOW}请选择 [1-5]:${NC} "
    read -n 1 container_option
    
    image_name=""
    case $container_option in
        1) image_name="ubuntu:22.04" ;;
        2) image_name="alpine:latest" ;;
        3) image_name="python:3.11-slim" ;;
        4) image_name="node:18-alpine" ;;
        5)
            echo -e "\n${YELLOW}请输入镜像名称:${NC} "
            read custom_image
            image_name="$custom_image"
            ;;
        *)
            echo -e "\n${RED}无效选项!${NC}"
            echo -e "\n${CYAN}按任意键继续...${NC}"
            read -n 1
            return
            ;;
    esac
    
    echo -e "\n${YELLOW}请输入容器名称:${NC} "
    read container_name
    
    if [[ -z "$container_name" ]]; then
        echo -e "\n${RED}错误: 容器名称不能为空!${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
        return
    fi
    
    echo -e "\n${YELLOW}是否映射端口? (y/n)${NC} "
    read -n 1 map_port
    
    port_option=""
    if [[ $map_port == "y" || $map_port == "Y" ]]; then
        echo -e "\n${YELLOW}请输入端口映射 (例如: 8080:80):${NC} "
        read port_mapping
        port_option="-p $port_mapping"
    fi
    
    echo -e "\n${YELLOW}是否映射卷? (y/n)${NC} "
    read -n 1 map_volume
    
    volume_option=""
    if [[ $map_volume == "y" || $map_volume == "Y" ]]; then
        echo -e "\n${YELLOW}请输入卷映射 (例如: ./data:/data):${NC} "
        read volume_mapping
        volume_option="-v $volume_mapping"
    fi
    
    echo -e "\n${GREEN}正在创建Docker容器...${NC}"
    docker run -d --name $container_name $port_option $volume_option $image_name
    
    if [[ $? -eq 0 ]]; then
        echo -e "\n${GREEN}Docker容器创建成功!${NC}"
        echo -e "${YELLOW}进入容器命令: docker exec -it $container_name bash${NC}"
        echo -e "${YELLOW}停止容器命令: docker stop $container_name${NC}"
        echo -e "${YELLOW}启动容器命令: docker start $container_name${NC}"
    else
        echo -e "\n${RED}创建Docker容器失败!${NC}"
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 列出虚拟环境
list_virtual_envs() {
    clear_screen
    show_header
    echo -e "${CYAN}可用的虚拟环境:${NC}\n"
    
    # 列出Python虚拟环境
    echo -e "${YELLOW}Python虚拟环境:${NC}"
    find $HOME -name "pyvenv.cfg" -exec dirname {} \; 2>/dev/null | sort
    echo ""
    
    # 列出Conda环境
    if command -v conda &> /dev/null; then
        echo -e "${YELLOW}Conda环境:${NC}"
        conda env list
        echo ""
    fi
    
    # 列出Node.js环境(nvm)
    if [[ -d "$HOME/.nvm/versions/node" ]]; then
        echo -e "${YELLOW}Node.js环境(nvm):${NC}"
        ls -1 $HOME/.nvm/versions/node 2>/dev/null
        echo ""
    fi
    
    # 列出Docker容器
    if command -v docker &> /dev/null; then
        echo -e "${YELLOW}Docker容器:${NC}"
        docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
        echo ""
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 激活虚拟环境
activate_virtual_env() {
    clear_screen
    show_header
    echo -e "${CYAN}激活虚拟环境:${NC}"
    
    echo -e "\n${YELLOW}请选择环境类型:${NC}"
    echo -e "${CYAN}1. Python虚拟环境${NC}"
    echo -e "${CYAN}2. Conda环境${NC}"
    echo -e "${CYAN}3. Node.js环境(nvm)${NC}"
    echo -e "${CYAN}4. Docker容器${NC}"
    echo -e "\n${YELLOW}请选择 [1-4]:${NC} "
    read -n 1 env_type
    
    case $env_type in
        1)
            echo -e "\n${YELLOW}请输入Python虚拟环境路径:${NC} "
            read venv_path
            
            # 展开路径中的~符号
            venv_path="${venv_path/#\~/$HOME}"
            
            if [[ ! -f "$venv_path/bin/activate" ]]; then
                echo -e "\n${RED}错误: 无效的虚拟环境路径!${NC}"
            else
                echo -e "\n${GREEN}激活命令: source $venv_path/bin/activate${NC}"
                echo -e "${YELLOW}请在终端中执行上述命令来激活环境${NC}"
                echo -e "${YELLOW}退出命令: deactivate${NC}"
            fi
            ;;
        2)
            if ! command -v conda &> /dev/null; then
                echo -e "\n${RED}错误: Conda未安装!${NC}"
            else
                echo -e "\n${YELLOW}请输入Conda环境名称:${NC} "
                read conda_env
                
                # 检查环境是否存在
                if ! conda env list | grep -q "$conda_env"; then
                    echo -e "\n${RED}错误: Conda环境 '$conda_env' 不存在!${NC}"
                else
                    echo -e "\n${GREEN}激活命令: conda activate $conda_env${NC}"
                    echo -e "${YELLOW}请在终端中执行上述命令来激活环境${NC}"
                    echo -e "${YELLOW}退出命令: conda deactivate${NC}"
                fi
            fi
            ;;
        3)
            if [[ ! -d "$HOME/.nvm" ]]; then
                echo -e "\n${RED}错误: nvm未安装!${NC}"
            else
                echo -e "\n${YELLOW}请输入Node.js版本:${NC} "
                read node_version
                
                # 检查版本是否存在
                if [[ ! -d "$HOME/.nvm/versions/node/$node_version" ]]; then
                    echo -e "\n${RED}错误: Node.js版本 '$node_version' 不存在!${NC}"
                else
                    echo -e "\n${GREEN}激活命令: nvm use $node_version${NC}"
                    echo -e "${YELLOW}请在终端中执行上述命令来激活环境${NC}"
                fi
            fi
            ;;
        4)
            if ! command -v docker &> /dev/null; then
                echo -e "\n${RED}错误: Docker未安装!${NC}"
            else
                echo -e "\n${YELLOW}请输入容器名称:${NC} "
                read container_name
                
                # 检查容器是否存在
                if ! docker ps -a --format "{{.Names}}" | grep -q "^$container_name$"; then
                    echo -e "\n${RED}错误: Docker容器 '$container_name' 不存在!${NC}"
                else
                    echo -e "\n${GREEN}进入容器命令: docker exec -it $container_name bash${NC}"
                    echo -e "${YELLOW}请在终端中执行上述命令来进入容器${NC}"
                    echo -e "${YELLOW}退出命令: exit${NC}"
                fi
            fi
            ;;
        *)
            echo -e "\n${RED}无效选项!${NC}"
            ;;
    esac
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 退出虚拟环境
exit_virtual_env() {
    clear_screen
    show_header
    echo -e "${CYAN}退出虚拟环境:${NC}"
    
    echo -e "\n${YELLOW}请选择环境类型:${NC}"
    echo -e "${CYAN}1. Python虚拟环境${NC}"
    echo -e "${CYAN}2. Conda环境${NC}"
    echo -e "${CYAN}3. Docker容器${NC}"
    echo -e "\n${YELLOW}请选择 [1-3]:${NC} "
    read -n 1 env_type
    
    case $env_type in
        1)
            echo -e "\n${GREEN}退出命令: deactivate${NC}"
            echo -e "${YELLOW}请在终端中执行上述命令来退出Python虚拟环境${NC}"
            ;;
        2)
            echo -e "\n${GREEN}退出命令: conda deactivate${NC}"
            echo -e "${YELLOW}请在终端中执行上述命令来退出Conda环境${NC}"
            ;;
        3)
            echo -e "\n${GREEN}退出命令: exit${NC}"
            echo -e "${YELLOW}请在终端中执行上述命令来退出Docker容器${NC}"
            ;;
        *)
            echo -e "\n${RED}无效选项!${NC}"
            ;;
    esac
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 虚拟环境管理菜单
virtual_env_menu() {
    while true; do
        clear_screen
        show_header
        echo -e "${CYAN}虚拟环境管理:${NC}"
        echo -e "${YELLOW}1.${NC} 创建Python虚拟环境"
        echo -e "${YELLOW}2.${NC} 创建Node.js环境(nvm)"
        echo -e "${YELLOW}3.${NC} 创建Conda虚拟环境"
        echo -e "${YELLOW}4.${NC} 创建Docker容器环境"
        echo -e "${YELLOW}5.${NC} 列出虚拟环境"
        echo -e "${YELLOW}6.${NC} 激活虚拟环境"
        echo -e "${YELLOW}7.${NC} 退出虚拟环境"
        echo -e "${YELLOW}0.${NC} 返回主菜单"
        echo ""
        echo -e "${CYAN}请输入选项 [0-7]:${NC} "
        
        read -n 1 option
        case $option in
            1) create_python_venv ;;
            2) create_nodejs_env ;;
            3) create_conda_env ;;
            4) create_docker_env ;;
            5) list_virtual_envs ;;
            6) activate_virtual_env ;;
            7) exit_virtual_env ;;
            0) return ;;
            *) 
                echo -e "\n${RED}无效选项! 请重新选择.${NC}"
                sleep 1
                ;;
        esac
    done
}

# 导出函数
export -f virtual_env_menu
export -f create_python_venv
export -f create_nodejs_env
export -f create_conda_env
export -f create_docker_env
export -f list_virtual_envs
export -f activate_virtual_env
export -f exit_virtual_env
