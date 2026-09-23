# config-handoff / 配置交接包

用途：把本机（`/home/chaofeng`，用户 `chaofeng`）的智能体工作约定与 tmux 配置集中归档，供下一位智能体或另一台机器直接读取、按图索骥。整理时间：2026-09-23。

## 目录结构

```
config-handoff/
├── AGENTS.md                  # 本机 ~/AGENTS.md 的副本：智能体工作总约定
├── prompt/                    # 本机 ~/prompt/ 的副本：AGENTS.md 引用的细则文件
│   ├── conda-env.md           #   Conda 环境选择规则（torch / paper-env）
│   ├── git-workflow.md        #   任务级 git add + commit 约定
│   ├── large-tasks.md         #   大型任务的 plan/context/tasks 三文档约定
│   ├── logging-notes.md       #   logs/notes、logs/results、logs/runtime 记录规范
│   ├── pm2-backend.md         #   后端服务用 pm2 管理的约定与端口规则
│   └── tmux-jobs.md           #   GPU/长任务先申请 permission 再进 tmux 的规则
├── tmux/
│   ├── README.md              #   tmux 配置说明（键位、插件、持久化、部署步骤）
│   ├── dot-tmux.conf          #   ~/.tmux.conf 副本
│   └── restore-active-positions.sh  # ~/.tmux/scripts/ 下的自定义恢复脚本
└── README.md                  # 本文件
```

## 给接手智能体的导读顺序

1. 先读 `AGENTS.md`：它是总约定，规定了回复语言、补丁规范、审批、日志、Git 工作流等。
2. `AGENTS.md` 多处注明"如与本节不一致，以 `prompt/xxx.md` 为准"，需要细节时读 `prompt/` 下对应文件。
3. 要了解或迁移 tmux 环境时读 `tmux/README.md`；插件（TPM/resurrect/continuum）不在包内，按其中说明重新安装。
4. 本机特有信息：代理端口 10808/10809、conda 环境名 `torch`/`paper-env`、大型任务文档根路径 `~/git/project/dev/active/`、脚本中写死的 `/home/chaofeng` 路径。

## Git / GitHub 状态

- 本机 `/home/chaofeng` 不是 Git 仓库，`~/.tmux.conf`、`~/AGENTS.md`、`~/prompt/` 均未提交到 GitHub。
- 本目录已 `git init` 为独立仓库，远端为 `git@github.com:thumesn/config-handoff.git`（GitHub 用户 `thumesn`），已推送 `main` 分支。
- 同步方式：本包是"快照副本"，源文件改动后需重新 `cp` 对应文件进本目录再提交。
