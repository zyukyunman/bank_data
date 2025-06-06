#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
加载中对话框组件
"""

import tkinter as tk
from tkinter import ttk
import threading
import time

class LoadingDialog:
    """加载中对话框"""
    
    def __init__(self, parent, title="加载中...", message="正在处理，请稍候..."):
        self.parent = parent
        self.title = title
        self.message = message
        self.dialog = None
        self.progress_var = None
        self.status_var = None
        self.is_cancelled = False
        self.animation_running = False
        
    def show(self):
        """显示加载对话框"""
        # 创建模态对话框
        self.dialog = tk.Toplevel(self.parent)
        self.dialog.title(self.title)
        self.dialog.geometry("400x200")
        self.dialog.resizable(False, False)
        
        # 设置为模态
        self.dialog.transient(self.parent)
        self.dialog.grab_set()
        
        # 居中显示
        self.dialog.update_idletasks()
        x = (self.dialog.winfo_screenwidth() // 2) - (self.dialog.winfo_width() // 2)
        y = (self.dialog.winfo_screenheight() // 2) - (self.dialog.winfo_height() // 2)
        self.dialog.geometry(f"+{x}+{y}")
        
        # 设置样式
        self.dialog.configure(bg='#f0f0f0')
        
        # 创建主框架
        main_frame = tk.Frame(self.dialog, bg='#f0f0f0', padx=30, pady=30)
        main_frame.pack(fill='both', expand=True)
        
        # 标题
        title_label = tk.Label(main_frame, text=self.title, 
                              font=('微软雅黑', 14, 'bold'),
                              bg='#f0f0f0', fg='#2c3e50')
        title_label.pack(pady=(0, 15))
        
        # 状态信息
        self.status_var = tk.StringVar(value=self.message)
        status_label = tk.Label(main_frame, textvariable=self.status_var,
                               font=('微软雅黑', 10),
                               bg='#f0f0f0', fg='#34495e')
        status_label.pack(pady=(0, 20))
        
        # 进度条
        self.progress_var = tk.DoubleVar()
        progress_bar = ttk.Progressbar(main_frame, 
                                      variable=self.progress_var,
                                      mode='determinate',
                                      length=300)
        progress_bar.pack(pady=(0, 15))
        
        # 动画进度条（当进度未知时使用）
        self.indeterminate_progress = ttk.Progressbar(main_frame,
                                                     mode='indeterminate',
                                                     length=300)
        
        # 取消按钮
        cancel_button = tk.Button(main_frame, text="取消",
                                 command=self.cancel,
                                 font=('微软雅黑', 9),
                                 bg='#e74c3c', fg='white',
                                 relief='flat', padx=20, pady=5)
        cancel_button.pack(pady=(10, 0))
        
        # 开始动画
        self.start_animation()
        
        return self.dialog
    
    def start_animation(self):
        """开始动画效果"""
        self.animation_running = True
        self.indeterminate_progress.pack(pady=(0, 15))
        self.indeterminate_progress.start(10)
    
    def stop_animation(self):
        """停止动画效果"""
        self.animation_running = False
        if hasattr(self, 'indeterminate_progress'):
            self.indeterminate_progress.stop()
            self.indeterminate_progress.pack_forget()
    
    def update_status(self, message):
        """更新状态信息"""
        if self.dialog and self.status_var:
            self.status_var.set(message)
            self.dialog.update()
    
    def update_progress(self, value, maximum=100):
        """更新进度条"""
        if self.dialog and self.progress_var:
            progress_value = (value / maximum) * 100 if maximum > 0 else 0
            self.progress_var.set(progress_value)
            self.dialog.update()
    
    def set_progress_mode(self, determinate=True):
        """设置进度条模式"""
        if not self.dialog:
            return
            
        if determinate:
            self.stop_animation()
            # 显示确定进度条
            progress_bar = ttk.Progressbar(self.dialog.children['!frame'], 
                                          variable=self.progress_var,
                                          mode='determinate',
                                          length=300)
            progress_bar.pack(pady=(0, 15))
        else:
            self.start_animation()
    
    def cancel(self):
        """取消操作"""
        self.is_cancelled = True
        self.close()
    
    def close(self):
        """关闭对话框"""
        if self.dialog:
            self.stop_animation()
            self.dialog.grab_release()
            self.dialog.destroy()
            self.dialog = None
    
    def is_active(self):
        """检查对话框是否还在活动状态"""
        return self.dialog is not None and self.dialog.winfo_exists()


class ProgressCallback:
    """进度回调辅助类"""
    
    def __init__(self, loading_dialog):
        self.loading_dialog = loading_dialog
        self.current_step = 0
        self.total_steps = 0
    
    def set_total_steps(self, total):
        """设置总步数"""
        self.total_steps = total
        self.current_step = 0
        if self.loading_dialog:
            self.loading_dialog.set_progress_mode(determinate=True)
    
    def next_step(self, message=""):
        """下一步"""
        self.current_step += 1
        if self.loading_dialog:
            if message:
                self.loading_dialog.update_status(message)
            if self.total_steps > 0:
                self.loading_dialog.update_progress(self.current_step, self.total_steps)
    
    def update_status(self, message):
        """更新状态"""
        if self.loading_dialog:
            self.loading_dialog.update_status(message)
    
    def is_cancelled(self):
        """检查是否被取消"""
        return self.loading_dialog.is_cancelled if self.loading_dialog else False 