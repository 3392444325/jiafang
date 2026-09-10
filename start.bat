@echo off
title Zhiyun - One Click Start

REM ============================================
REM 织云项目一键启动脚本
REM   后端: Spring Boot + MySQL  (端口 8080)
REM   前端: Vue 3 + Vite         (端口 5173)
REM 使用: 双击运行，或在 cmd 中执行 start.bat
REM ============================================

set MAVEN_BIN=D:\system\program\apache-maven-3.9.16\bin\mvn.cmd

echo.
echo [1/3] 检查 MySQL 服务 (MySQL80)...
sc query MySQL80 | find "RUNNING" >nul 2>&1
if %errorlevel% neq 0 (
    echo       MySQL 未运行，正在尝试启动（需管理员权限）...
    net start MySQL80
) else (
    echo       MySQL 已运行。
)

echo [2/3] 启动后端 Spring Boot (端口 8080)...
start "zhiyun-backend" cmd /k "cd /d %~dp0backend && %MAVEN_BIN% spring-boot:run"

echo [3/3] 启动前端 Vite (端口 5173)...
start "zhiyun-frontend" cmd /k "cd /d %~dp0frontend && npm run dev"

echo.
echo ==============================================
echo   全部服务已启动！
echo.
echo   前端地址:  http://localhost:5173
echo   后端地址:  http://localhost:8080
echo.
echo   提示: 后端首次编译约需 20-40 秒，请稍候再打开前端页面。
echo   提示: 关闭对应命令行窗口即可停止相应服务。
echo ==============================================
echo.
timeout /t 5 >nul
