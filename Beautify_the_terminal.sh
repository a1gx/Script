#!/bin/sh

set -e
set -x

apt update
apt install zsh -y
apt install perl -y
chsh -s /bin/zsh

# 安装oh-my-zsh
sh -c "$(curl -fsSL https://raw.staticdn.net/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装插件
apt install autojump -y
git clone https://github.com.cnpmjs.org/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com.cnpmjs.org/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "# 激活autojump
. /usr/share/autojump/autojump.sh" >> ~/.zshrc

perl -0pi -e 's/(plugin.*?=.*?{)(.*?)(})/\1git
        colored-man-pages
        zsh-syntax-highlighting
        zsh-autosuggestions
        \3/gs' ~/.zshrc

# 安装powerlevel10k
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

perl -0pi -e 's/(ZSH_THEME=").*?(")/\1powerlevel10k\/powerlevel10k\2/gs' ~/.zshrc

source ~/.zshrc

# 安装与美化tmux
apt install tmux -y

cat <<EOF > ~/.tmux.conf
#设置前缀为Ctrl + a
set -g prefix C-a
#解除Ctrl+b 与前缀的对应关系
unbind C-b
#将r 设置为加载配置文件，并显示"reloaded!"信息
bind r source-file ~/.tmux.conf \; display "Reloaded!"
#up
bind-key k select-pane -U
#down
bind-key j select-pane -D
#left
bind-key h select-pane -L
#right
bind-key l select-pane -R
#select last window
bind-key C-l select-window -l
#copy-mode 将快捷键设置为vi 模式
setw -g mode-keys vi
#设置滑鼠
set -g mouse on
unbind o
bind-key o set mouse on \; display "The mouse on!"
bind-key O set mouse off \; display "The mouse off!"

#隐藏状态栏
bind-key b set status on \; display "Status on!"
bind-key B set status off \; display "Status off!"

# 状态栏
# 颜色
set -g status-bg black
set -g status-fg white

# 对齐方式
set-option -g status-justify centre

# 左下角
set-option -g status-left '#[bg=black,fg=green][#[fg=cyan]#S#[fg=green]]'
set-option -g status-left-length 20

# 窗口列表
setw -g automatic-rename on
set-window-option -g window-status-format '#[dim]#I:#[default]#W#[fg=grey,dim]'
set-window-option -g window-status-current-format '#[fg=cyan,bold]#I#[fg=blue]:#[fg=cyan]#W#[fg=dim]'

# 右下角
set -g status-right '#{prefix_highlight} #[fg=green][#[fg=cyan]%Y-%m-%d#[fg=green]]'
#插件
#插件管理器
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
#set -g @plugin 'tmux-plugins/tmux-yank'
#set -g @plugin 'wfxr/tmux-power'
#set -g @tmux_power_theme 'snow'
#前缀高亮插件
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
set -g @prefix_highlight_fg 'cyan' # default is 'colour231'
set -g @prefix_highlight_bg 'black'  # default is 'colour04'
#面板控制插件
set -g @plugin 'tmux-plugins/tmux-pain-control'
#必须放在最后一行
run '~/.tmux/plugins/tpm/tpm'
EOF

git clone https://github.com.cnpmjs.org/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

cat <<EOF >> ~/.zshrc
# tmux 初始化
tmux has -t "a1gx"
if [[ $? == 0 ]];then
    tmux att -t a1gx
else
    tmux new -s a1gx
fi
EOF
