#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
验证新的基金缓存功能是否正确添加
"""

def verify_new_features():
    """验证新功能"""
    print("🔍 验证基金缓存功能的添加")
    print("=" * 50)
    
    try:
        # 导入主模块
        from stock_report_gui import StockReportGUI
        print("✅ 主模块导入成功")
        
        # 检查是否添加了新的方法
        required_methods = [
            'on_fund_selected',
            'on_manual_fund_code_changed', 
            'check_fund_cache',
            'load_fund_from_cache',
            'save_fund_to_cache',
            'get_or_fetch_jiangyin_data',
            'update_fund_cache_status',
            'show_fund_cache_info',
            'clear_fund_cache'
        ]
        
        # 创建临时实例检查方法
        import tkinter as tk
        root = tk.Tk()
        root.withdraw()  # 隐藏窗口
        
        app = StockReportGUI(root)
        
        print("\n📋 检查新增方法:")
        for method in required_methods:
            if hasattr(app, method):
                print(f"   ✅ {method}")
            else:
                print(f"   ❌ {method} - 缺失")
        
        # 检查新增属性
        print("\n📋 检查新增属性:")
        required_attrs = [
            'common_funds',
            'fund_list_var', 
            'fund_data_cache',
            'jiangyin_data_cache',
            'fund_cache_status_label'
        ]
        
        for attr in required_attrs:
            if hasattr(app, attr):
                print(f"   ✅ {attr}")
            else:
                print(f"   ❌ {attr} - 缺失")
        
        # 检查预设基金列表
        if hasattr(app, 'common_funds'):
            print(f"\n📋 预设基金列表 ({len(app.common_funds)}只):")
            for code, name in app.common_funds.items():
                print(f"   • {code}: {name}")
        
        root.destroy()
        
        print(f"\n✅ 功能验证完成")
        print(f"💡 新功能说明:")
        print(f"   • 支持从下拉列表选择常用基金")
        print(f"   • 基金数据按代码分别缓存")
        print(f"   • 江阴银行股价全局缓存复用")
        print(f"   • 缓存管理和状态显示")
        print(f"   • 切换基金/时间段时优先使用缓存")
        
    except Exception as e:
        print(f"❌ 验证失败: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    verify_new_features() 