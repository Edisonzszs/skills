# 抖音运营常见问题解决

## 登录问题

### Q: Cookies 获取后无法使用

**原因：**
1. Cookies 格式不正确
2. Cookies 已过期
3. IP 地址变化触发风控

**解决方案：**
```bash
# 1. 检查 cookies 格式
cat ~/.douyin/cookies.json | jq '.cookies | length'

# 2. 重新获取 cookies
./scripts/get-cookie.sh

# 3. 检查关键 cookies 是否存在
python3 -c "
import json
with open('$HOME/.douyin/cookies.json') as f:
    data = json.load(f)
    names = [c['name'] for c in data.get('cookies', [])]
    print('Cookies:', names)
    print('Has sessionid:', 'sessionid' in names)
"
```

### Q: 登录后提示"账号异常"

**原因：** 触发了抖音的风控机制

**解决方案：**
1. 暂停自动化操作 24-48 小时
2. 使用手机 App 正常使用一段时间
3. 降低自动化操作频率

## 发布问题

### Q: 视频上传失败

**可能原因：**
1. 视频格式不支持
2. 视频大小超限
3. 网络问题
4. 内容审核

**解决方案：**
```bash
# 1. 检查视频格式
ffprobe -v error -show_entries stream=codec_name -of default=noprint_wrappers=1 video.mp4

# 2. 转换格式
ffmpeg -i input.mov -c:v libx264 -c:a aac output.mp4

# 3. 压缩视频
ffmpeg -i input.mp4 -crf 28 -preset fast output.mp4
```

### Q: 发布后视频被下架

**原因：** 内容违规

**解决方案：**
1. 检查违规原因通知
2. 修改内容后重新发布
3. 避免敏感词/画面

## 自动化问题

### Q: Playwright 启动浏览器报错

**错误信息：** `Executable doesn't exist at...`

**解决方案：**
```bash
# 安装浏览器驱动
playwright install chromium

# 或使用系统浏览器
export PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser
```

### Q: WSL2 环境浏览器无法启动

**原因：** 没有 GUI 显示

**解决方案：**
```bash
# 方式一：使用 WSLg（Windows 11 内置）
export DISPLAY=:0

# 方式二：使用 VcXsrv
# 1. 安装 VcXsrv（Windows）
# 2. 启动 XLaunch
# 3. 设置环境变量
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
```

### Q: 操作被检测为机器人

**表现：** 频繁验证码、操作限制

**解决方案：**
1. 降低操作频率
2. 增加随机延迟
3. 模拟人类行为
4. 使用代理 IP 轮换

```python
# 反检测代码示例
async def human_like_delay():
    await asyncio.sleep(random.uniform(2, 5))
    
async def human_like_scroll(page):
    for _ in range(random.randint(2, 5)):
        await page.evaluate(f"window.scrollBy(0, {random.randint(100, 300)})")
        await asyncio.sleep(random.uniform(0.5, 1.5))
```

## 数据问题

### Q: 数据获取不完整

**原因：** 页面未完全加载

**解决方案：**
```python
# 增加等待时间
await page.wait_for_load_state("networkidle")
await asyncio.sleep(3)

# 等待特定元素
await page.wait_for_selector('[class*="data-item"]', timeout=10000)
```

### Q: 评论/私信发送失败

**原因：** 频率限制或权限问题

**解决方案：**
1. 检查账号是否有私信权限
2. 降低发送频率
3. 检查内容是否触发敏感词过滤

## 性能优化

### Q: 自动化脚本运行慢

**优化方案：**
```python
# 1. 使用 headless 模式
browser = await p.chromium.launch(headless=True)

# 2. 禁用不必要的资源
async def route_handler(route):
    if route.request.resource_type in ["image", "font", "stylesheet"]:
        await route.abort()
    else:
        await route.continue_()
        
await page.route("**/*", route_handler)

# 3. 复用浏览器实例
# 创建一次 browser，多次使用 page
```

### Q: 内存占用过高

**解决方案：**
```python
# 定期关闭页面
await page.close()

# 限制并发数
semaphore = asyncio.Semaphore(5)

async def limited_task(url):
    async with semaphore:
        # 执行任务
        pass
```

## 调试技巧

### 开启详细日志

```python
import logging
logging.basicConfig(level=logging.DEBUG)
```

### 截图调试

```python
await page.screenshot(path="debug.png")
```

### 录制视频

```python
browser = await p.chromium.launch(
    headless=True,
    record_video_dir="videos/"
)
```

### 保存页面内容

```python
html = await page.content()
with open("debug.html", "w") as f:
    f.write(html)
```