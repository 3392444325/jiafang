# 织云 ZHIYUN — 数据库配置与部署指南

本项目（Spring Boot 后端 + Vue3 前端）的数据库连接已全部**参数化**：
换数据库、换密码 **不需要修改任何代码或 application.yml**，表结构由
JPA 自动建表（`ddl-auto: update`）保证不变。

## 一、配置优先级（从高到低）

1. 系统环境变量：`DB_HOST` / `DB_PORT` / `DB_NAME` / `DB_USERNAME` / `DB_PASSWORD`
2. `backend\application-local.yml`（私有配置文件，已被 .gitignore 排除）
3. `application.yml` 中的默认值（localhost:3306 / 库名 zhiyun / 用户 root / 空密码）

任意一层配置了即可，越靠前越优先。

## 二、本地开发：首次配置（一次性）

1. 复制模板并填入真实密码：

   ```
   cd /d D:\system\program\newprogram
   copy backend\application-local.yml.example backend\application-local.yml
   notepad backend\application-local.yml
   ```

2. 修改 MySQL 密码（如需）：

   ```sql
   mysql -u root -p
   ALTER USER 'root'@'localhost' IDENTIFIED BY '新的强密码';
   FLUSH PRIVILEGES;
   ```

3. 双击 `start.bat` 正常启动，后端会自动读取 `application-local.yml`。

> 也可以不建 local 文件，改为设置系统环境变量 `DB_PASSWORD`（推荐二选一，
> 环境变量方式更适合服务器）。

## 三、更换数据库密码

只需改两个地方之一：

- **local 文件方式**：编辑 `backend\application-local.yml` 里的 `password`，重启后端。
- **环境变量方式**：改系统环境变量 `DB_PASSWORD` 后重启后端（或重启后重开终端）。

MySQL 侧同步执行：

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY '新密码';
FLUSH PRIVILEGES;
```

## 四、更换数据库（库名 / 实例）

**换库名（同实例）**：

```sql
CREATE DATABASE 新库名 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

然后设置环境变量 `DB_NAME=新库名`（或在 application-local.yml 里覆盖整条
`url`，保留 `createDatabaseIfNotExist=true`）。首次连接会自动建表；
如需保留旧数据，先迁移：

```powershell
mysqldump -u root -p zhiyun > backup.sql
mysql -u root -p 新库名 < backup.sql
```

**换数据库服务器**：设置 `DB_HOST`（服务器 IP）、`DB_PORT`（默认 3306）、
`DB_USERNAME`、`DB_PASSWORD` 即可。

## 五、部署到甲方服务器（推荐做法）

1. **服务器上安装** JDK 17+、MySQL 8、Node.js（仅构建前端时需要）。
2. 把代码包上传到服务器，**不要**包含 `backend\application-local.yml`。
3. 在服务器的 backend 目录创建 `application-local.yml`（参考
   `application-local.yml.example`），填入甲方数据库的真实账号密码。
   这样以后代码更新（git pull / 重新打包）**永远不会覆盖或泄露数据库密码**。
4. 安全清单：
   - 为应用创建专用 MySQL 账号并只授权本项目库：
     ```sql
     CREATE USER 'zhiyun'@'localhost' IDENTIFIED BY '应用专用强密码';
     GRANT ALL PRIVILEGES ON zhiyun.* TO 'zhiyun'@'localhost';
     FLUSH PRIVILEGES;
     ```
     然后 `application-local.yml` 中 `username: zhiyun`。
   - 生产启用 HTTPS 后，在 local 文件中设置 `zy.cookie.secure: true`
     （session cookie 将带 Secure 标记）。
   - 修改 MySQL 默认 3306 端口对外的访问范围（仅本机/内网），关闭 root 远程访问。
   - 启动方式（生产建议打包运行，不依赖 Maven）：
     ```powershell
     cd backend
     mvn -q -DskipTests package
     java -jar target\zhiyun-backend-*.jar
     ```
     前端构建后由 Nginx 托管 `frontend\dist`，并将 `/api` 反向代理到 `http://127.0.0.1:8082/api`。
5. 数据库**表结构不变**：由 JPA `ddl-auto: update` 在启动时自动对齐，
   换库时首次启动会自动建全量表。

## 六、常见问题

| 现象 | 原因 / 处理 |
| --- | --- |
| 启动报 `Access denied for user` | 密码配置未生效：检查 local 文件是否在 backend 目录下、环境变量是否在新终端生效 |
| 密码含 `$` 等特殊字符启动失败 | yml 中用引号包住：`password: "xx$yy"`；设置环境变量时 PowerShell 用单引号 |
| 想确认后端连的是哪个库 | 看启动日志里 Hibernate 连接 URL，或临时把 `logging.level.org.hibernate.SQL` 调成 debug |
