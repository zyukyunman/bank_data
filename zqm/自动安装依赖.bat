@echo off
chcp 65001 >nul
title 银行报表生成器 - 自动安装依赖

echo.
echo ==========================================
echo      银行报表生成器 - 自动安装依赖
echo ==========================================
echo.

echo 🔍 检查Python环境...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到Python环境！
    echo.
    echo 📥 请先安装Python 3.7或更高版本:
    echo    https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

echo ✅ Python环境检测成功
python --version

echo.
echo 📦 开始安装依赖包...
echo.

echo 🔄 升级pip到最新版本...
python -m pip install --upgrade pip

echo.
echo 📚 安装项目依赖包...
python -m pip install -r requirements.txt

if %errorlevel% neq 0 (
    echo.
    echo ❌ 依赖安装失败！请检查网络连接和Python环境
    echo.
    echo 💡 解决方案:
    echo    1. 检查网络连接
    echo    2. 尝试使用国内源: pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
    echo    3. 确保Python版本为3.7+
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ 所有依赖安装完成！
echo.
echo 🎯 现在可以运行报表生成器了:
echo    双击 "运行银行报表生成器.bat"
echo.
pause 