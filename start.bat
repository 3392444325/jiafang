@echo off
title Zhiyun - One Click Start

REM ============================================
REM ֯����Ŀһ�������ű�
REM   ���: Spring Boot + MySQL  (�˿� 8082)
REM   ǰ��: Vue 3 + Vite         (�˿� 5173)
REM ʹ��: ˫�����У����� cmd ��ִ�� start.bat
REM ============================================

set MAVEN_BIN=D:\system\program\apache-maven-3.9.16\bin\mvn.cmd

echo.
echo [1/3] ��� MySQL ���� (MySQL80)...
sc query MySQL80 | find "RUNNING" >nul 2>&1
if %errorlevel% neq 0 (
    echo       MySQL δ���У����ڳ��������������ԱȨ�ޣ�...
    net start MySQL80
) else (
    echo       MySQL �����С�
)

echo [2/3] ������� Spring Boot (�˿� 8082)...
start "zhiyun-backend" cmd /k "cd /d %~dp0backend && %MAVEN_BIN% spring-boot:run"

echo [3/3] ����ǰ�� Vite (�˿� 5173)...
start "zhiyun-frontend" cmd /k "cd /d %~dp0frontend && npm run dev -- --host"

echo.
echo ==============================================
echo   ȫ��������������
echo.
echo   ǰ�˵�ַ:  http://localhost:5173
echo   ��˵�ַ:  http://localhost:8082
echo   ����������: http://����IP:5173  (ͬһWiFi�ĵ���/�ֻ���ֱ�Ӵ򿪣�����IP�� ipconfig �鿴)
echo.
echo   ��ʾ: ����״α���Լ�� 20-40 �룬���Ժ��ٴ�ǰ��ҳ�档
echo   ��ʾ: �رն�Ӧ�����д��ڼ���ֹͣ��Ӧ����
echo ==============================================
echo.
timeout /t 5 >nul
