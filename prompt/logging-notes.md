# 日志与笔记规则 / Logging & Notes Rules

本文件描述在 `/home/chaofeng` 下工作时，AI agent 如何常态化记录**核心思路**、**任务结果**与**运行输出**，避免不同类型内容混在同一文件中。AGENTS.md 中只给出简要提醒，具体规则与更新以本文件为准。

## 1) 目标 / Goals

- 将重要任务的思路与决策过程沉淀为结构化 Markdown，方便后续检索与作为上下文加载。
- 将任务最终结果与影响范围集中记录，便于追踪与复盘。
- 将运行时输出与人工笔记分开，避免 `notes`、`results`、训练日志、服务日志相互污染。

## 2) 文件位置 / File Locations

默认约定使用以下目录结构（如不存在，可在首次写入时创建）：

- 核心思路与过程：`logs/notes/YYYY-MM/YYYY-MM-DD-<task-slug>.md`
- 结果与结论：`logs/results/YYYY-MM/YYYY-MM-DD-<task-slug>.md`
- 运行输出：`logs/runtime/<meaningful-name>.log`

说明：
- `<task-slug>` 使用简短的 kebab-case 名称，例如 `update-log-policy`、`dst-world-reset`。
- 同一任务跨多轮继续时，优先复用已有同名文件并追加，而不是新建零散文件。
- 历史文件 `logs/agent-notes.md` 与 `logs/agent-results.md` 保留为归档，不再作为默认写入位置。

如某个具体项目有更细致的约定，可以在该项目子目录的 `AGENTS.md` 中覆盖路径。

## 3) 记录时机 / When to Log

对于以下类型的任务，建议在**任务结束时**进行记录：

- 涉及非 trivially 的设计、调研、重构、环境配置或调参等；
- 需要在后续任务中复用当前思路或结论；
- 用户明确要求记录过程或结果。

对于非常简单的一次性操作（如单行修正、微小文案修改），可以跳过记录。

## 4) 思路记录格式（notes） / Notes Format

在 `logs/notes/YYYY-MM/YYYY-MM-DD-<task-slug>.md` 中，建议按任务维护一个文件；同一任务多次继续时，继续在该文件中追加新的小节。推荐结构：

```markdown
## <日期> <项目/目录> - <任务简要标题>

- 背景：一句话说明任务背景或用户需求。
- 核心思路：3–5 条要点，说明主要判断、假设和决策路径。
- 关键操作：列出关键命令或文件（如 `ppo/train.py`、`pm2 start ...`）。
- 后续建议（可选）：需要在后续任务中注意或延续的点。
```

约定：
- 不需要逐步推理痕迹，只保留**对后续有价值**的思路摘要，避免冗长或重复内容；
- 文件采用追加模式，不重写已有内容；
- 若任务已经转入 `~/git/project/dev/active/[task-name]/` 的大型任务文档，则这里仅保留简短摘要和对应路径，不再重复记录大量细节。

## 5) 结果记录格式（results） / Results Format

在 `logs/results/YYYY-MM/YYYY-MM-DD-<task-slug>.md` 中，每次记录建议使用如下结构：

```markdown
## <日期> <项目/目录> - <任务结果标题>

- 主要改动：简要说明完成了什么（例如“更新 AGENTS.md，新增 pm2/conda 规则”）。
- 影响文件：列出关键文件路径（如 `AGENTS.md`, `prompt/conda-env.md`）。
- 提交信息：如已提交，记录 Git commit message 及可选短哈希。
- 验证情况：说明已运行的测试或检查（如有）。
```

约定：
- 聚焦“结果”和“影响范围”，避免重复粘贴详细日志；
- 如结果与某条笔记强相关，可在两边互相引用文件路径或标题；
- 如任务无实质改动但有重要结论，也应记录结论与验证情况。

## 6) 运行输出（runtime） / Runtime Output

运行日志不应再写进 `notes` 或 `results` 的 Markdown 中。训练、批处理、tmux 长任务、一次性批量脚本等输出，统一放在 `logs/runtime/` 下。

推荐命名：

- `logs/runtime/train_YYYYMMDD.log`
- `logs/runtime/infer_<model>_YYYYMMDD.log`
- `logs/runtime/<task-slug>.log`

约定：
- `runtime` 存机器输出，`notes` 存人工摘要，`results` 存任务结论；
- 在 `results` 中只引用关键日志路径与必要现象，不整段复制运行输出。

## 7) 与 Git 和 pm2 的关系 / Relation to Git and pm2

- 日志 Markdown 文件本身可以纳入 Git 版本管理，也可以按需要忽略；由用户在 `.gitignore` 中自行决定。
- 当任务涉及后端服务或长任务时：
  - 后端服务的启动与日志仍应遵守 `prompt/pm2-backend.md` 和 `prompt/tmux-jobs.md`；
  - 在 `results` 条目中可补充当前 pm2 进程名、端口、关键日志现象等信息；
  - 真正的大段输出仍放在 `logs/runtime/` 或 pm2 自身日志体系中。

## 8) 与大型任务文档的关系 / Relation to Large Task Docs

- `logs/notes/` 与 `logs/results/` 适合日常任务或大型任务的摘要。
- `~/git/project/dev/active/[task-name]/` 下的 `*-plan.md`、`*-context.md`、`*-tasks.md` 适合承载大型任务的连续上下文。
- 当一个任务已经进入大型任务模式时：
  - `notes` 里只写 3–6 行摘要；
  - 详细过程放在 `dev/active/[task-name]/` 目录中；
  - `results` 里记录阶段性产出、验证和影响范围。

## 9) 与 AGENTS.md 的关系 / Relation to AGENTS.md

- `AGENTS.md` 只要求：对非 trivial 任务，在完成后常态化将核心思路与结果分别记录到 `logs/notes/` 与 `logs/results/`，并将运行输出放在 `logs/runtime/`。
- 本文件 `prompt/logging-notes.md` 提供具体记录格式和示例；如与 `AGENTS.md` 存在不一致，以本文件为准。
