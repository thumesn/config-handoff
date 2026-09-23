# tmux 配置说明 / Local tmux Setup

本目录归档本机（用户 `chaofeng`，路径 `/home/chaofeng`）的 tmux 配置，供交接或迁移使用。
本目录内容最后同步自本机：2026-09-23，tmux 版本 3.2a。

## 文件清单

| 本目录文件 | 本机对应位置 | 用途 |
| --- | --- | --- |
| `dot-tmux.conf` | `~/.tmux.conf` | tmux 主配置 |
| `restore-active-positions.sh` | `~/.tmux/scripts/restore-active-positions.sh` | resurrect 恢复后修正各窗口/会话的活动 pane 与活动窗口 |

## 配置要点

- 前缀键保持默认 `C-b`（为降低 VS Code 终端内的学习成本）。
- vi 风格 copy-mode 键位、鼠标开启、history-limit 20000、escape-time 0、true color。
- 窗口/pane 从 1 开始编号，`renumber-windows` 开启；状态栏在顶部。
- `prefix + |`/`-` 分屏、`prefix + h/j/k/l` 切换 pane、新开窗口/分屏继承当前路径。
- `prefix + m/M/e/E` 快捷布局，`prefix + r` 重载配置，`prefix + Y` 把最近复制内容写到 `/tmp/tmux-last-copy.txt`。

## 插件与持久化

通过 TPM 管理插件，插件源码位于 `~/.tmux/plugins/`（均为 GitHub 官方仓库 clone，未包含在本目录中，重新安装时由 TPM 拉取）：

- `tmux-plugins/tpm`
- `tmux-plugins/tmux-resurrect`：保存/恢复会话布局，已开启 pane 内容抓取（`@resurrect-capture-pane-contents 'on'`，`@resurrect-pane-contents-area 'full'`）。
- `tmux-plugins/tmux-continuum`：后台每 1 分钟自动保存（`@continuum-save-interval '1'`），tmux 启动时自动恢复（`@continuum-restore 'on'`）。

resurrect 存档默认在 `~/.local/share/tmux/resurrect/`（本机未改 `@resurrect-dir`），存档含机器状态与 pane 内容快照，不适合提交到公共仓库，故未归档进本目录。

`restore-active-positions.sh` 通过 `@resurrect-hook-post-restore-all` 挂接：detached 冷启动时没有 client，resurrect 的 `switch-client` 无法生效，该脚本改为服务器端 `select-pane`/`select-window`，恢复每个窗口的活动 pane 和每个会话的活动窗口，最后 `tmux wait-for -S codex-resurrect-restored` 释放等待方。

## 在新机器上部署

```bash
cp dot-tmux.conf ~/.tmux.conf
mkdir -p ~/.tmux/scripts
cp restore-active-positions.sh ~/.tmux/scripts/
chmod +x ~/.tmux/scripts/restore-active-positions.sh

# 安装 TPM 后启动 tmux，按 prefix + I 安装其余插件
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

注意：脚本中路径 `/home/chaofeng/...` 写死在 `dot-tmux.conf` 的 `@resurrect-hook-post-restore-all` 一行，迁移到不同用户名时需改为对应 home 目录。

## Git 状态

`.tmux.conf` 与本脚本在本机没有纳入任何 Git 仓库，也未推送到 GitHub；`~/.tmux/plugins/` 下的三个目录只是上游官方仓库的本地 clone。本交接包（`config-handoff/`）初始化为本地 Git 仓库，是否推送远端由用户决定。
