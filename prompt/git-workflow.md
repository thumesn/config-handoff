# Git 工作流规则 / Git Workflow Rules

本文件描述在 `/home/chaofeng` 下工作时，AI agent 完成任务后的 Git 使用约定。AGENTS.md 中只给出简要提醒，具体规则与更新以本文件为准。

## 1) 基本原则 / Basic Principles

- 以“一个任务至少对应一次提交”为默认习惯：在完成一个明确任务后，应尽快 `git add` + `git commit`。
- 只提交与本次任务相关的最小必要更改，避免将无关改动一起提交。
- 不重写已有历史（例如 `git reset --hard`、`git push --force` 等）除非用户明确要求。

## 2) 仓库位置与初始化 / Repo Location & Init

- 建议在**具体项目子目录**（例如 `/home/chaofeng/ppo`, `/home/chaofeng/agent-trust` 等）中使用 Git，而不是在整个 `/home/chaofeng` 根目录下初始化仓库。
- 当你在某个项目目录工作且发现：
  - 该目录还不是 Git 仓库（没有 `.git/`），并且
  - 后续会在此目录内持续开发或修改代码，
  则可以在此目录中执行一次 `git init` 来初始化仓库。
- 初始化仓库前，应在回复中简要说明：
  - 准备在哪个目录执行 `git init`；
  - 这样做的目的（例如“便于后续按任务提交和回滚改动”）。

示例说明（供 agent 在回复中使用）：

```text
当前目录还不是 Git 仓库，后续会在此目录内持续开发。我计划在该项目子目录下执行 `git init`，以便对每个任务的改动进行版本管理。
```

## 3) 任务完成后的标准流程 / Standard Flow After a Task

在判定“本次任务已完成”时，推荐执行以下步骤：

1. 查看当前状态：
   - 运行 `git status`，确认哪些文件发生了改动。
2. 选择需要提交的文件：
   - 只对与本任务相关的文件执行 `git add`；
   - 如发现与本任务无关的改动，应暂时保留未暂存状态，或在回复中说明并询问用户处理方式。
3. 创建提交：
   - 使用简洁明确的提交信息，建议包含：
     - 本次任务的简短描述（中英文均可）；
     - 如有需要，可附加模块名或路径。
   - 示例：
     - `git commit -m "feat: 更新 AGENTS.md，补充 Conda 与 tmux 规则"`
4. 在回复中说明提交情况：
   - 简要说明：
     - 是否创建了新的提交；
     - 提交的主要内容；
     - 提交信息（commit message）；
     - 如方便，可附加短哈希（例如 `abc1234`）。

示例说明（供 agent 在回复中使用）：

```text
本次任务相关的文件已通过 git 提交：
- commit: feat: 更新 AGENTS.md，新增 Conda 与 tmux 约定
- scope: 仅包含 AGENTS.md 和 prompt/ 下的相关规则文件
```

## 4) 没有改动或不宜提交的情况 / No Changes or Not Suitable to Commit

- 如果 `git status` 显示没有任何改动：
  - 在回复中说明“当前无改动，无需提交”，即可。
- 如果当前有大量历史改动与本任务无关：
  - 默认只对本次任务修改的文件执行 `git add`；
  - 不要擅自修改或提交用户之前的未提交改动；
  - 如情况复杂，可在回复中向用户说明并询问期望的提交策略。

## 5) 禁止性操作 / Forbidden Operations

除非用户明确要求，agent 不应执行：
- `git reset --hard`、`git clean -fd` 等可能丢失未提交改动的命令；
- `git push --force` 或任何会重写远端历史的操作；
- 修改或删除用户已有的 Tag、分支（如 `git branch -D` 等）。

如确有必要执行上述操作，必须在回复中详细说明风险，并获得用户确认。

## 6) 与 AGENTS.md 的关系 / Relation to AGENTS.md

- `AGENTS.md` 中仅提醒：任务完成后应及时 `git add` + `git commit` 并在回复中说明情况，如当前目录不是仓库且需要持续开发时可以先 `git init`。
- 本文件 `prompt/git-workflow.md` 提供完整的 Git 使用流程和注意事项；如与 `AGENTS.md` 存在不一致，以本文件为准。
