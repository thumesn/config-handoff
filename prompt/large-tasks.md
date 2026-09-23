# 大型任务文档规则 / Large Task Documentation Rules

本文件描述在 `/home/chaofeng` 下进行**大型、多步骤任务**时，如何为每个任务建立独立的文档目录与 Markdown 文件，便于中途暂停/恢复和作为上下文加载使用。AGENTS.md 中只给出简要提醒，具体规则与更新以本文件为准。

根路径约定：`~/git/project/dev/active/`（即 `/home/chaofeng/git/project/dev/active/`）

---

## 1) 开始大型任务 / Start a Large Task

当从规划模式退出并接受计划时（即明确这是一个需要多轮执行的大任务）：

1. 创建任务目录  
   ```bash
   mkdir -p ~/git/project/dev/active/[task-name]/
   ```

2. 在任务目录中创建文档  
   - `[task-name]-plan.md`  
     - 已接受的计划内容（可直接粘贴规划输出的最终版本）  
   - `[task-name]-context.md`  
     - 关键文件及路径  
     - 重要决策与理由  
     - 关键配置或环境信息  
   - `[task-name]-tasks.md`  
     - 工作清单（Todo/Doing/Done 等），用简短条目表示具体子任务

3. 定期更新  
   - 执行子任务后，应立即在 `[task-name]-tasks.md` 中标记完成情况；  
   - 如计划发生重大调整，在 `[task-name]-plan.md` 中追加“更新记录”或新计划小节，而不是覆盖原始计划。

---

## 2) 继续任务 / Continue a Large Task

当需要继续之前已存在的大型任务时：

1. 查找任务目录  
   - 在 `~/git/project/dev/active/` 下查找已有的 `[task-name]/` 目录；
   - 如有多个任务目录，先确认本次要继续的是哪一个。

2. 阅读任务文档  
   - 在继续之前，至少阅读该任务目录内的三个文件：
     - `[task-name]-plan.md`（了解总体计划）  
     - `[task-name]-context.md`（回顾关键文件与决策）  
     - `[task-name]-tasks.md`（确认当前进度和下一步）

3. 更新“最后更新”时间戳  
   - 在上述任一文件（通常是 `[task-name]-tasks.md` 或 `[task-name]-context.md`）中更新一个简单的“最后更新”时间戳，例如：
     ```markdown
     最后更新：2025-12-10
     ```
   - 之后再开始新的改动与记录。

---

## 3) 与 logs/ 下日常笔记的关系 / Relation to logs/*

- `dev/active/[task-name]/` 目录用于**单个大型任务的结构化文档**（计划、上下文、子任务）。  
- `logs/notes/` 与 `logs/results/` 仍用于**跨任务的日常摘要与结果归档**。  
- `logs/runtime/` 用于运行输出，不承担任务总结作用。  
- 对于大型任务：
  - 任务内的细节记录放在该任务的三个文件中；  
  - 全局日志中可以只写一条简短摘要，并指向对应的 `[task-name]` 目录。

---

## 4) 与 AGENTS.md 的关系 / Relation to AGENTS.md

- `AGENTS.md` 要求：在处理大型、多步骤任务时，应按照本文件的流程，在 `~/git/project/dev/active/` 下为每个任务建立独立目录和三个 Markdown 文件，并在继续任务前阅读和更新它们。  
- 本文件 `prompt/large-tasks.md` 提供具体目录结构和文件内容建议；如与 `AGENTS.md` 存在不一致，以本文件为准。
