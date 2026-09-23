# tmux 与长任务规则 / tmux Long-Running Jobs Rules

本文件描述在 `/home/chaofeng` 下工作时，AI agent 运行**需要显卡环境或预估时间较长**任务时，如何配合 `tmux` 与日志的约定。AGENTS.md 中只给出简要提醒，具体规则与更新以本文件为准。

## 1) 何时使用 tmux / When to Use tmux

在满足以下任一条件时，应考虑使用 `tmux` 运行命令：
- 任务需要使用 GPU / 显卡环境（例如深度学习训练、长时间推理）。
- 任务预估运行时间较长（例如超过 10–15 分钟，或你判断可能被中断会造成损失）。
- 任务会产生较多日志输出、后续需要排查或复现。

若只是快速脚本、一次性小命令，一般不需要进入 tmux。

## 2) 先申请 permission / Request Permission First

在启动 tmux 长任务之前，必须先向用户申请 permission，并说明：
- 计划执行的主要命令或脚本（用一句话概括即可）。
- 是否使用 GPU / 显卡，以及预估运行时间（大致范围即可，如“约 1 小时+”）。
- 日志保存位置（例如 `logs/runtime/xxx.log`）。

示例说明（供 agent 在回复中使用）：

```text
该任务需要使用 GPU 做较长时间训练（预估 1–2 小时）。我计划在 tmux 会话中运行，并将输出记录到 `logs/runtime/train_run.log`，便于中途中断和事后查看。请确认是否同意我这样执行？
```

只有在用户明确同意后，才可以：
- 激活对应的 conda 环境（如 `torch`），以及
- 启动 tmux 会话并运行长任务。

对于使用 GPU 的任务，在得到用户允许后、实际启动命令前，应：
- 先通过 `nvidia-smi` 等命令检查每张 GPU 当前的显存占用和利用率；
- 尽量选择当前最空闲的一张卡（如剩余显存最多、利用率最低）；
- 在回复中说明选择的 GPU 编号以及简要理由，例如：

```text
已使用 nvidia-smi 检查当前 GPU 负载，将在 GPU 1 上运行（该卡显存占用最低，当前利用率约 0%），并在 tmux 会话中启动任务。
```

## 3) 在 tmux 中运行并记录日志 / Run in tmux with Logging

在获得用户许可后，推荐的执行方式是：
- 创建或使用一个专门的 tmux 会话（如 `train`, `inference`, `server` 等）。
- 在 tmux 中运行的命令应将标准输出和错误输出**同步写入日志文件**，例如通过 `tee`。

一个典型模式（示意，一般由终端命令执行）：

```bash
tmux new -s train 'YOUR_COMMAND 2>&1 | tee -a logs/runtime/train.log'
```

要求：
- 日志文件放在合理的位置（推荐使用 `logs/runtime/` 目录及带含义的文件名，例如 `logs/runtime/train_YYYYMMDD.log`）。
- 日志应包含足够信息便于复现和排查（如关键配置、错误信息）。

## 4) 任务结束后的反馈 / After the Job

当 tmux 中的长任务结束或阶段性完成时，agent 在回复中应：
- 简要总结运行结果（成功 / 失败、是否有报错）。
- 指出对应日志文件路径（例如：`logs/runtime/train_20241210.log`）。
- 如日志过大，只需引用关键片段，而不在回复中整体展开。

## 5) tmux 不可用时的处理 / If tmux is Unavailable

如当前环境没有安装或无法使用 `tmux`：
- 仍需按“先申请 permission”的规则执行；
- 可直接在普通 shell 中运行命令，但依然推荐使用 `tee` 将输出写入日志文件；
- 在回复中说明“当前无法使用 tmux，仅通过普通终端 + 日志方式执行”。

## 6) 与 AGENTS.md 的关系 / Relation to AGENTS.md

- `AGENTS.md` 仅提醒：长时间或 GPU 相关任务需要申请 permission，并优先在 tmux 中运行且记录日志。
- 本文件 `prompt/tmux-jobs.md` 提供完整的 tmux 使用规则和推荐命令模式；如与 `AGENTS.md` 存在不一致，以本文件为准。
