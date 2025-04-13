#!/bin/bash

# 一行命令安装示例脚本
# 这个脚本用于演示如何通过curl一行命令安装Ubuntu命令大全脚本

echo "这个脚本将模拟通过curl一行命令安装Ubuntu命令大全脚本的过程"
echo "在实际部署时，这个脚本会被托管在公共服务器上"
echo ""

# 创建一行命令安装指令
ONE_LINE_COMMAND="curl -sSL https://example.com/ub_command_menu/install.sh | sudo bash"

echo "用户可以使用以下命令一键安装Ubuntu命令大全脚本："
echo ""
echo "  $ONE_LINE_COMMAND"
echo ""
echo "这个命令会从服务器下载安装脚本并以root权限执行"
echo "安装过程会显示进度，并在完成后提供使用说明"
