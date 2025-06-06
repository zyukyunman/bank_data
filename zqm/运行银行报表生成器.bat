@echo off
chcp 65001 >nul
title 银行股票分析报表生成器

echo.
echo ==========================================
echo       银行股票分析报表生成器
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
    echo 💡 安装完成后，请重新运行此程序
    echo.
    pause
    exit /b 1
)

echo ✅ Python环境检测成功
python --version

echo.
echo 🔍 检查pip工具...
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ pip工具异常，正在修复...
    python -m ensurepip --upgrade
    if %errorlevel% neq 0 (
        echo ❌ pip修复失败，请重新安装Python
        pause
        exit /b 1
    )
)

REM 获取当前pip版本
for /f "tokens=2" %%i in ('python -m pip --version 2^>nul') do set current_pip_version=%%i
echo ✅ pip工具正常，版本: %current_pip_version%

echo.
echo 🔍 智能检查必要依赖包...

REM 检查关键包是否已安装且版本合适
python -c "import pandas, numpy, tushare, openpyxl; import pandas as pd; import numpy as np; exit(0 if tuple(map(int, pd.__version__.split('.')[:2])) >= (1, 3) and tuple(map(int, np.__version__.split('.')[:2])) >= (1, 20) else 1)" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 所有依赖包检查通过，版本合适
    goto :run_program
)

echo ⚠️ 检测到缺少或版本过旧的依赖包
echo.

REM 逐个检查并显示状态
python -c "import pandas; print('✅ pandas:', pandas.__version__)" 2>nul || echo ❌ pandas: 未安装或版本过旧
python -c "import numpy; print('✅ numpy:', numpy.__version__)" 2>nul || echo ❌ numpy: 未安装或版本过旧  
python -c "import tushare; print('✅ tushare:', tushare.__version__)" 2>nul || echo ❌ tushare: 未安装
python -c "import openpyxl; print('✅ openpyxl:', openpyxl.__version__)" 2>nul || echo ❌ openpyxl: 未安装

echo.
set /p install_deps="是否现在自动安装/升级依赖包？(Y/n): "
if /i "%install_deps%"=="n" (
    echo.
    echo 💡 请手动安装依赖包后再运行:
    echo    pip install -r requirements.txt
    echo.
    pause
    exit /b 1
)

echo.
echo 📦 正在智能安装/升级依赖包...

REM 检查pip版本是否需要升级
python -c "import pip; exit(0 if tuple(map(int, pip.__version__.split('.')[:2])) >= (20, 0) else 1)" >nul 2>&1
if %errorlevel% neq 0 (
    echo 🔄 pip版本较旧，先升级pip...
    python -m pip install --upgrade pip
    if %errorlevel% equ 0 (
        echo ✅ pip升级成功
    ) else (
        echo ⚠️ pip升级失败，继续使用当前版本
    )
) else (
    echo ✅ pip版本满足要求，跳过升级
)

echo.
echo 📚 安装项目依赖...

REM 优先使用requirements.txt
if exist requirements.txt (
    echo 📄 使用requirements.txt批量安装...
    python -m pip install -r requirements.txt --upgrade
    
    if %errorlevel% equ 0 (
        echo ✅ 批量安装成功!
        goto :verify_deps
    )
    
    echo ⚠️ 批量安装失败，尝试逐个安装...
)

REM 逐个安装关键包
echo 📦 逐个安装关键依赖包...
python -m pip install "pandas>=1.3.0" "numpy>=1.20.0" "tushare>=1.2.89" "openpyxl>=3.0.9"

:verify_deps
echo.
echo 🔍 验证依赖安装...
python -c "import pandas, numpy, tushare, openpyxl; print('✅ 所有依赖验证通过!')" 2>nul
if %errorlevel% neq 0 (
    echo.
    echo ❌ 依赖安装验证失败！
    echo.
    echo 💡 请尝试手动安装:
    echo    pip install pandas numpy tushare openpyxl
    echo.
    echo 或使用国内源:
    echo    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pandas numpy tushare openpyxl
    echo.
    pause
    exit /b 1
)

echo ✅ 依赖检查通过

:run_program
echo.
echo 🚀 正在启动银行报表生成器...
echo.

python run_bank_report.py

echo.
echo 程序已结束，按任意键退出...
pause >nul 