# DFLU - Discord Fix Loop Update 🛠️

![DFLU](https://img.shields.io/badge/DFLU-Tool-cyan?style=for-the-badge)
![Windows](https://img.shields.io/badge/OS-Windows-blue?style=for-the-badge)

[🇷🇺 Русский](#-русская-версия) | [🇺🇸 English](#-english-version)

---

## 🇺🇸 English Version

A surgical, automated, and aesthetic CLI tool to fix the infamous "Discord Infinite Update Loop" and silent background crashes on Windows.

### ⚠️ The Problem
Sometimes, Discord downloads a corrupted update package. When `Update.exe` tries to launch it, the executable instantly crashes (exit code 1) and closes without any visible errors. The user is left clicking the Discord icon with absolutely nothing happening.

### ✨ The Solution
**DFLU** is a polyglot Batch/PowerShell script that fixes your Discord installation in seconds *without reinstalling* and *without losing your login/settings*. 

It automatically:
1. Detects your Discord AppData folder.
2. Identifies the broken update and the previous working backup.
3. Surgically copies the working core files into the new update folder.
4. Purges old garbage folders to free up disk space.
5. Wipes the Discord Cache (fixes gray/black screen issues).
6. Auto-launches Discord immediately after the fix.

### 🚀 Usage

**Fast Method (One-Line Command)**
Open Windows PowerShell (Win + R -> type `powershell` -> Enter) and paste the following command:
```powershell
irm https://raw.githubusercontent.com/sirt-sirt/DFLU-Discord-Fix-Loop-Update/main/Fix-Discord.bat -outf $env:TEMP\Fix-Discord.bat; & $env:TEMP\Fix-Discord.bat
```

**Manual Method**
1. Download [`Fix-Discord.bat`](Fix-Discord.bat).
2. Double-click to run.
3. Follow the minimal interactive prompts (or just mash `Enter` to use the defaults).
4. Enjoy your revived Discord!

---

## 🇷🇺 Русская Версия

Точечный, автоматизированный и эстетичный CLI-инструмент для починки "бесконечного обновления" и невидимых крашей Discord при запуске на Windows.

### ⚠️ Проблема
Иногда Discord скачивает битое обновление. Когда `Update.exe` пытается его запустить, процесс моментально закрывается без каких-либо ошибок. В итоге пользователь жмет на ярлык Дискорда, но ничего не происходит (или обновление уходит в бесконечный цикл).

### ✨ Решение
**DFLU** — это скрипт (Batch + PowerShell), который чинит Дискорд за пару секунд *без переустановки* и *без сброса аккаунта*.

Что он делает:
1. Автоматически находит папку Discord.
2. Находит сломанное обновление и рабочую резервную копию (предыдущую версию).
3. Точечно копирует рабочие файлы в сломанную папку обновления.
4. Удаляет старые папки с мусором, чтобы освободить место.
5. Очищает кэш Дискорда (решает проблему серого/черного экрана).
6. Автоматически запускает Discord после успешной починки.

### 🚀 Как использовать

**Быстрый способ (Команда в одну строку)**
Открой PowerShell (Win + R -> введи `powershell` -> Enter) и вставь эту команду:
```powershell
irm https://raw.githubusercontent.com/sirt-sirt/DFLU-Discord-Fix-Loop-Update/main/Fix-Discord.bat -outf $env:TEMP\Fix-Discord.bat; & $env:TEMP\Fix-Discord.bat
```

**Ручной способ**
1. Скачай файл [`Fix-Discord.bat`](Fix-Discord.bat).
2. Запусти его двойным кликом.
3. Ответь на пару вопросов в терминале (или просто жми `Enter`, чтобы использовать стандартные настройки).
4. Радуйся живому Дискорду!

---
*Created because Discord updates break too often.*
