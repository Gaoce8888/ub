# 通过网络指令安装 Ubuntu 命令大全脚本

## 一键安装方法

您可以使用以下命令一键安装 Ubuntu 命令大全脚本：

```bash
curl -sSL https://example.com/ub_command_menu/install.sh | sudo bash
```

这个命令会自动完成以下操作：
1. 下载安装脚本
2. 安装脚本到系统目录 `/usr/local/bin/ub_command_menu`
3. 创建全局命令 `ubcmd`
4. 设置快捷键（数字键6和Ctrl+F）
5. 创建卸载程序

## 安装后使用方法

安装完成后，您可以通过以下方式使用 Ubuntu 命令大全脚本：

1. 在终端中输入 `ubcmd` 命令启动脚本
2. 按下数字键6快速调出命令菜单
3. 按下 Ctrl+F 组合键快速调出命令菜单

## 卸载方法

如果您需要卸载 Ubuntu 命令大全脚本，只需在终端中运行：

```bash
ubcmd-uninstall
```

这个命令会自动删除所有安装的文件和设置。

## 注意事项

- 安装需要 sudo 权限，因为脚本会安装到系统目录
- 安装后需要重新加载终端或运行 `source /etc/bash.bashrc` 使快捷键生效
- 如果您使用的不是 bash，快捷键可能需要手动配置
