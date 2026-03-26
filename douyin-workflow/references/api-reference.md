# 抖音运营 API 参考

## 创作者中心 URLs

| 功能 | URL |
|------|-----|
| 首页 | `https://creator.douyin.com/` |
| 发布视频 | `https://creator.douyin.com/creator-micro/content/upload` |
| 内容管理 | `https://creator.douyin.com/creator-micro/content/manage` |
| 数据中心 | `https://creator.douyin.com/creator-micro/data/overview` |
| 评论管理 | `https://creator.douyin.com/creator-micro/content/comment` |

## Web 页面元素选择器

> 注意：抖音页面元素经常变化，选择器需要定期更新

### 发布视频页面

```javascript
// 视频上传输入框
input[type="file"]

// 标题输入框
.title-input, input[placeholder*="标题"]

// 描述输入框
.desc-input, textarea[placeholder*="描述"]

// 发布按钮
.publish-btn, button:has-text("发布")

// 定时发布选项
.schedule-option, [class*="timing"]
```

### 视频详情页面

```javascript
// 点赞按钮
[class*="like-icon"], [class*="digg"]

// 评论按钮
[class*="comment-icon"], [class*="comment-btn"]

// 分享按钮
[class*="share-icon"], [class*="share-btn"]

// 评论列表
[class*="comment-item"], [class*="CommentItem"]

// 评论输入框
[class*="comment-input"], textarea[placeholder*="评论"]
```

### 用户主页

```javascript
// 粉丝数
[class*="fans-count"], [class*="follower"]

// 关注按钮
[class*="follow-btn"], button:has-text("关注")

// 私信按钮
[class*="private-message"], [class*="message-btn"]
```

## Cookies 管理

### 关键 Cookies

| Cookie 名称 | 用途 | 有效期 |
|-------------|------|--------|
| `sessionid` | 会话标识 | ~7天 |
| `ttwid` | 设备标识 | ~30天 |
| `passport_csrf_token` | CSRF 防护 | 会话级 |

### Cookies 文件格式

```json
{
  "cookies": [
    {
      "name": "sessionid",
      "value": "xxx",
      "domain": ".douyin.com",
      "path": "/",
      "expires": 1234567890,
      "httpOnly": true,
      "secure": true
    }
  ],
  "created_at": "2026-03-01T00:00:00Z",
  "account_name": "我的账号"
}
```

## 反检测策略

### 1. 随机延迟

```python
import random
import asyncio

async def random_delay(min_sec=1, max_sec=3):
    await asyncio.sleep(random.uniform(min_sec, max_sec))
```

### 2. 模拟人类行为

```python
# 随机鼠标移动
await page.mouse.move(
    random.randint(0, 1920),
    random.randint(0, 1080)
)

# 随机滚动
await page.evaluate(f"window.scrollBy(0, {random.randint(100, 500)})")
```

### 3. User-Agent 轮换

```python
user_agents = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
]

context = await browser.new_context(
    user_agent=random.choice(user_agents)
)
```

### 4. 浏览器指纹

```python
# 隐藏 webdriver 特征
await page.evaluate("""
    Object.defineProperty(navigator, 'webdriver', {
        get: () => undefined
    });
""")
```

## 发布限制

| 操作 | 频率限制 | 建议 |
|------|----------|------|
| 发布视频 | 50条/天 | 3-5条/天 |
| 发布图文 | 50条/天 | 5-10条/天 |
| 评论 | 100条/小时 | 20条/小时 |
| 点赞 | 500次/小时 | 100次/小时 |
| 私信 | 50条/小时 | 10条/小时 |

## 错误处理

### 常见错误

| 错误 | 原因 | 解决方案 |
|------|------|----------|
| 登录过期 | Cookies 失效 | 重新获取 Cookies |
| 操作频繁 | 触发风控 | 降低操作频率 |
| 内容审核 | 敏感内容 | 修改内容后重试 |
| 网络错误 | 连接问题 | 检查网络后重试 |

### 错误码

```
1001: 未登录
1002: 登录过期
2001: 操作频繁
2002: 权限不足
3001: 内容违规
3002: 视频格式错误
```