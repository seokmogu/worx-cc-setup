---
name: worx-cc-setup
description: 신규 입사자 개발 환경 자동 설치 (Python, Git, uv, oh-my-claudecode, Chrome 확장). OS 자동 감지, 에러 자가 복구 포함.
---

# Worxphere 신규 입사자 개발 환경 자동 설치

This skill delegates to the `/worx-cc-setup` slash command which contains the full installation procedure.

When invoked, execute the slash command logic defined in `.claude/commands/worx-cc-setup.md`.

## Quick Reference

- OS detection: macOS (Darwin) / WSL (Linux + microsoft in /proc/version)
- Each step follows **Check -> Install -> Verify** with up to 3 retries
- Already-installed items are skipped
- Interactive steps (oh-my-claudecode, Chrome extension) require user input

## Installed Components

| Component | macOS | WSL |
|-----------|-------|-----|
| Homebrew | Yes | No |
| Python 3.12+ | Yes | Yes |
| Git | Yes | Yes |
| uv | Yes | Yes |
| Google Chrome | No | Yes |
| Korean locale | No | Yes |
| oh-my-claudecode | User input | User input |
| Chrome extension | User click | User click |
