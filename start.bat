@echo off
chcp 65001 >nul
title Zhiyun - One Click Start

REM 织云项目一键启动脚本
REM   后端: Spring Boot + MySQL  (端口 8080)
REM   前端: Vue 3 + Vite         (端口 5173)
REM 使用: 双击运行，或在 cmd 中执行 start.bat

REM Maven 路径：优先用本机实际路径，找不到则回退到 PATH
set "MAVEN_BIN=D:\apache-maven-3.9.16\bin\mvn.cmd"
if not exist "%MAVEN_BIN%" set "MAVEN_BIN=mvn.cmd"

REM JAVA_HOME：Spring Boot 3 需要 JDK 17+
set "JAVA_HOME=C:\Program Files\Java\JDK"

echo.
echo [1/4] 检查 MySQL 服务 (MySQL80)...
sc query MySQL80 | find "RUNNING" >nul 2>&1
if errorlevel 1 (
    echo       MySQL 未运行，正在尝试启动（可能需要管理员权限）...
    net start MySQL80 >nul 2>&1
) else (
    echo       MySQL 运行中。
)

echo [2/4] 清理端口占用 (8080 / 5173)...
powershell -NoProfile -Command "Get-NetTCPConnection -LocalPort 8080,5173 -State Listen -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }"

echo [3/4] 启动后端 Spring Boot (端口 8080)...
start "zhiyun-backend" cmd /k "cd /d %~dp0backend && %MAVEN_BIN% spring-boot:run"

echo [4/4] 启动前端 Vite (端口 5173)...
start "zhiyun-frontend" cmd /k "cd /d %~dp0frontend && npm run dev"

echo.
echo ==============================================
echo   全部服务启动中...
echo.
echo   前端地址:  http://localhost:5173
echo   后端地址:  http://localhost:8080/api
echo.
echo   提示: 后端首次启动约需 20-40 秒，请稍候再访问前端页面。
echo   提示: 关闭对应的命令行窗口即可停止对应服务。
echo ==============================================
echo.
ping -n 6 127.0.0.1 >nul
