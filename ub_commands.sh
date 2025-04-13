#!/bin/bash

# Ubuntu 命令大全脚本 - 项目部署环境专用
# 适用于 Ubuntu 22.04
# 使用方法: 按数字键选择对应的命令或功能

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
    echo -e "${BLUE}│${YELLOW}           Ubuntu 命令大全 - 项目部署专用        ${BLUE}│${NC}"
    echo -e "${BLUE}│${GREEN}                   v1.0                      ${BLUE}│${NC}"
    echo -e "${BLUE}│                                               │${NC}"
    echo -e "${BLUE}└───────────────────────────────────────────────┘${NC}"
    echo ""
}

# 显示主菜单
show_main_menu() {
    clear_screen
    show_header
    echo -e "${CYAN}请选择命令类别:${NC}"
    echo -e "${YELLOW}1.${NC} 系统信息与管理"
    echo -e "${YELLOW}2.${NC} 软件包管理"
    echo -e "${YELLOW}3.${NC} 文件与目录操作"
    echo -e "${YELLOW}4.${NC} 网络工具"
    echo -e "${YELLOW}5.${NC} 项目部署工具"
    echo -e "${YELLOW}6.${NC} 开发环境配置"
    echo -e "${YELLOW}7.${NC} Docker 相关命令"
    echo -e "${YELLOW}8.${NC} 数据库管理"
    echo -e "${YELLOW}9.${NC} 自定义命令"
    echo -e "${YELLOW}V.${NC} 虚拟环境管理"
    echo -e "${YELLOW}A.${NC} 脚本授权工具"
    echo -e "${YELLOW}P.${NC} 预设选项管理"
    echo -e "${YELLOW}0.${NC} 退出"
    echo ""
    echo -e "${CYAN}请输入选项 [0-9 或 V/A/P]:${NC} "
}

# 系统信息与管理菜单
system_info_menu() {
    clear_screen
    show_header
    echo -e "${CYAN}系统信息与管理:${NC}"
    echo -e "${YELLOW}1.${NC} 显示系统信息 (uname -a)"
    echo -e "${YELLOW}2.${NC} 显示磁盘使用情况 (df -h)"
    echo -e "${YELLOW}3.${NC} 显示内存使用情况 (free -h)"
    echo -e "${YELLOW}4.${NC} 显示系统进程 (ps aux)"
    echo -e "${YELLOW}5.${NC} 显示系统负载 (uptime)"
    echo -e "${YELLOW}6.${NC} 显示系统服务状态 (systemctl list-units --type=service)"
    echo -e "${YELLOW}7.${NC} 更新系统 (apt update && apt upgrade -y)"
    echo -e "${YELLOW}8.${NC} 清理系统 (apt autoremove -y && apt autoclean)"
    echo -e "${YELLOW}9.${NC} 重启系统 (reboot)"
    echo -e "${YELLOW}0.${NC} 返回主菜单"
    echo ""
    echo -e "${CYAN}请输入选项 [0-9]:${NC} "
    
    read -n 1 option
    case $option in
        1) execute_command "uname -a" ;;
        2) execute_command "df -h" ;;
        3) execute_command "free -h" ;;
        4) execute_command "ps aux" ;;
        5) execute_command "uptime" ;;
        6) execute_command "systemctl list-units --type=service" ;;
        7) execute_command "sudo apt update && sudo apt upgrade -y" ;;
        8) execute_command "sudo apt autoremove -y && sudo apt autoclean" ;;
        9) execute_command "sudo reboot" ;;
        0) show_main_menu ;;
        *) invalid_option ;;
    esac
}

# 软件包管理菜单
package_management_menu() {
    clear_screen
    show_header
    echo -e "${CYAN}软件包管理:${NC}"
    echo -e "${YELLOW}1.${NC} 更新软件包列表 (apt update)"
    echo -e "${YELLOW}2.${NC} 安装软件包 (apt install)"
    echo -e "${YELLOW}3.${NC} 移除软件包 (apt remove)"
    echo -e "${YELLOW}4.${NC} 搜索软件包 (apt search)"
    echo -e "${YELLOW}5.${NC} 显示软件包信息 (apt show)"
    echo -e "${YELLOW}6.${NC} 列出已安装的软件包 (apt list --installed)"
    echo -e "${YELLOW}7.${NC} 添加 PPA 仓库 (add-apt-repository)"
    echo -e "${YELLOW}8.${NC} 安装 .deb 文件 (dpkg -i)"
    echo -e "${YELLOW}9.${NC} 修复依赖关系 (apt --fix-broken install)"
    echo -e "${YELLOW}0.${NC} 返回主菜单"
    echo ""
    echo -e "${CYAN}请输入选项 [0-9]:${NC} "
    
    read -n 1 option
    case $option in
        1) execute_command "sudo apt update" ;;
        2) 
            echo -e "\n${CYAN}请输入要安装的软件包名称:${NC} "
            read package
            execute_command "sudo apt install $package -y"
            ;;
        3) 
            echo -e "\n${CYAN}请输入要移除的软件包名称:${NC} "
            read package
            execute_command "sudo apt remove $package -y"
            ;;
        4) 
            echo -e "\n${CYAN}请输入要搜索的关键词:${NC} "
            read keyword
            execute_command "apt search $keyword"
            ;;
        5) 
            echo -e "\n${CYAN}请输入要显示信息的软件包名称:${NC} "
            read package
            execute_command "apt show $package"
            ;;
        6) execute_command "apt list --installed" ;;
        7) 
            echo -e "\n${CYAN}请输入要添加的 PPA 仓库:${NC} "
            read ppa
            execute_command "sudo add-apt-repository $ppa -y"
            ;;
        8) 
            echo -e "\n${CYAN}请输入 .deb 文件的路径:${NC} "
            read deb_file
            execute_command "sudo dpkg -i $deb_file"
            ;;
        9) execute_command "sudo apt --fix-broken install -y" ;;
        0) show_main_menu ;;
        *) invalid_option ;;
    esac
}

# 文件与目录操作菜单
file_operations_menu() {
    clear_screen
    show_header
    echo -e "${CYAN}文件与目录操作:${NC}"
    echo -e "${YELLOW}1.${NC} 列出目录内容 (ls -la)"
    echo -e "${YELLOW}2.${NC} 创建目录 (mkdir)"
    echo -e "${YELLOW}3.${NC} 删除目录 (rmdir/rm -rf)"
    echo -e "${YELLOW}4.${NC} 复制文件/目录 (cp)"
    echo -e "${YELLOW}5.${NC} 移动/重命名文件/目录 (mv)"
    echo -e "${YELLOW}6.${NC} 查找文件 (find)"
    echo -e "${YELLOW}7.${NC} 查看文件内容 (cat/less)"
    echo -e "${YELLOW}8.${NC} 编辑文件 (nano/vim)"
    echo -e "${YELLOW}9.${NC} 修改文件权限 (chmod)"
    echo -e "${YELLOW}0.${NC} 返回主菜单"
    echo ""
    echo -e "${CYAN}请输入选项 [0-9]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入要列出内容的目录路径 (默认为当前目录):${NC} "
            read dir_path
            dir_path=${dir_path:-$(pwd)}
            execute_command "ls -la $dir_path"
            ;;
        2) 
            echo -e "\n${CYAN}请输入要创建的目录名称:${NC} "
            read dir_name
            execute_command "mkdir -p $dir_name"
            ;;
        3) 
            echo -e "\n${CYAN}请输入要删除的目录路径:${NC} "
            read dir_path
            echo -e "${RED}警告: 确定要删除 $dir_path 吗? (y/n)${NC} "
            read -n 1 confirm
            if [[ $confirm == "y" || $confirm == "Y" ]]; then
                execute_command "rm -rf $dir_path"
            fi
            ;;
        4) 
            echo -e "\n${CYAN}请输入源文件/目录路径:${NC} "
            read source
            echo -e "${CYAN}请输入目标路径:${NC} "
            read destination
            execute_command "cp -r $source $destination"
            ;;
        5) 
            echo -e "\n${CYAN}请输入源文件/目录路径:${NC} "
            read source
            echo -e "${CYAN}请输入目标路径:${NC} "
            read destination
            execute_command "mv $source $destination"
            ;;
        6) 
            echo -e "\n${CYAN}请输入要搜索的目录:${NC} "
            read search_dir
            echo -e "${CYAN}请输入文件名或模式:${NC} "
            read pattern
            execute_command "find $search_dir -name \"$pattern\""
            ;;
        7) 
            echo -e "\n${CYAN}请输入要查看的文件路径:${NC} "
            read file_path
            execute_command "less $file_path"
            ;;
        8) 
            echo -e "\n${CYAN}请选择编辑器: 1) nano 2) vim${NC} "
            read -n 1 editor_choice
            echo -e "\n${CYAN}请输入要编辑的文件路径:${NC} "
            read file_path
            if [[ $editor_choice == "1" ]]; then
                execute_command "nano $file_path"
            else
                execute_command "vim $file_path"
            fi
            ;;
        9) 
            echo -e "\n${CYAN}请输入要修改权限的文件/目录路径:${NC} "
            read file_path
            echo -e "${CYAN}请输入权限模式 (例如: 755):${NC} "
            read permission
            execute_command "chmod $permission $file_path"
            ;;
        0) show_main_menu ;;
        *) invalid_option ;;
    esac
}

# 网络工具菜单
network_tools_menu() {
    clear_screen
    show_header
    echo -e "${CYAN}网络工具:${NC}"
    echo -e "${YELLOW}1.${NC} 显示网络接口 (ip addr)"
    echo -e "${YELLOW}2.${NC} 测试网络连接 (ping)"
    echo -e "${YELLOW}3.${NC} 查看路由表 (ip route)"
    echo -e "${YELLOW}4.${NC} 查看开放端口 (netstat -tuln)"
    echo -e "${YELLOW}5.${NC} 下载文件 (wget/curl)"
    echo -e "${YELLOW}6.${NC} 查看 DNS 配置 (cat /etc/resolv.conf)"
    echo -e "${YELLOW}7.${NC} 配置防火墙 (ufw)"
    echo -e "${YELLOW}8.${NC} 网络流量监控 (iftop)"
    echo -e "${YELLOW}9.${NC} SSH 连接 (ssh)"
    echo -e "${YELLOW}0.${NC} 返回主菜单"
    echo ""
    echo -e "${CYAN}请输入选项 [0-9]:${NC} "
    
    read -n 1 option
    case $option in
        1) execute_command "ip addr" ;;
        2) 
            echo -e "\n${CYAN}请输入要 ping 的主机名或 IP 地址:${NC} "
            read host
            execute_command "ping -c 4 $host"
            ;;
        3) execute_command "ip route" ;;
        4) execute_command "netstat -tuln" ;;
        5) 
            echo -e "\n${CYAN}选择下载工具: 1) wget 2) curl${NC} "
            read -n 1 tool_choice
            echo -e "\n${CYAN}请输入要下载的 URL:${NC} "
            read url
            if [[ $tool_choice == "1" ]]; then
                execute_command "wget $url"
            else
                execute_command "curl -O $url"
            fi
            ;;
        6) execute_command "cat /etc/resolv.conf" ;;
        7) 
            echo -e "\n${CYAN}防火墙操作: 1) 启用 2) 禁用 3) 状态 4) 添加规则${NC} "
            read -n 1 ufw_option
            case $ufw_option in
                1) execute_command "sudo ufw enable" ;;
                2) execute_command "sudo ufw disable" ;;
                3) execute_command "sudo ufw status verbose" ;;
                4) 
                    echo -e "\n${CYAN}请输入端口号:${NC} "
                    read port
                    echo -e "${CYAN}请输入协议 (tcp/udp):${NC} "
                    read protocol
                    execute_command "sudo ufw allow $port/$protocol"
                    ;;
                *) invalid_option ;;
            esac
            ;;
        8) 
            echo -e "\n${CYAN}安装 iftop (如果尚未安装)...${NC}"
            execute_command "sudo apt install iftop -y && sudo iftop"
            ;;
        9) 
            echo -e "\n${CYAN}请输入用户名:${NC} "
            read username
            echo -e "${CYAN}请输入主机名或 IP 地址:${NC} "
            read host
            execute_command "ssh $username@$host"
            ;;
        0) show_main_menu ;;
        *) invalid_option ;;
    esac
}

# 项目部署工具菜单
deployment_tools_menu() {
    clear_screen
    show_header
    echo -e "${CYAN}项目部署工具:${NC}"
    echo -e "${YELLOW}1.${NC} 克隆 Git 仓库 (git clone)"
    echo -e "${YELLOW}2.${NC} 部署 Node.js 应用"
    echo -e "${YELLOW}3.${NC} 部署 Python 应用"
    echo -e "${YELLOW}4.${NC} 部署 PHP 应用"
    echo -e "${YELLOW}5.${NC} 部署 Java 应用"
    echo -e "${YELLOW}6.${NC} 配置 Nginx 服务器"
    echo -e "${YELLOW}7.${NC} 配置 Apache 服务器"
    echo -e "${YELLOW}8.${NC} 设置 SSL 证书 (Let's Encrypt)"
    echo -e "${YELLOW}9.${NC} 部署 Docker 容器"
    echo -e "${YELLOW}0.${NC} 返回主菜单"
    echo ""
    echo -e "${CYAN}请输入选项 [0-9]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入 Git 仓库 URL:${NC} "
            read repo_url
            echo -e "${CYAN}请输入目标目录 (默认为当前目录):${NC} "
            read target_dir
            target_dir=${target_dir:-$(pwd)}
            execute_command "git clone $repo_url $target_dir"
            ;;
        2) deploy_nodejs_app ;;
        3) deploy_python_app ;;
        4) deploy_php_app ;;
        5) deploy_java_app ;;
        6) configure_nginx ;;
        7) configure_apache ;;
        8) setup_ssl_certificate ;;
        9) deploy_docker_container ;;
        0) show_main_menu ;;
        *) invalid_option ;;
    esac
}

# 开发环境配置菜单
dev_environment_menu() {
    clear_screen
    show_header
    echo -e "${CYAN}开发环境配置:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 Node.js 环境"
    echo -e "${YELLOW}2.${NC} 安装 Python 环境"
    echo -e "${YELLOW}3.${NC} 安装 Java 环境"
    echo -e "${YELLOW}4.${NC} 安装 PHP 环境"
    echo -e "${YELLOW}5.${NC} 安装 Go 环境"
    echo -e "${YELLOW}6.${NC} 安装 Ruby 环境"
    echo -e "${YELLOW}7.${NC} 安装开发工具 (Git, VSCode, etc.)"
    echo -e "${YELLOW}8.${NC} 配置 SSH 密钥"
    echo -e "${YELLOW}9.${NC} 安装数据库 (MySQL, PostgreSQL, MongoDB)"
    echo -e "${YELLOW}0.${NC} 返回主菜单"
    echo ""
    echo -e "${CYAN}请输入选项 [0-9]:${NC} "
    
    read -n 1 option
    case $option in
        1) install_nodejs ;;
        2) install_python ;;
        3) install_java ;;
        4) install_php ;;
        5) install_go ;;
        6) install_ruby ;;
        7) install_dev_tools ;;
        8) configure_ssh_keys ;;
        9) install_database ;;
        0) show_main_menu ;;
        *) invalid_option ;;
    esac
}

# Docker 相关命令菜单
docker_commands_menu() {
    clear_screen
    show_header
    echo -e "${CYAN}Docker 相关命令:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 Docker"
    echo -e "${YELLOW}2.${NC} 列出 Docker 容器 (docker ps)"
    echo -e "${YELLOW}3.${NC} 列出 Docker 镜像 (docker images)"
    echo -e "${YELLOW}4.${NC} 拉取 Docker 镜像 (docker pull)"
    echo -e "${YELLOW}5.${NC} 运行 Docker 容器 (docker run)"
    echo -e "${YELLOW}6.${NC} 停止 Docker 容器 (docker stop)"
    echo -e "${YELLOW}7.${NC} 删除 Docker 容器 (docker rm)"
    echo -e "${YELLOW}8.${NC} 删除 Docker 镜像 (docker rmi)"
    echo -e "${YELLOW}9.${NC} 安装 Docker Compose"
    echo -e "${YELLOW}0.${NC} 返回主菜单"
    echo ""
    echo -e "${CYAN}请输入选项 [0-9]:${NC} "
    
    read -n 1 option
    case $option in
        1) install_docker ;;
        2) execute_command "docker ps -a" ;;
        3) execute_command "docker images" ;;
        4) 
            echo -e "\n${CYAN}请输入要拉取的 Docker 镜像名称:${NC} "
            read image_name
            execute_command "docker pull $image_name"
            ;;
        5) 
            echo -e "\n${CYAN}请输入要运行的 Docker 镜像名称:${NC} "
            read image_name
            echo -e "${CYAN}请输入容器名称 (可选):${NC} "
            read container_name
            container_option=""
            if [[ -n "$container_name" ]]; then
                container_option="--name $container_name"
            fi
            echo -e "${CYAN}请输入端口映射 (例如: 8080:80) (可选):${NC} "
            read port_mapping
            port_option=""
            if [[ -n "$port_mapping" ]]; then
                port_option="-p $port_mapping"
            fi
            execute_command "docker run -d $container_option $port_option $image_name"
            ;;
        6) 
            echo -e "\n${CYAN}请输入要停止的容器 ID 或名称:${NC} "
            read container_id
            execute_command "docker stop $container_id"
            ;;
        7) 
            echo -e "\n${CYAN}请输入要删除的容器 ID 或名称:${NC} "
            read container_id
            execute_command "docker rm $container_id"
            ;;
        8) 
            echo -e "\n${CYAN}请输入要删除的镜像 ID 或名称:${NC} "
            read image_id
            execute_command "docker rmi $image_id"
            ;;
        9) install_docker_compose ;;
        0) show_main_menu ;;
        *) invalid_option ;;
    esac
}

# 数据库管理菜单
database_management_menu() {
    clear_screen
    show_header
    echo -e "${CYAN}数据库管理:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 MySQL"
    echo -e "${YELLOW}2.${NC} 安装 PostgreSQL"
    echo -e "${YELLOW}3.${NC} 安装 MongoDB"
    echo -e "${YELLOW}4.${NC} 安装 Redis"
    echo -e "${YELLOW}5.${NC} MySQL 操作"
    echo -e "${YELLOW}6.${NC} PostgreSQL 操作"
    echo -e "${YELLOW}7.${NC} MongoDB 操作"
    echo -e "${YELLOW}8.${NC} Redis 操作"
    echo -e "${YELLOW}9.${NC} 数据库备份与恢复"
    echo -e "${YELLOW}0.${NC} 返回主菜单"
    echo ""
    echo -e "${CYAN}请输入选项 [0-9]:${NC} "
    
    read -n 1 option
    case $option in
        1) install_mysql ;;
        2) install_postgresql ;;
        3) install_mongodb ;;
        4) install_redis ;;
        5) mysql_operations ;;
        6) postgresql_operations ;;
        7) mongodb_operations ;;
        8) redis_operations ;;
        9) database_backup_restore ;;
        0) show_main_menu ;;
        *) invalid_option ;;
    esac
}

# 自定义命令菜单
custom_commands_menu() {
    clear_screen
    show_header
    echo -e "${CYAN}自定义命令:${NC}"
    echo -e "${YELLOW}1.${NC} 查看已保存的自定义命令"
    echo -e "${YELLOW}2.${NC} 添加新的自定义命令"
    echo -e "${YELLOW}3.${NC} 编辑自定义命令"
    echo -e "${YELLOW}4.${NC} 删除自定义命令"
    echo -e "${YELLOW}5.${NC} 执行自定义命令"
    echo -e "${YELLOW}0.${NC} 返回主菜单"
    echo ""
    echo -e "${CYAN}请输入选项 [0-5]:${NC} "
    
    read -n 1 option
    case $option in
        1) view_custom_commands ;;
        2) add_custom_command ;;
        3) edit_custom_command ;;
        4) delete_custom_command ;;
        5) execute_custom_command ;;
        0) show_main_menu ;;
        *) invalid_option ;;
    esac
}

# 执行命令函数
execute_command() {
    echo -e "\n${GREEN}执行命令: ${YELLOW}$1${NC}\n"
    eval $1
    echo -e "\n${GREEN}命令执行完成.${NC}"
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 无效选项提示
invalid_option() {
    echo -e "\n${RED}无效选项! 请重新选择.${NC}"
    sleep 1
}

# 安装 Node.js 环境
install_nodejs() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 Node.js 环境:${NC}"
    echo -e "${YELLOW}1.${NC} 使用 apt 安装 (默认版本)"
    echo -e "${YELLOW}2.${NC} 使用 NVM 安装 (推荐)"
    echo -e "${YELLOW}3.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装方式 [1-3]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y nodejs npm"
            ;;
        2) 
            execute_command "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash"
            echo -e "\n${GREEN}NVM 安装完成. 请关闭并重新打开终端, 或运行 'source ~/.bashrc' 使其生效.${NC}"
            echo -e "\n${CYAN}安装 Node.js 最新 LTS 版本...${NC}"
            execute_command "export NVM_DIR=\"$HOME/.nvm\" && [ -s \"$NVM_DIR/nvm.sh\" ] && \\. \"$NVM_DIR/nvm.sh\" && nvm install --lts"
            ;;
        3) dev_environment_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 Python 环境
install_python() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 Python 环境:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 Python 3 (默认版本)"
    echo -e "${YELLOW}2.${NC} 安装 Python 开发工具 (pip, venv, etc.)"
    echo -e "${YELLOW}3.${NC} 安装 Anaconda/Miniconda"
    echo -e "${YELLOW}4.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装选项 [1-4]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y python3 python3-pip"
            ;;
        2) 
            execute_command "sudo apt update && sudo apt install -y python3-dev python3-pip python3-venv python3-setuptools build-essential"
            ;;
        3) 
            echo -e "\n${CYAN}选择版本: 1) Anaconda 2) Miniconda${NC} "
            read -n 1 conda_option
            if [[ $conda_option == "1" ]]; then
                execute_command "wget https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh -O ~/anaconda.sh && bash ~/anaconda.sh -b && rm ~/anaconda.sh"
            else
                execute_command "wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && bash ~/miniconda.sh -b && rm ~/miniconda.sh"
            fi
            echo -e "\n${GREEN}安装完成. 请关闭并重新打开终端, 或运行 'source ~/.bashrc' 使其生效.${NC}"
            ;;
        4) dev_environment_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 Java 环境
install_java() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 Java 环境:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 OpenJDK 11"
    echo -e "${YELLOW}2.${NC} 安装 OpenJDK 17"
    echo -e "${YELLOW}3.${NC} 安装 OpenJDK 21"
    echo -e "${YELLOW}4.${NC} 安装 Maven"
    echo -e "${YELLOW}5.${NC} 安装 Gradle"
    echo -e "${YELLOW}6.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装选项 [1-6]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y openjdk-11-jdk"
            ;;
        2) 
            execute_command "sudo apt update && sudo apt install -y openjdk-17-jdk"
            ;;
        3) 
            execute_command "sudo apt update && sudo apt install -y openjdk-21-jdk"
            ;;
        4) 
            execute_command "sudo apt update && sudo apt install -y maven"
            ;;
        5) 
            execute_command "sudo apt update && sudo apt install -y gradle"
            ;;
        6) dev_environment_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 PHP 环境
install_php() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 PHP 环境:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 PHP 8.1 (默认版本)"
    echo -e "${YELLOW}2.${NC} 安装 PHP 扩展"
    echo -e "${YELLOW}3.${NC} 安装 Composer"
    echo -e "${YELLOW}4.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装选项 [1-4]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y php8.1 php8.1-cli php8.1-common php8.1-curl php8.1-mbstring php8.1-mysql php8.1-xml php8.1-zip"
            ;;
        2) 
            echo -e "\n${CYAN}请输入要安装的 PHP 扩展 (例如: gd mysqli pdo_mysql):${NC} "
            read extensions
            execute_command "sudo apt update && sudo apt install -y php8.1-$extensions"
            ;;
        3) 
            execute_command "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\" && php composer-setup.php && php -r \"unlink('composer-setup.php');\" && sudo mv composer.phar /usr/local/bin/composer"
            ;;
        4) dev_environment_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 Go 环境
install_go() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 Go 环境:${NC}"
    echo -e "${YELLOW}1.${NC} 使用 apt 安装 (默认版本)"
    echo -e "${YELLOW}2.${NC} 从官方网站下载安装 (最新版本)"
    echo -e "${YELLOW}3.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装方式 [1-3]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y golang-go"
            ;;
        2) 
            execute_command "wget https://go.dev/dl/go1.20.3.linux-amd64.tar.gz && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.3.linux-amd64.tar.gz && rm go1.20.3.linux-amd64.tar.gz"
            echo -e "\n${GREEN}Go 安装完成. 请将以下行添加到您的 ~/.bashrc 文件中:${NC}"
            echo -e "${YELLOW}export PATH=\$PATH:/usr/local/go/bin${NC}"
            ;;
        3) dev_environment_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 Ruby 环境
install_ruby() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 Ruby 环境:${NC}"
    echo -e "${YELLOW}1.${NC} 使用 apt 安装 (默认版本)"
    echo -e "${YELLOW}2.${NC} 使用 RVM 安装 (推荐)"
    echo -e "${YELLOW}3.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装方式 [1-3]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y ruby-full"
            ;;
        2) 
            execute_command "gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && curl -sSL https://get.rvm.io | bash -s stable --ruby"
            echo -e "\n${GREEN}RVM 安装完成. 请关闭并重新打开终端, 或运行 'source ~/.rvm/scripts/rvm' 使其生效.${NC}"
            ;;
        3) dev_environment_menu ;;
        *) invalid_option ;;
    esac
}

# 安装开发工具
install_dev_tools() {
    clear_screen
    show_header
    echo -e "${CYAN}安装开发工具:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 Git"
    echo -e "${YELLOW}2.${NC} 安装 VSCode"
    echo -e "${YELLOW}3.${NC} 安装 Sublime Text"
    echo -e "${YELLOW}4.${NC} 安装 Vim 和配置"
    echo -e "${YELLOW}5.${NC} 安装开发必备工具集"
    echo -e "${YELLOW}6.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装选项 [1-6]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y git"
            ;;
        2) 
            execute_command "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && sudo sh -c 'echo \"deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main\" > /etc/apt/sources.list.d/vscode.list' && rm -f packages.microsoft.gpg && sudo apt update && sudo apt install -y code"
            ;;
        3) 
            execute_command "wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && sudo apt-get install -y apt-transport-https && echo \"deb https://download.sublimetext.com/ apt/stable/\" | sudo tee /etc/apt/sources.list.d/sublime-text.list && sudo apt update && sudo apt install -y sublime-text"
            ;;
        4) 
            execute_command "sudo apt update && sudo apt install -y vim && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
            ;;
        5) 
            execute_command "sudo apt update && sudo apt install -y build-essential git curl wget unzip zip gcc g++ make cmake pkg-config libssl-dev"
            ;;
        6) dev_environment_menu ;;
        *) invalid_option ;;
    esac
}

# 配置 SSH 密钥
configure_ssh_keys() {
    clear_screen
    show_header
    echo -e "${CYAN}配置 SSH 密钥:${NC}"
    echo -e "${YELLOW}1.${NC} 生成新的 SSH 密钥"
    echo -e "${YELLOW}2.${NC} 查看现有 SSH 密钥"
    echo -e "${YELLOW}3.${NC} 添加 SSH 密钥到 SSH 代理"
    echo -e "${YELLOW}4.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择操作 [1-4]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入您的电子邮件地址:${NC} "
            read email
            execute_command "ssh-keygen -t ed25519 -C \"$email\""
            ;;
        2) 
            execute_command "ls -la ~/.ssh"
            ;;
        3) 
            execute_command "eval \"$(ssh-agent -s)\" && ssh-add ~/.ssh/id_ed25519"
            ;;
        4) dev_environment_menu ;;
        *) invalid_option ;;
    esac
}

# 安装数据库
install_database() {
    clear_screen
    show_header
    echo -e "${CYAN}安装数据库:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 MySQL"
    echo -e "${YELLOW}2.${NC} 安装 PostgreSQL"
    echo -e "${YELLOW}3.${NC} 安装 MongoDB"
    echo -e "${YELLOW}4.${NC} 安装 Redis"
    echo -e "${YELLOW}5.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择要安装的数据库 [1-5]:${NC} "
    
    read -n 1 option
    case $option in
        1) install_mysql ;;
        2) install_postgresql ;;
        3) install_mongodb ;;
        4) install_redis ;;
        5) dev_environment_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 MySQL
install_mysql() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 MySQL:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 MySQL Server"
    echo -e "${YELLOW}2.${NC} 安装 MySQL Client"
    echo -e "${YELLOW}3.${NC} 安装 MySQL Workbench"
    echo -e "${YELLOW}4.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装选项 [1-4]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y mysql-server && sudo systemctl enable mysql && sudo systemctl start mysql"
            echo -e "\n${GREEN}MySQL 安装完成. 请运行 'sudo mysql_secure_installation' 进行安全配置.${NC}"
            ;;
        2) 
            execute_command "sudo apt update && sudo apt install -y mysql-client"
            ;;
        3) 
            execute_command "sudo apt update && sudo apt install -y mysql-workbench"
            ;;
        4) database_management_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 PostgreSQL
install_postgresql() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 PostgreSQL:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 PostgreSQL Server"
    echo -e "${YELLOW}2.${NC} 安装 PostgreSQL Client"
    echo -e "${YELLOW}3.${NC} 安装 pgAdmin"
    echo -e "${YELLOW}4.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装选项 [1-4]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y postgresql postgresql-contrib && sudo systemctl enable postgresql && sudo systemctl start postgresql"
            ;;
        2) 
            execute_command "sudo apt update && sudo apt install -y postgresql-client"
            ;;
        3) 
            execute_command "sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add - && sudo sh -c 'echo \"deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main\" > /etc/apt/sources.list.d/pgadmin4.list' && sudo apt update && sudo apt install -y pgadmin4"
            ;;
        4) database_management_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 MongoDB
install_mongodb() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 MongoDB:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 MongoDB Community Edition"
    echo -e "${YELLOW}2.${NC} 安装 MongoDB Compass (GUI 工具)"
    echo -e "${YELLOW}3.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装选项 [1-3]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add - && echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list && sudo apt update && sudo apt install -y mongodb-org && sudo systemctl enable mongod && sudo systemctl start mongod"
            ;;
        2) 
            execute_command "wget https://downloads.mongodb.com/compass/mongodb-compass_1.35.0_amd64.deb && sudo dpkg -i mongodb-compass_1.35.0_amd64.deb && rm mongodb-compass_1.35.0_amd64.deb"
            ;;
        3) database_management_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 Redis
install_redis() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 Redis:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 Redis Server"
    echo -e "${YELLOW}2.${NC} 安装 Redis Desktop Manager"
    echo -e "${YELLOW}3.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装选项 [1-3]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y redis-server && sudo systemctl enable redis-server && sudo systemctl start redis-server"
            ;;
        2) 
            execute_command "sudo snap install redis-desktop-manager"
            ;;
        3) database_management_menu ;;
        *) invalid_option ;;
    esac
}

# MySQL 操作
mysql_operations() {
    clear_screen
    show_header
    echo -e "${CYAN}MySQL 操作:${NC}"
    echo -e "${YELLOW}1.${NC} 连接到 MySQL"
    echo -e "${YELLOW}2.${NC} 创建数据库"
    echo -e "${YELLOW}3.${NC} 创建用户"
    echo -e "${YELLOW}4.${NC} 授予权限"
    echo -e "${YELLOW}5.${NC} 导入 SQL 文件"
    echo -e "${YELLOW}6.${NC} 导出数据库"
    echo -e "${YELLOW}7.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择操作 [1-7]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入用户名 (默认: root):${NC} "
            read username
            username=${username:-root}
            execute_command "sudo mysql -u $username -p"
            ;;
        2) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "\n${CYAN}请输入用户名 (默认: root):${NC} "
            read username
            username=${username:-root}
            execute_command "sudo mysql -u $username -p -e \"CREATE DATABASE $dbname CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;\""
            ;;
        3) 
            echo -e "\n${CYAN}请输入新用户名:${NC} "
            read new_user
            echo -e "${CYAN}请输入密码:${NC} "
            read -s password
            echo -e "\n${CYAN}请输入管理员用户名 (默认: root):${NC} "
            read username
            username=${username:-root}
            execute_command "sudo mysql -u $username -p -e \"CREATE USER '$new_user'@'localhost' IDENTIFIED BY '$password';\""
            ;;
        4) 
            echo -e "\n${CYAN}请输入用户名:${NC} "
            read user
            echo -e "${CYAN}请输入数据库名称 (使用 * 表示所有数据库):${NC} "
            read dbname
            echo -e "\n${CYAN}请输入管理员用户名 (默认: root):${NC} "
            read username
            username=${username:-root}
            execute_command "sudo mysql -u $username -p -e \"GRANT ALL PRIVILEGES ON $dbname.* TO '$user'@'localhost'; FLUSH PRIVILEGES;\""
            ;;
        5) 
            echo -e "\n${CYAN}请输入 SQL 文件路径:${NC} "
            read sql_file
            echo -e "${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "\n${CYAN}请输入用户名 (默认: root):${NC} "
            read username
            username=${username:-root}
            execute_command "sudo mysql -u $username -p $dbname < $sql_file"
            ;;
        6) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "${CYAN}请输入输出文件路径:${NC} "
            read output_file
            echo -e "\n${CYAN}请输入用户名 (默认: root):${NC} "
            read username
            username=${username:-root}
            execute_command "sudo mysqldump -u $username -p $dbname > $output_file"
            ;;
        7) database_management_menu ;;
        *) invalid_option ;;
    esac
}

# PostgreSQL 操作
postgresql_operations() {
    clear_screen
    show_header
    echo -e "${CYAN}PostgreSQL 操作:${NC}"
    echo -e "${YELLOW}1.${NC} 连接到 PostgreSQL"
    echo -e "${YELLOW}2.${NC} 创建数据库"
    echo -e "${YELLOW}3.${NC} 创建用户"
    echo -e "${YELLOW}4.${NC} 授予权限"
    echo -e "${YELLOW}5.${NC} 导入 SQL 文件"
    echo -e "${YELLOW}6.${NC} 导出数据库"
    echo -e "${YELLOW}7.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择操作 [1-7]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            execute_command "sudo -u postgres psql $dbname"
            ;;
        2) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            execute_command "sudo -u postgres createdb $dbname"
            ;;
        3) 
            echo -e "\n${CYAN}请输入新用户名:${NC} "
            read new_user
            echo -e "${CYAN}请输入密码:${NC} "
            read -s password
            execute_command "sudo -u postgres psql -c \"CREATE USER $new_user WITH ENCRYPTED PASSWORD '$password';\""
            ;;
        4) 
            echo -e "\n${CYAN}请输入用户名:${NC} "
            read user
            echo -e "${CYAN}请输入数据库名称:${NC} "
            read dbname
            execute_command "sudo -u postgres psql -c \"GRANT ALL PRIVILEGES ON DATABASE $dbname TO $user;\""
            ;;
        5) 
            echo -e "\n${CYAN}请输入 SQL 文件路径:${NC} "
            read sql_file
            echo -e "${CYAN}请输入数据库名称:${NC} "
            read dbname
            execute_command "sudo -u postgres psql $dbname < $sql_file"
            ;;
        6) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "${CYAN}请输入输出文件路径:${NC} "
            read output_file
            execute_command "sudo -u postgres pg_dump $dbname > $output_file"
            ;;
        7) database_management_menu ;;
        *) invalid_option ;;
    esac
}

# MongoDB 操作
mongodb_operations() {
    clear_screen
    show_header
    echo -e "${CYAN}MongoDB 操作:${NC}"
    echo -e "${YELLOW}1.${NC} 连接到 MongoDB"
    echo -e "${YELLOW}2.${NC} 导入 JSON 文件"
    echo -e "${YELLOW}3.${NC} 导出集合"
    echo -e "${YELLOW}4.${NC} 创建用户"
    echo -e "${YELLOW}5.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择操作 [1-5]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入数据库名称 (可选):${NC} "
            read dbname
            if [[ -n "$dbname" ]]; then
                execute_command "mongo $dbname"
            else
                execute_command "mongo"
            fi
            ;;
        2) 
            echo -e "\n${CYAN}请输入 JSON 文件路径:${NC} "
            read json_file
            echo -e "${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "${CYAN}请输入集合名称:${NC} "
            read collection
            execute_command "mongoimport --db $dbname --collection $collection --file $json_file --jsonArray"
            ;;
        3) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "${CYAN}请输入集合名称:${NC} "
            read collection
            echo -e "${CYAN}请输入输出文件路径:${NC} "
            read output_file
            execute_command "mongoexport --db $dbname --collection $collection --out $output_file"
            ;;
        4) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "${CYAN}请输入用户名:${NC} "
            read username
            echo -e "${CYAN}请输入密码:${NC} "
            read -s password
            execute_command "mongo $dbname --eval \"db.createUser({user: '$username', pwd: '$password', roles: ['readWrite', 'dbAdmin']})\""
            ;;
        5) database_management_menu ;;
        *) invalid_option ;;
    esac
}

# Redis 操作
redis_operations() {
    clear_screen
    show_header
    echo -e "${CYAN}Redis 操作:${NC}"
    echo -e "${YELLOW}1.${NC} 连接到 Redis CLI"
    echo -e "${YELLOW}2.${NC} 查看 Redis 信息"
    echo -e "${YELLOW}3.${NC} 查看 Redis 统计信息"
    echo -e "${YELLOW}4.${NC} 清空所有数据库"
    echo -e "${YELLOW}5.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择操作 [1-5]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "redis-cli"
            ;;
        2) 
            execute_command "redis-cli info"
            ;;
        3) 
            execute_command "redis-cli --stat"
            ;;
        4) 
            echo -e "\n${RED}警告: 确定要清空所有 Redis 数据库吗? (y/n)${NC} "
            read -n 1 confirm
            if [[ $confirm == "y" || $confirm == "Y" ]]; then
                execute_command "redis-cli flushall"
            fi
            ;;
        5) database_management_menu ;;
        *) invalid_option ;;
    esac
}

# 数据库备份与恢复
database_backup_restore() {
    clear_screen
    show_header
    echo -e "${CYAN}数据库备份与恢复:${NC}"
    echo -e "${YELLOW}1.${NC} MySQL 备份"
    echo -e "${YELLOW}2.${NC} MySQL 恢复"
    echo -e "${YELLOW}3.${NC} PostgreSQL 备份"
    echo -e "${YELLOW}4.${NC} PostgreSQL 恢复"
    echo -e "${YELLOW}5.${NC} MongoDB 备份"
    echo -e "${YELLOW}6.${NC} MongoDB 恢复"
    echo -e "${YELLOW}7.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择操作 [1-7]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "${CYAN}请输入备份文件路径:${NC} "
            read backup_file
            echo -e "\n${CYAN}请输入用户名 (默认: root):${NC} "
            read username
            username=${username:-root}
            execute_command "sudo mysqldump -u $username -p $dbname > $backup_file"
            ;;
        2) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "${CYAN}请输入备份文件路径:${NC} "
            read backup_file
            echo -e "\n${CYAN}请输入用户名 (默认: root):${NC} "
            read username
            username=${username:-root}
            execute_command "sudo mysql -u $username -p $dbname < $backup_file"
            ;;
        3) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "${CYAN}请输入备份文件路径:${NC} "
            read backup_file
            execute_command "sudo -u postgres pg_dump $dbname > $backup_file"
            ;;
        4) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "${CYAN}请输入备份文件路径:${NC} "
            read backup_file
            execute_command "sudo -u postgres psql $dbname < $backup_file"
            ;;
        5) 
            echo -e "\n${CYAN}请输入数据库名称:${NC} "
            read dbname
            echo -e "${CYAN}请输入备份目录路径:${NC} "
            read backup_dir
            execute_command "mongodump --db $dbname --out $backup_dir"
            ;;
        6) 
            echo -e "\n${CYAN}请输入备份目录路径:${NC} "
            read backup_dir
            execute_command "mongorestore $backup_dir"
            ;;
        7) database_management_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 Docker
install_docker() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 Docker:${NC}"
    echo -e "${YELLOW}1.${NC} 使用官方脚本安装 (推荐)"
    echo -e "${YELLOW}2.${NC} 使用 apt 安装"
    echo -e "${YELLOW}3.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装方式 [1-3]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh && sudo usermod -aG docker $USER && rm get-docker.sh"
            echo -e "\n${GREEN}Docker 安装完成. 请注销并重新登录, 或重启系统使组成员身份生效.${NC}"
            ;;
        2) 
            execute_command "sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl software-properties-common && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" && sudo apt update && sudo apt install -y docker-ce && sudo usermod -aG docker $USER"
            echo -e "\n${GREEN}Docker 安装完成. 请注销并重新登录, 或重启系统使组成员身份生效.${NC}"
            ;;
        3) docker_commands_menu ;;
        *) invalid_option ;;
    esac
}

# 安装 Docker Compose
install_docker_compose() {
    clear_screen
    show_header
    echo -e "${CYAN}安装 Docker Compose:${NC}"
    echo -e "${YELLOW}1.${NC} 安装最新版本"
    echo -e "${YELLOW}2.${NC} 安装指定版本"
    echo -e "${YELLOW}3.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择安装选项 [1-3]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo curl -L \"https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose"
            ;;
        2) 
            echo -e "\n${CYAN}请输入要安装的 Docker Compose 版本 (例如: 2.17.2):${NC} "
            read version
            execute_command "sudo curl -L \"https://github.com/docker/compose/releases/download/v$version/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose"
            ;;
        3) docker_commands_menu ;;
        *) invalid_option ;;
    esac
}

# 部署 Node.js 应用
deploy_nodejs_app() {
    clear_screen
    show_header
    echo -e "${CYAN}部署 Node.js 应用:${NC}"
    echo -e "${YELLOW}1.${NC} 使用 PM2 部署"
    echo -e "${YELLOW}2.${NC} 使用 Systemd 部署"
    echo -e "${YELLOW}3.${NC} 使用 Docker 部署"
    echo -e "${YELLOW}4.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择部署方式 [1-4]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入入口文件名 (默认: app.js):${NC} "
            read entry_file
            entry_file=${entry_file:-app.js}
            echo -e "${CYAN}请输入应用名称:${NC} "
            read app_name
            execute_command "cd $app_dir && npm install && npm install -g pm2 && pm2 start $entry_file --name $app_name && pm2 save && pm2 startup"
            ;;
        2) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入入口文件名 (默认: app.js):${NC} "
            read entry_file
            entry_file=${entry_file:-app.js}
            echo -e "${CYAN}请输入服务名称:${NC} "
            read service_name
            
            # 创建 systemd 服务文件
            echo -e "${CYAN}创建 systemd 服务文件...${NC}"
            cat > /tmp/$service_name.service << EOF
[Unit]
Description=Node.js Application
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$app_dir
ExecStart=/usr/bin/node $app_dir/$entry_file
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
            execute_command "cd $app_dir && npm install && sudo mv /tmp/$service_name.service /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable $service_name && sudo systemctl start $service_name"
            ;;
        3) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入容器名称:${NC} "
            read container_name
            echo -e "${CYAN}请输入端口映射 (例如: 3000:3000):${NC} "
            read port_mapping
            
            # 创建 Dockerfile
            echo -e "${CYAN}创建 Dockerfile...${NC}"
            cat > $app_dir/Dockerfile << EOF
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE ${port_mapping#*:}
CMD ["node", "app.js"]
EOF
            execute_command "cd $app_dir && docker build -t $container_name . && docker run -d --name $container_name -p $port_mapping $container_name"
            ;;
        4) deployment_tools_menu ;;
        *) invalid_option ;;
    esac
}

# 部署 Python 应用
deploy_python_app() {
    clear_screen
    show_header
    echo -e "${CYAN}部署 Python 应用:${NC}"
    echo -e "${YELLOW}1.${NC} 使用 Gunicorn 部署"
    echo -e "${YELLOW}2.${NC} 使用 Systemd 部署"
    echo -e "${YELLOW}3.${NC} 使用 Docker 部署"
    echo -e "${YELLOW}4.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择部署方式 [1-4]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入 WSGI 应用名称 (例如: app:app):${NC} "
            read wsgi_app
            echo -e "${CYAN}请输入端口号 (默认: 8000):${NC} "
            read port
            port=${port:-8000}
            execute_command "cd $app_dir && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt gunicorn && gunicorn -b 0.0.0.0:$port $wsgi_app"
            ;;
        2) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入 WSGI 应用名称 (例如: app:app):${NC} "
            read wsgi_app
            echo -e "${CYAN}请输入服务名称:${NC} "
            read service_name
            echo -e "${CYAN}请输入端口号 (默认: 8000):${NC} "
            read port
            port=${port:-8000}
            
            # 创建 systemd 服务文件
            echo -e "${CYAN}创建 systemd 服务文件...${NC}"
            cat > /tmp/$service_name.service << EOF
[Unit]
Description=Python Application
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$app_dir
ExecStart=$app_dir/venv/bin/gunicorn -b 0.0.0.0:$port $wsgi_app
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
            execute_command "cd $app_dir && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt gunicorn && sudo mv /tmp/$service_name.service /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable $service_name && sudo systemctl start $service_name"
            ;;
        3) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入容器名称:${NC} "
            read container_name
            echo -e "${CYAN}请输入端口映射 (例如: 8000:8000):${NC} "
            read port_mapping
            
            # 创建 Dockerfile
            echo -e "${CYAN}创建 Dockerfile...${NC}"
            cat > $app_dir/Dockerfile << EOF
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE ${port_mapping#*:}
CMD ["gunicorn", "-b", "0.0.0.0:${port_mapping#*:}", "app:app"]
EOF
            execute_command "cd $app_dir && docker build -t $container_name . && docker run -d --name $container_name -p $port_mapping $container_name"
            ;;
        4) deployment_tools_menu ;;
        *) invalid_option ;;
    esac
}

# 部署 PHP 应用
deploy_php_app() {
    clear_screen
    show_header
    echo -e "${CYAN}部署 PHP 应用:${NC}"
    echo -e "${YELLOW}1.${NC} 使用 Apache 部署"
    echo -e "${YELLOW}2.${NC} 使用 Nginx + PHP-FPM 部署"
    echo -e "${YELLOW}3.${NC} 使用 Docker 部署"
    echo -e "${YELLOW}4.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择部署方式 [1-4]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入域名:${NC} "
            read domain
            
            # 创建 Apache 虚拟主机配置
            echo -e "${CYAN}创建 Apache 虚拟主机配置...${NC}"
            cat > /tmp/$domain.conf << EOF
<VirtualHost *:80>
    ServerName $domain
    DocumentRoot $app_dir
    
    <Directory $app_dir>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/$domain-error.log
    CustomLog \${APACHE_LOG_DIR}/$domain-access.log combined
</VirtualHost>
EOF
            execute_command "sudo apt update && sudo apt install -y apache2 php libapache2-mod-php php-mysql && sudo mv /tmp/$domain.conf /etc/apache2/sites-available/ && sudo a2ensite $domain.conf && sudo systemctl restart apache2"
            ;;
        2) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入域名:${NC} "
            read domain
            
            # 创建 Nginx 虚拟主机配置
            echo -e "${CYAN}创建 Nginx 虚拟主机配置...${NC}"
            cat > /tmp/$domain << EOF
server {
    listen 80;
    server_name $domain;
    root $app_dir;
    
    index index.php index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }
    
    location ~ /\.ht {
        deny all;
    }
}
EOF
            execute_command "sudo apt update && sudo apt install -y nginx php8.1-fpm php8.1-mysql && sudo mv /tmp/$domain /etc/nginx/sites-available/ && sudo ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/ && sudo systemctl restart nginx php8.1-fpm"
            ;;
        3) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入容器名称:${NC} "
            read container_name
            echo -e "${CYAN}请输入端口映射 (例如: 8080:80):${NC} "
            read port_mapping
            
            # 创建 Dockerfile
            echo -e "${CYAN}创建 Dockerfile...${NC}"
            cat > $app_dir/Dockerfile << EOF
FROM php:8.1-apache
WORKDIR /var/www/html
COPY . .
RUN docker-php-ext-install pdo pdo_mysql
EXPOSE 80
EOF
            execute_command "cd $app_dir && docker build -t $container_name . && docker run -d --name $container_name -p $port_mapping $container_name"
            ;;
        4) deployment_tools_menu ;;
        *) invalid_option ;;
    esac
}

# 部署 Java 应用
deploy_java_app() {
    clear_screen
    show_header
    echo -e "${CYAN}部署 Java 应用:${NC}"
    echo -e "${YELLOW}1.${NC} 部署 Spring Boot 应用"
    echo -e "${YELLOW}2.${NC} 部署 WAR 文件到 Tomcat"
    echo -e "${YELLOW}3.${NC} 使用 Docker 部署"
    echo -e "${YELLOW}4.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择部署方式 [1-4]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入服务名称:${NC} "
            read service_name
            echo -e "${CYAN}请输入 JAR 文件名:${NC} "
            read jar_file
            
            # 创建 systemd 服务文件
            echo -e "${CYAN}创建 systemd 服务文件...${NC}"
            cat > /tmp/$service_name.service << EOF
[Unit]
Description=Spring Boot Application
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$app_dir
ExecStart=/usr/bin/java -jar $app_dir/$jar_file
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
            execute_command "cd $app_dir && sudo mv /tmp/$service_name.service /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable $service_name && sudo systemctl start $service_name"
            ;;
        2) 
            echo -e "\n${CYAN}请输入 WAR 文件路径:${NC} "
            read war_file
            execute_command "sudo apt update && sudo apt install -y tomcat9 && sudo cp $war_file /var/lib/tomcat9/webapps/ && sudo systemctl restart tomcat9"
            ;;
        3) 
            echo -e "\n${CYAN}请输入应用目录路径:${NC} "
            read app_dir
            echo -e "${CYAN}请输入容器名称:${NC} "
            read container_name
            echo -e "${CYAN}请输入端口映射 (例如: 8080:8080):${NC} "
            read port_mapping
            echo -e "${CYAN}请输入 JAR 文件名:${NC} "
            read jar_file
            
            # 创建 Dockerfile
            echo -e "${CYAN}创建 Dockerfile...${NC}"
            cat > $app_dir/Dockerfile << EOF
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY $jar_file app.jar
EXPOSE ${port_mapping#*:}
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF
            execute_command "cd $app_dir && docker build -t $container_name . && docker run -d --name $container_name -p $port_mapping $container_name"
            ;;
        4) deployment_tools_menu ;;
        *) invalid_option ;;
    esac
}

# 配置 Nginx 服务器
configure_nginx() {
    clear_screen
    show_header
    echo -e "${CYAN}配置 Nginx 服务器:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 Nginx"
    echo -e "${YELLOW}2.${NC} 创建虚拟主机"
    echo -e "${YELLOW}3.${NC} 配置反向代理"
    echo -e "${YELLOW}4.${NC} 配置负载均衡"
    echo -e "${YELLOW}5.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择操作 [1-5]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y nginx && sudo systemctl enable nginx && sudo systemctl start nginx"
            ;;
        2) 
            echo -e "\n${CYAN}请输入域名:${NC} "
            read domain
            echo -e "${CYAN}请输入网站根目录:${NC} "
            read root_dir
            
            # 创建 Nginx 虚拟主机配置
            echo -e "${CYAN}创建 Nginx 虚拟主机配置...${NC}"
            cat > /tmp/$domain << EOF
server {
    listen 80;
    server_name $domain;
    root $root_dir;
    
    index index.html index.htm index.php;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }
    
    location ~ /\.ht {
        deny all;
    }
}
EOF
            execute_command "sudo mkdir -p $root_dir && sudo mv /tmp/$domain /etc/nginx/sites-available/ && sudo ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/ && sudo systemctl restart nginx"
            ;;
        3) 
            echo -e "\n${CYAN}请输入域名:${NC} "
            read domain
            echo -e "${CYAN}请输入后端服务地址 (例如: http://localhost:3000):${NC} "
            read backend
            
            # 创建 Nginx 反向代理配置
            echo -e "${CYAN}创建 Nginx 反向代理配置...${NC}"
            cat > /tmp/$domain << EOF
server {
    listen 80;
    server_name $domain;
    
    location / {
        proxy_pass $backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF
            execute_command "sudo mv /tmp/$domain /etc/nginx/sites-available/ && sudo ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/ && sudo systemctl restart nginx"
            ;;
        4) 
            echo -e "\n${CYAN}请输入域名:${NC} "
            read domain
            echo -e "${CYAN}请输入后端服务地址列表 (用空格分隔, 例如: http://localhost:3000 http://localhost:3001):${NC} "
            read -a backends
            
            # 创建 Nginx 负载均衡配置
            echo -e "${CYAN}创建 Nginx 负载均衡配置...${NC}"
            cat > /tmp/$domain << EOF
upstream backend {
EOF
            for backend in "${backends[@]}"; do
                echo "    server $backend;" >> /tmp/$domain
            done
            cat >> /tmp/$domain << EOF
}

server {
    listen 80;
    server_name $domain;
    
    location / {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF
            execute_command "sudo mv /tmp/$domain /etc/nginx/sites-available/ && sudo ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/ && sudo systemctl restart nginx"
            ;;
        5) deployment_tools_menu ;;
        *) invalid_option ;;
    esac
}

# 配置 Apache 服务器
configure_apache() {
    clear_screen
    show_header
    echo -e "${CYAN}配置 Apache 服务器:${NC}"
    echo -e "${YELLOW}1.${NC} 安装 Apache"
    echo -e "${YELLOW}2.${NC} 创建虚拟主机"
    echo -e "${YELLOW}3.${NC} 配置反向代理"
    echo -e "${YELLOW}4.${NC} 启用 SSL"
    echo -e "${YELLOW}5.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择操作 [1-5]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            execute_command "sudo apt update && sudo apt install -y apache2 && sudo systemctl enable apache2 && sudo systemctl start apache2"
            ;;
        2) 
            echo -e "\n${CYAN}请输入域名:${NC} "
            read domain
            echo -e "${CYAN}请输入网站根目录:${NC} "
            read root_dir
            
            # 创建 Apache 虚拟主机配置
            echo -e "${CYAN}创建 Apache 虚拟主机配置...${NC}"
            cat > /tmp/$domain.conf << EOF
<VirtualHost *:80>
    ServerName $domain
    DocumentRoot $root_dir
    
    <Directory $root_dir>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/$domain-error.log
    CustomLog \${APACHE_LOG_DIR}/$domain-access.log combined
</VirtualHost>
EOF
            execute_command "sudo mkdir -p $root_dir && sudo mv /tmp/$domain.conf /etc/apache2/sites-available/ && sudo a2ensite $domain.conf && sudo systemctl restart apache2"
            ;;
        3) 
            echo -e "\n${CYAN}请输入域名:${NC} "
            read domain
            echo -e "${CYAN}请输入后端服务地址 (例如: http://localhost:3000):${NC} "
            read backend
            
            # 创建 Apache 反向代理配置
            echo -e "${CYAN}创建 Apache 反向代理配置...${NC}"
            cat > /tmp/$domain.conf << EOF
<VirtualHost *:80>
    ServerName $domain
    
    ProxyPreserveHost On
    ProxyPass / $backend/
    ProxyPassReverse / $backend/
    
    ErrorLog \${APACHE_LOG_DIR}/$domain-error.log
    CustomLog \${APACHE_LOG_DIR}/$domain-access.log combined
</VirtualHost>
EOF
            execute_command "sudo a2enmod proxy proxy_http && sudo mv /tmp/$domain.conf /etc/apache2/sites-available/ && sudo a2ensite $domain.conf && sudo systemctl restart apache2"
            ;;
        4) 
            echo -e "\n${CYAN}请输入域名:${NC} "
            read domain
            echo -e "${CYAN}请输入网站根目录:${NC} "
            read root_dir
            
            # 创建 Apache SSL 虚拟主机配置
            echo -e "${CYAN}创建 Apache SSL 虚拟主机配置...${NC}"
            cat > /tmp/$domain-ssl.conf << EOF
<VirtualHost *:443>
    ServerName $domain
    DocumentRoot $root_dir
    
    <Directory $root_dir>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/$domain.crt
    SSLCertificateKeyFile /etc/ssl/private/$domain.key
    
    ErrorLog \${APACHE_LOG_DIR}/$domain-error.log
    CustomLog \${APACHE_LOG_DIR}/$domain-access.log combined
</VirtualHost>
EOF
            execute_command "sudo a2enmod ssl && sudo mkdir -p $root_dir && sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$domain.key -out /etc/ssl/certs/$domain.crt && sudo mv /tmp/$domain-ssl.conf /etc/apache2/sites-available/ && sudo a2ensite $domain-ssl.conf && sudo systemctl restart apache2"
            ;;
        5) deployment_tools_menu ;;
        *) invalid_option ;;
    esac
}

# 设置 SSL 证书
setup_ssl_certificate() {
    clear_screen
    show_header
    echo -e "${CYAN}设置 SSL 证书:${NC}"
    echo -e "${YELLOW}1.${NC} 使用 Let's Encrypt 获取证书"
    echo -e "${YELLOW}2.${NC} 生成自签名证书"
    echo -e "${YELLOW}3.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择操作 [1-3]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入域名:${NC} "
            read domain
            echo -e "${CYAN}请输入电子邮件地址:${NC} "
            read email
            echo -e "${CYAN}请选择 Web 服务器: 1) Nginx 2) Apache${NC} "
            read -n 1 web_server
            
            if [[ $web_server == "1" ]]; then
                execute_command "sudo apt update && sudo apt install -y certbot python3-certbot-nginx && sudo certbot --nginx -d $domain -m $email --agree-tos --non-interactive"
            else
                execute_command "sudo apt update && sudo apt install -y certbot python3-certbot-apache && sudo certbot --apache -d $domain -m $email --agree-tos --non-interactive"
            fi
            ;;
        2) 
            echo -e "\n${CYAN}请输入域名:${NC} "
            read domain
            echo -e "${CYAN}请输入证书保存目录 (默认: /etc/ssl):${NC} "
            read ssl_dir
            ssl_dir=${ssl_dir:-/etc/ssl}
            
            execute_command "sudo mkdir -p $ssl_dir/private $ssl_dir/certs && sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $ssl_dir/private/$domain.key -out $ssl_dir/certs/$domain.crt"
            ;;
        3) deployment_tools_menu ;;
        *) invalid_option ;;
    esac
}

# 部署 Docker 容器
deploy_docker_container() {
    clear_screen
    show_header
    echo -e "${CYAN}部署 Docker 容器:${NC}"
    echo -e "${YELLOW}1.${NC} 使用 Docker Compose 部署"
    echo -e "${YELLOW}2.${NC} 使用 Docker 命令部署"
    echo -e "${YELLOW}3.${NC} 返回上级菜单"
    echo ""
    echo -e "${CYAN}请选择部署方式 [1-3]:${NC} "
    
    read -n 1 option
    case $option in
        1) 
            echo -e "\n${CYAN}请输入项目目录路径:${NC} "
            read project_dir
            
            # 检查是否存在 docker-compose.yml 文件
            if [[ -f "$project_dir/docker-compose.yml" ]]; then
                execute_command "cd $project_dir && docker-compose up -d"
            else
                echo -e "\n${RED}错误: $project_dir/docker-compose.yml 文件不存在!${NC}"
                echo -e "${CYAN}是否要创建一个示例 docker-compose.yml 文件? (y/n)${NC} "
                read -n 1 create_file
                if [[ $create_file == "y" || $create_file == "Y" ]]; then
                    cat > $project_dir/docker-compose.yml << EOF
version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
    restart: always
  
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydb
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    volumes:
      - db_data:/var/lib/mysql
    restart: always

volumes:
  db_data:
EOF
                    execute_command "mkdir -p $project_dir/html && echo '<h1>Hello from Docker!</h1>' > $project_dir/html/index.html && cd $project_dir && docker-compose up -d"
                fi
            fi
            ;;
        2) 
            echo -e "\n${CYAN}请输入镜像名称:${NC} "
            read image_name
            echo -e "${CYAN}请输入容器名称:${NC} "
            read container_name
            echo -e "${CYAN}请输入端口映射 (例如: 80:80):${NC} "
            read port_mapping
            echo -e "${CYAN}请输入卷映射 (例如: ./data:/data) (可选):${NC} "
            read volume_mapping
            
            volume_option=""
            if [[ -n "$volume_mapping" ]]; then
                volume_option="-v $volume_mapping"
            fi
            
            execute_command "docker run -d --name $container_name -p $port_mapping $volume_option $image_name"
            ;;
        3) deployment_tools_menu ;;
        *) invalid_option ;;
    esac
}

# 查看自定义命令
view_custom_commands() {
    clear_screen
    show_header
    echo -e "${CYAN}已保存的自定义命令:${NC}"
    
    if [[ ! -f ~/.ub_custom_commands ]]; then
        echo -e "${YELLOW}尚未保存任何自定义命令.${NC}"
    else
        cat ~/.ub_custom_commands
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
    custom_commands_menu
}

# 添加自定义命令
add_custom_command() {
    clear_screen
    show_header
    echo -e "${CYAN}添加新的自定义命令:${NC}"
    
    echo -e "${CYAN}请输入命令名称:${NC} "
    read cmd_name
    echo -e "${CYAN}请输入命令内容:${NC} "
    read cmd_content
    
    if [[ ! -f ~/.ub_custom_commands ]]; then
        echo "$cmd_name: $cmd_content" > ~/.ub_custom_commands
    else
        echo "$cmd_name: $cmd_content" >> ~/.ub_custom_commands
    fi
    
    echo -e "\n${GREEN}自定义命令已添加.${NC}"
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
    custom_commands_menu
}

# 编辑自定义命令
edit_custom_command() {
    clear_screen
    show_header
    echo -e "${CYAN}编辑自定义命令:${NC}"
    
    if [[ ! -f ~/.ub_custom_commands ]]; then
        echo -e "${YELLOW}尚未保存任何自定义命令.${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
        custom_commands_menu
        return
    fi
    
    # 显示所有命令
    cat -n ~/.ub_custom_commands
    
    echo -e "\n${CYAN}请输入要编辑的命令行号:${NC} "
    read line_num
    
    # 获取该行内容
    line_content=$(sed -n "${line_num}p" ~/.ub_custom_commands)
    cmd_name=$(echo "$line_content" | cut -d: -f1)
    cmd_content=$(echo "$line_content" | cut -d: -f2- | sed 's/^ //')
    
    echo -e "${CYAN}当前命令名称: $cmd_name${NC}"
    echo -e "${CYAN}当前命令内容: $cmd_content${NC}"
    
    echo -e "\n${CYAN}请输入新的命令名称 (留空保持不变):${NC} "
    read new_name
    new_name=${new_name:-$cmd_name}
    
    echo -e "${CYAN}请输入新的命令内容 (留空保持不变):${NC} "
    read new_content
    new_content=${new_content:-$cmd_content}
    
    # 更新文件
    sed -i "${line_num}s/.*/$new_name: $new_content/" ~/.ub_custom_commands
    
    echo -e "\n${GREEN}自定义命令已更新.${NC}"
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
    custom_commands_menu
}

# 删除自定义命令
delete_custom_command() {
    clear_screen
    show_header
    echo -e "${CYAN}删除自定义命令:${NC}"
    
    if [[ ! -f ~/.ub_custom_commands ]]; then
        echo -e "${YELLOW}尚未保存任何自定义命令.${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
        custom_commands_menu
        return
    fi
    
    # 显示所有命令
    cat -n ~/.ub_custom_commands
    
    echo -e "\n${CYAN}请输入要删除的命令行号:${NC} "
    read line_num
    
    # 删除该行
    sed -i "${line_num}d" ~/.ub_custom_commands
    
    echo -e "\n${GREEN}自定义命令已删除.${NC}"
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
    custom_commands_menu
}

# 执行自定义命令
execute_custom_command() {
    clear_screen
    show_header
    echo -e "${CYAN}执行自定义命令:${NC}"
    
    if [[ ! -f ~/.ub_custom_commands ]]; then
        echo -e "${YELLOW}尚未保存任何自定义命令.${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
        custom_commands_menu
        return
    fi
    
    # 显示所有命令
    cat -n ~/.ub_custom_commands
    
    echo -e "\n${CYAN}请输入要执行的命令行号:${NC} "
    read line_num
    
    # 获取该行内容
    cmd_content=$(sed -n "${line_num}p" ~/.ub_custom_commands | cut -d: -f2- | sed 's/^ //')
    
    execute_command "$cmd_content"
    custom_commands_menu
}

# 设置快捷键
setup_shortcut() {
    # 添加到 .bashrc
    if ! grep -q "# UB 命令大全快捷键" ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# UB 命令大全快捷键" >> ~/.bashrc
        echo "bind -x '\"\C-f\":\"$HOME/ub_command_menu/ub_commands.sh\"'" >> ~/.bashrc
        echo "" >> ~/.bashrc
    fi
    
    # 设置数字键 6 快捷键
    if ! grep -q "# 数字键 6 快捷键" ~/.bashrc; then
        echo "# 数字键 6 快捷键" >> ~/.bashrc
        echo "bind -x '\"\e[17~\":\"$HOME/ub_command_menu/ub_commands.sh\"'" >> ~/.bashrc
        echo "" >> ~/.bashrc
    fi
    
    echo -e "\n${GREEN}快捷键设置完成. 请重新加载 .bashrc 文件或重新打开终端使其生效.${NC}"
    echo -e "${YELLOW}使用方法: 按数字键 6 或 Ctrl+F 调出命令菜单.${NC}"
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1
}

# 加载预设选项管理脚本
load_preset_manager() {
    # 检查预设管理脚本是否存在
    if [[ -f "$HOME/ub_command_menu/preset_manager.sh" ]]; then
        source "$HOME/ub_command_menu/preset_manager.sh"
    else
        echo -e "\n${RED}错误: 预设管理脚本不存在!${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
    fi
}

# 加载虚拟环境管理脚本
load_virtual_env_manager() {
    # 检查虚拟环境管理脚本是否存在
    if [[ -f "$HOME/ub_command_menu/virtual_env_manager.sh" ]]; then
        source "$HOME/ub_command_menu/virtual_env_manager.sh"
    else
        echo -e "\n${RED}错误: 虚拟环境管理脚本不存在!${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
    fi
}

# 加载脚本授权工具
load_script_auth_manager() {
    # 检查脚本授权工具是否存在
    if [[ -f "$HOME/ub_command_menu/script_auth_manager.sh" ]]; then
        source "$HOME/ub_command_menu/script_auth_manager.sh"
    else
        echo -e "\n${RED}错误: 脚本授权工具不存在!${NC}"
        echo -e "\n${CYAN}按任意键继续...${NC}"
        read -n 1
    fi
}

# 主函数
main() {
    # 检查是否是首次运行
    if [[ ! -f ~/.ub_commands_initialized ]]; then
        # 设置快捷键
        setup_shortcut
        touch ~/.ub_commands_initialized
    fi
    
    # 加载预设选项管理脚本
    load_preset_manager
    
    # 加载虚拟环境管理脚本
    load_virtual_env_manager
    
    # 加载脚本授权工具
    load_script_auth_manager
    
    # 显示主菜单
    show_main_menu
    
    # 处理用户输入
    read -n 1 option
    case $option in
        1) system_info_menu ;;
        2) package_management_menu ;;
        3) file_operations_menu ;;
        4) network_tools_menu ;;
        5) deployment_tools_menu ;;
        6) dev_environment_menu ;;
        7) docker_commands_menu ;;
        8) database_management_menu ;;
        9) custom_commands_menu ;;
        [Pp]) preset_menu ;;
        [Vv]) virtual_env_menu ;;
        [Aa]) script_auth_menu ;;
        0) exit 0 ;;
        *) invalid_option && main ;;
    esac
}

# 启动脚本
main
