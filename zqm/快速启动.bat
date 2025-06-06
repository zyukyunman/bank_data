@echo off
chcp 65001 >nul
title 银行报表生成器 - 快速启动

echo.
echo ==========================================
echo       银行报表生成器 - 快速启动
echo ==========================================
echo.

REM 快速检查Python环境
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到Python环境！
    echo    请使用 "一键安装和运行.bat" 进行完整安装
    pause
    exit /b 1
)

REM 快速检查关键依赖
python -c "import pandas, numpy, tushare, openpyxl" >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️ 缺少必要依赖包！
    echo.
    echo 💡 请选择以下方式之一:
    echo    1. 双击 "一键安装和运行.bat" (推荐)
    echo    2. 双击 "运行银行报表生成器.bat" (自动安装依赖)
    echo    3. 手动运行: pip install pandas numpy tushare openpyxl
    echo.
    pause
    exit /b 1
)

REM 检查程序文件
if not exist run_bank_report.py (
    echo ❌ 未找到主程序文件！
    pause
    exit /b 1
)

if not exist config.py (
    echo ❌ 未找到配置文件 config.py！
    echo    请确保包含有效的 TUSHARE_TOKEN
    pause
    exit /b 1
)

echo ✅ 环境检查通过，启动程序...
echo.

REM 直接运行程序
python run_bank_report.py

echo.
echo 程序执行完成，按任意键退出...
pause >nul 