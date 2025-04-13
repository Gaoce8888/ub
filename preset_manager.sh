#!/bin/bash

# 预设选项配置文件
PRESET_CONFIG_FILE="$HOME/ub_command_menu/presets.conf"

# 创建预设选项
create_preset() {
    clear
    echo -e "\033[0;36m创建新的预设选项\033[0m"
    echo -e "\033[0;33m请输入预设名称:\033[0m "
    read preset_name
    
    echo -e "\033[0;33m请输入预设描述:\033[0m "
    read preset_desc
    
    echo -e "\033[0;33m请输入要执行的命令或脚本路径:\033[0m "
    read preset_command
    
    # 保存到配置文件
    echo "[$preset_name]" >> $PRESET_CONFIG_FILE
    echo "description=$preset_desc" >> $PRESET_CONFIG_FILE
    echo "command=$preset_command" >> $PRESET_CONFIG_FILE
    echo "" >> $PRESET_CONFIG_FILE
    
    echo -e "\n\033[0;32m预设选项已创建.\033[0m"
    echo -e "\n\033[0;36m按任意键继续...\033[0m"
    read -n 1
}

# 列出所有预设选项
list_presets() {
    clear
    echo -e "\033[0;36m可用的预设选项:\033[0m"
    
    if [[ ! -f $PRESET_CONFIG_FILE ]]; then
        echo -e "\033[0;33m尚未创建任何预设选项.\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
        return
    fi
    
    # 读取并显示所有预设
    local preset_name=""
    local preset_desc=""
    local preset_count=0
    
    while IFS= read -r line; do
        if [[ $line =~ ^\[(.*)\]$ ]]; then
            preset_name="${BASH_REMATCH[1]}"
            preset_count=$((preset_count + 1))
            echo -e "\033[0;33m$preset_count.\033[0m $preset_name"
        elif [[ $line =~ ^description=(.*)$ ]]; then
            preset_desc="${BASH_REMATCH[1]}"
            echo -e "   \033[0;32m描述:\033[0m $preset_desc"
        fi
    done < $PRESET_CONFIG_FILE
    
    if [[ $preset_count -eq 0 ]]; then
        echo -e "\033[0;33m尚未创建任何预设选项.\033[0m"
    fi
    
    echo -e "\n\033[0;36m按任意键继续...\033[0m"
    read -n 1
}

# 运行预设选项
run_preset() {
    clear
    echo -e "\033[0;36m运行预设选项:\033[0m"
    
    if [[ ! -f $PRESET_CONFIG_FILE ]]; then
        echo -e "\033[0;33m尚未创建任何预设选项.\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
        return
    fi
    
    # 读取并显示所有预设
    local preset_names=()
    local preset_commands=()
    local preset_count=0
    
    while IFS= read -r line; do
        if [[ $line =~ ^\[(.*)\]$ ]]; then
            preset_names+=("${BASH_REMATCH[1]}")
            preset_count=$((preset_count + 1))
            echo -e "\033[0;33m$preset_count.\033[0m ${BASH_REMATCH[1]}"
        elif [[ $line =~ ^description=(.*)$ ]]; then
            echo -e "   \033[0;32m描述:\033[0m ${BASH_REMATCH[1]}"
        elif [[ $line =~ ^command=(.*)$ ]]; then
            preset_commands+=("${BASH_REMATCH[1]}")
        fi
    done < $PRESET_CONFIG_FILE
    
    if [[ $preset_count -eq 0 ]]; then
        echo -e "\033[0;33m尚未创建任何预设选项.\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
        return
    fi
    
    echo -e "\n\033[0;36m请选择要运行的预设选项 [1-$preset_count]:\033[0m "
    read preset_choice
    
    if [[ $preset_choice -ge 1 && $preset_choice -le $preset_count ]]; then
        local index=$((preset_choice - 1))
        local command="${preset_commands[$index]}"
        
        echo -e "\n\033[0;32m执行预设: ${preset_names[$index]}\033[0m"
        echo -e "\033[0;33m命令: $command\033[0m\n"
        
        eval "$command"
        
        echo -e "\n\033[0;32m预设命令执行完成.\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
    else
        echo -e "\n\033[0;31m无效选项!\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
    fi
}

# 编辑预设选项
edit_preset() {
    clear
    echo -e "\033[0;36m编辑预设选项:\033[0m"
    
    if [[ ! -f $PRESET_CONFIG_FILE ]]; then
        echo -e "\033[0;33m尚未创建任何预设选项.\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
        return
    fi
    
    # 读取并显示所有预设
    local preset_names=()
    local preset_descs=()
    local preset_commands=()
    local preset_count=0
    
    while IFS= read -r line; do
        if [[ $line =~ ^\[(.*)\]$ ]]; then
            preset_names+=("${BASH_REMATCH[1]}")
            preset_count=$((preset_count + 1))
            echo -e "\033[0;33m$preset_count.\033[0m ${BASH_REMATCH[1]}"
        elif [[ $line =~ ^description=(.*)$ ]]; then
            preset_descs+=("${BASH_REMATCH[1]}")
            echo -e "   \033[0;32m描述:\033[0m ${BASH_REMATCH[1]}"
        elif [[ $line =~ ^command=(.*)$ ]]; then
            preset_commands+=("${BASH_REMATCH[1]}")
        fi
    done < $PRESET_CONFIG_FILE
    
    if [[ $preset_count -eq 0 ]]; then
        echo -e "\033[0;33m尚未创建任何预设选项.\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
        return
    fi
    
    echo -e "\n\033[0;36m请选择要编辑的预设选项 [1-$preset_count]:\033[0m "
    read preset_choice
    
    if [[ $preset_choice -ge 1 && $preset_choice -le $preset_count ]]; then
        local index=$((preset_choice - 1))
        local old_name="${preset_names[$index]}"
        local old_desc="${preset_descs[$index]}"
        local old_command="${preset_commands[$index]}"
        
        echo -e "\n\033[0;32m当前预设名称: $old_name\033[0m"
        echo -e "\033[0;33m请输入新的预设名称 (留空保持不变):\033[0m "
        read new_name
        new_name=${new_name:-$old_name}
        
        echo -e "\n\033[0;32m当前预设描述: $old_desc\033[0m"
        echo -e "\033[0;33m请输入新的预设描述 (留空保持不变):\033[0m "
        read new_desc
        new_desc=${new_desc:-$old_desc}
        
        echo -e "\n\033[0;32m当前命令: $old_command\033[0m"
        echo -e "\033[0;33m请输入新的命令 (留空保持不变):\033[0m "
        read new_command
        new_command=${new_command:-$old_command}
        
        # 创建临时文件
        local temp_file=$(mktemp)
        local current_preset=""
        local in_target_preset=false
        
        while IFS= read -r line; do
            if [[ $line =~ ^\[(.*)\]$ ]]; then
                current_preset="${BASH_REMATCH[1]}"
                if [[ "$current_preset" == "$old_name" ]]; then
                    in_target_preset=true
                    echo "[$new_name]" >> $temp_file
                else
                    in_target_preset=false
                    echo "$line" >> $temp_file
                fi
            elif [[ $in_target_preset == true && $line =~ ^description= ]]; then
                echo "description=$new_desc" >> $temp_file
            elif [[ $in_target_preset == true && $line =~ ^command= ]]; then
                echo "command=$new_command" >> $temp_file
            else
                echo "$line" >> $temp_file
            fi
        done < $PRESET_CONFIG_FILE
        
        # 替换原文件
        mv $temp_file $PRESET_CONFIG_FILE
        
        echo -e "\n\033[0;32m预设选项已更新.\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
    else
        echo -e "\n\033[0;31m无效选项!\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
    fi
}

# 删除预设选项
delete_preset() {
    clear
    echo -e "\033[0;36m删除预设选项:\033[0m"
    
    if [[ ! -f $PRESET_CONFIG_FILE ]]; then
        echo -e "\033[0;33m尚未创建任何预设选项.\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
        return
    fi
    
    # 读取并显示所有预设
    local preset_names=()
    local preset_count=0
    
    while IFS= read -r line; do
        if [[ $line =~ ^\[(.*)\]$ ]]; then
            preset_names+=("${BASH_REMATCH[1]}")
            preset_count=$((preset_count + 1))
            echo -e "\033[0;33m$preset_count.\033[0m ${BASH_REMATCH[1]}"
        elif [[ $line =~ ^description=(.*)$ ]]; then
            echo -e "   \033[0;32m描述:\033[0m ${BASH_REMATCH[1]}"
        fi
    done < $PRESET_CONFIG_FILE
    
    if [[ $preset_count -eq 0 ]]; then
        echo -e "\033[0;33m尚未创建任何预设选项.\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
        return
    fi
    
    echo -e "\n\033[0;36m请选择要删除的预设选项 [1-$preset_count]:\033[0m "
    read preset_choice
    
    if [[ $preset_choice -ge 1 && $preset_choice -le $preset_count ]]; then
        local index=$((preset_choice - 1))
        local target_preset="${preset_names[$index]}"
        
        echo -e "\n\033[0;31m警告: 确定要删除预设 '$target_preset' 吗? (y/n)\033[0m "
        read -n 1 confirm
        
        if [[ $confirm == "y" || $confirm == "Y" ]]; then
            # 创建临时文件
            local temp_file=$(mktemp)
            local current_preset=""
            local in_target_preset=false
            local skip_line=false
            
            while IFS= read -r line; do
                if [[ $line =~ ^\[(.*)\]$ ]]; then
                    current_preset="${BASH_REMATCH[1]}"
                    if [[ "$current_preset" == "$target_preset" ]]; then
                        in_target_preset=true
                        skip_line=true
                    else
                        in_target_preset=false
                        skip_line=false
                        echo "$line" >> $temp_file
                    fi
                elif [[ $in_target_preset == true ]]; then
                    # 跳过目标预设的所有行
                    continue
                elif [[ $skip_line == false ]]; then
                    echo "$line" >> $temp_file
                fi
            done < $PRESET_CONFIG_FILE
            
            # 替换原文件
            mv $temp_file $PRESET_CONFIG_FILE
            
            echo -e "\n\033[0;32m预设选项已删除.\033[0m"
        fi
        
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
    else
        echo -e "\n\033[0;31m无效选项!\033[0m"
        echo -e "\n\033[0;36m按任意键继续...\033[0m"
        read -n 1
    fi
}

# 预设选项菜单
preset_menu() {
    while true; do
        clear
        echo -e "\033[0;34m┌───────────────────────────────────────────────┐\033[0m"
        echo -e "\033[0;34m│                                               │\033[0m"
        echo -e "\033[0;34m│\033[0;33m              预设选项管理                    \033[0;34m│\033[0m"
        echo -e "\033[0;34m│                                               │\033[0m"
        echo -e "\033[0;34m└───────────────────────────────────────────────┘\033[0m"
        echo ""
        echo -e "\033[0;36m请选择操作:\033[0m"
        echo -e "\033[0;33m1.\033[0m 创建新的预设选项"
        echo -e "\033[0;33m2.\033[0m 查看所有预设选项"
        echo -e "\033[0;33m3.\033[0m 运行预设选项"
        echo -e "\033[0;33m4.\033[0m 编辑预设选项"
        echo -e "\033[0;33m5.\033[0m 删除预设选项"
        echo -e "\033[0;33m0.\033[0m 返回主菜单"
        echo ""
        echo -e "\033[0;36m请输入选项 [0-5]:\033[0m "
        
        read -n 1 option
        case $option in
            1) create_preset ;;
            2) list_presets ;;
            3) run_preset ;;
            4) edit_preset ;;
            5) delete_preset ;;
            0) return ;;
            *) 
                echo -e "\n\033[0;31m无效选项! 请重新选择.\033[0m"
                sleep 1
                ;;
        esac
    done
}

# 导出函数
export -f preset_menu
export -f create_preset
export -f list_presets
export -f run_preset
export -f edit_preset
export -f delete_preset
