# AGENTS.md

本文件为在本仓库中工作的智能体（agents）提供约定与操作指南。
Instructions for AI agents working in this repository.

TL;DR / 快速上手
- 跟随用户语言回复，优先表述对用户决策最重要的信息。默认不要分点铺陈或长篇展开；细节先作简要概括，待用户追问后再根据其需求决定回答的详细程度。
- 优先小步打补丁，只改与任务相关的最小集合。
- 如仓库已有测试/构建脚本，改动后优先运行相关脚本进行验证。

— Scope/适用范围 —
- 本文件作用域为本仓库根目录及其子目录内的所有文件与任务。
- 指南面向基于 Codex CLI 的代理工作流（终端交互、打补丁、最小化更改）。

## 1) Conda Environments / Conda 环境
- 涉及 Python 的任务前，应先确认当前使用的 conda 环境，避免在不合适的环境中安装依赖或运行脚本。
- 如任务需要 PyTorch 或深度学习训练/推理，优先在 `torch` 环境中执行（例如：`conda activate torch`）。
- 如任务需要启动/开发服务器或运行论文相关服务，优先在 `paper-env` 环境中执行（例如：`conda activate paper-env`）。
- 允许代理在需要时自行激活合适的环境，但在切换前应在回复中简要说明将使用的环境及用途。
- 如需对环境本身进行修改（例如 `conda install`/`pip install`、卸载或升级依赖），必须先暂停操作，在回复中说明计划并征求用户明确同意后再执行。
- 本节为 Conda 相关约定的摘要；详细规则与后续更新请参考 `prompt/conda-env.md`。如两者存在不一致，以 `prompt/conda-env.md` 为准。

## 2) Tmux Jobs / tmux 与长任务
- 当任务需要使用 GPU / 显卡环境，或预估运行时间较长（例如超过 10–15 分钟）时，应在执行前向用户申请 permission，说明计划命令、预估时长与资源使用情况。
- 在用户明确同意后，优先在 tmux 会话中运行此类命令，避免会话中断造成损失。
- 运行时应将 tmux 会话内的标准输出和错误输出同步写入日志文件（推荐放在 `logs/runtime/` 目录下），以便后续排查与复现。
- 对于使用 GPU 的任务，在启动前应先检查每张 GPU 当前负载（例如通过 `nvidia-smi` 查看显存占用和利用率），尽量选择当前最空闲的一张卡，并在回复中说明所选 GPU 及选择依据。
- 详细规则与推荐命令模式请参考 `prompt/tmux-jobs.md`；如与本节存在不一致，以 `prompt/tmux-jobs.md` 为准。

## 3) Backend Services / 后端服务（pm2）
- 对于需要长期运行的后端服务（如 Web API、论文相关服务等），应优先使用 `pm2` 启动和管理，而不是在前台直接运行命令。
- 查看与排查后端服务状态时，应使用 `pm2 list` 和 `pm2 logs <service-name>` 等命令，而不是零散地读取日志文件。
- 服务绑定端口前应先确认目标端口未被占用；如需更换端口，优先改端口而不是终止占用方进程；启动后应在回复中说明实际绑定的端口。详细规则见 `prompt/pm2-backend.md` 的端口小节。
- 启动前如涉及 Python / GPU，仍需遵守 `prompt/conda-env.md` 与 `prompt/tmux-jobs.md` 中的环境与资源选择规则。
- 详细 pm2 使用规范与示例请参考 `prompt/pm2-backend.md`；如与本节存在不一致，以 `prompt/pm2-backend.md` 为准。

## 4) Logging & Notes / 日志与笔记
- 对于非 trivial 的任务，应在完成后分别记录：
  - 核心思路与主要决策过程：`logs/notes/YYYY-MM/YYYY-MM-DD-<task-slug>.md`
  - 结果与影响范围：`logs/results/YYYY-MM/YYYY-MM-DD-<task-slug>.md`
- 运行日志（训练、批处理、tmux 输出等）统一放在 `logs/runtime/` 下，避免与笔记混放。
- 记录时保持简洁，只写对后续有价值的要点，避免冗长或重复的信息。
- 默认按“每个任务一对文件”组织；继续同一任务时，优先复用已有同名文件并追加，不再把所有任务混写到两个总文件中。
- 历史文件 `logs/agent-notes.md` 与 `logs/agent-results.md` 视为归档，不再作为默认追加目标；只有用户明确要求补录历史时才继续写入。
- 调研/分析类结论笔记默认输出到 `logs/research-notes/`；用于 `research-note-wrap` 这类把方案对比、判断依据和关键结论沉淀为 Markdown 的场景。
- 会话交接文件默认输出到 `logs/handoffs/`；用于 `session-handoff` 这类保存现场、恢复路径、未完成任务和注意事项的场景。
- 对于大型、多步骤任务（需要多轮执行和切换），应按 `prompt/large-tasks.md` 的约定，在 `~/git/project/dev/active/[task-name]/` 下维护专门的 `*-plan.md`、`*-context.md`、`*-tasks.md` 三个文档，并在继续任务前阅读和更新。
- 具体记录格式和示例请参考 `prompt/logging-notes.md` 与 `prompt/large-tasks.md`；如与本节存在不一致，以对应的 prompt 文件为准。

## 5) Skills / 技能使用（渐进式披露）
- 本文件只记录 skill 的触发场景、默认路径和少量全局约束；具体流程以对应 skill 的 `SKILL.md` 为准，避免把长流程复制进 `AGENTS.md`。
- 当前会话收尾、总结实际完成内容、风险和下一步时，使用 `session-wrap`。
- 需要保存现场、下次继续、上下文快满、或让新会话无缝接手时，使用 `session-handoff`；交接文件默认写入 `logs/handoffs/`。
- 调研/分析/方案对比需要沉淀为结论笔记时，使用 `research-note-wrap`；结论笔记默认写入 `logs/research-notes/`。
- 需要基于当天 commit 生成日报时，使用 `commit-daily-summary`；需要按项目汇总当天 Codex 工作时，使用 `project-daily-summary`。
- 多 worktree、多分支、多会话需要只读收口盘点时，使用 `worktree-closeout`。

## 6) Patches / 打补丁规范（`apply_patch`）
- 原则：小步安全修改；只改与任务相关的最小集；根治问题而非权宜修补。
- 不做：
  - 不引入无关重构或风格化改动；不新增版权/许可证头；不随意改名。
  - 不使用单字母变量名（除非上下文已有一致约定）。
- 文件引用：在输出中使用可点击路径与定位（例如 `src/app.ts:42`）。
- 大文件读取：分块（≤ 250 行/次）；搜索优先 `rg`（若缺失再降级）。
- 涉及删除文件、移动大量文件或大范围重构时，必须在回复中提前说明计划，并征求用户确认后再执行。
- 新增文件时，应简要说明用途及放置位置的理由，确保与现有目录结构一致。
- 当实现方案或任务方向发生变化时，应及时清理不再使用的代码、配置和注释，避免在仓库中保留过时实现。

补丁示例（片段）：
```
*** Begin Patch
*** Update File: src/main.ts
@@
- old line
+ new line
*** End Patch
```

## 7) Sandbox & Approvals / 沙箱与审批
- 默认环境（可能随会话变化）：`workspace-write` 文件系统、网络可用、审批模式 `on-request`。
- 如关键命令因沙箱受限失败，可在请求中说明原因并申请提升权限（提供 1 句理由）。
- 潜在破坏性操作（删除、重置、覆盖）必须获得显式同意。

## 8) Git Workflow / Git 工作流
- 默认习惯：每完成一个明确任务后，应尽快执行一次与该任务对应的 `git add` + `git commit`，便于追踪改动。
- 提交时只包含与本任务相关的最小必要改动，避免把无关修改一并提交。
- 如本次任务替换或废弃了旧实现，应在提交前清理冗余代码和文件，使提交后的状态保持简洁明了。
- 在回复中简要说明本次提交情况（是否提交、提交信息、主要改动范围，如有可附上短哈希）。
- 如当前目录还不是 Git 仓库且后续会在该目录持续开发，可以先在项目子目录中执行 `git init`，并在回复中说明这样做的目的。
- 详细规则与推荐流程请参考 `prompt/git-workflow.md`；如与本节存在不一致，以 `prompt/git-workflow.md` 为准。

## 9) Validation / 校验与质量
- 若项目已有测试或构建脚本（可在仓库文档或脚本目录中查找），改动后优先运行与本次改动最相关且执行时间较短的校验脚本。
- 输出前进行自检：是否最小化更改、是否遗漏文档、是否引入外部依赖；如不确定有哪些脚本可用，应在回复中说明假设，并提示用户补充验证信息。
- 发现不相关的既有缺陷可在结果中轻描淡写地标注，但不擅自修复。

## 10) Web Browsing & Citations / 联网与引用（如需要）
- 对最新、易变或高风险信息（法规/价格/新闻/接口），在依赖其结论前应联网核实，并在关键结论处附引用。
- 遵守版权限制，不粘贴长段原文；如信息存在明显争议或多种说法，应简要说明主要不同观点。

### Proxy / 本机代理（10809）
- 本机有可用代理：HTTP 代理 `http://127.0.0.1:10809`，SOCKS5 代理 `socks5://127.0.0.1:10808`。
- 默认先尝试直连；当外部访问失败、超时或明显被限制时（典型如 GitHub raw / pip / npm / huggingface 等国外资源），切换为走代理重试，并在回复中说明使用了代理。
- 常见用法：
  - curl：`curl -x http://127.0.0.1:10809 ...`
  - 环境变量：`https_proxy=http://127.0.0.1:10809 http_proxy=http://127.0.0.1:10809 <command>`（对 pip/npm/git 等多数工具生效）
  - git：`git -c http.proxy=http://127.0.0.1:10809 ...`（仅对单次命令生效，不改全局配置）
- 不要长期写入全局代理配置（如 `git config --global http.proxy` 或 shell rc），除非用户明确要求；默认按命令粒度注入。
- `10808`/`10809` 端口被代理占用，其他服务不要绑定这两个端口（见 `prompt/pm2-backend.md` 端口规则）。

## 11) Style Guide / 代码与文档风格
- 与现有风格保持一致，命名与结构尽量延续仓库中相同模块的模式。
- 如仓库已有 `.editorconfig`、格式化或 Lint 配置，应优先遵循；不要自发引入新的格式化器。
- 需要更细粒度约定时，请在对应子目录新增/更新 `AGENTS.md`，并以子目录文件为准。

## 12) Quick Checklist / 快速检查清单
- 若任务涉及 Python 或 GPU，是否已按 `prompt/conda-env.md` 和 `prompt/tmux-jobs.md` 选择环境、GPU，并将运行输出记录到 `logs/runtime/`？
- 若本次启动了后端服务，是否通过 `pm2` 管理，并在回复中说明了进程名和查看日志的方式？
- 本次任务完成后，是否已运行必要的校验脚本，并按约定执行 `git add` + `git commit`，在回复中说明提交情况？
- 对于非 trivial 任务，是否已在 `logs/notes/` 与 `logs/results/` 下记录本次的核心思路与结果？
- 若本次是调研/分析结论沉淀，是否已按默认路径写入 `logs/research-notes/`？
- 若本次需要保存交接现场，是否已按默认路径写入 `logs/handoffs/`？

## 13) Codex Global Prompts / .codex 目录
- `.codex/` 由 Codex CLI 管理，现有的 `config.toml`、`auth.json` 等文件默认不修改；本指南仅约定在其中新增自己的模板文件和子目录。
- 约定在 `.codex/prompts/` 下维护全局可复用的模板库：
  - `.codex/prompts/agents/`：通用 agent 角色卡（例如 `code-architecture-reviewer.md`、`refactor-planner.md` 等）。
  - `.codex/prompts/skills/`：跨项目的开发指南与技能文档（可从 `claude-code-infrastructure-showcase/.claude/skills/` 迁移并按需改写）。
  - `.codex/prompts/commands/`：工作流命令模板（例如 dev-docs 相关命令）。
- 使用约定：当用户显式提到某个 agent/skill/command 名称时，优先在 `.codex/prompts/**` 下查找同名 `.md` 文件并按其中说明执行；如当前仓库内也有同名 `prompt/` 下的模板，则以仓库内版本为准。
- 从 `claude-code-infrastructure-showcase/.claude/{agents,skills,commands}` 迁移内容时，只复制需要的文件，并在首次使用前将文案从 Claude 语境调整为 Codex 语境，避免直接改动原仓库。

——
如需调整本指南或为子目录定制额外约定，请在对应目录新增/更新 `AGENTS.md`，更深层目录的约定优先生效。
