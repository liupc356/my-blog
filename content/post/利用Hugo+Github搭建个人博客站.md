+++
date = '2026-01-12T01:17:53+08:00'
draft = false
title = '利用Hugo+Github搭建个人博客站'
+++
<!--more-->



## 一、环境准备

```bash
#硬件准备
1.能访问互联网的Linux主机
2.能访问Linux主机的客户端（用于测试）

#软件版本说明
1.Linux版本Ubuntu 22.04
2.hugo版本0.154.3
```

## 二、创建github仓库并同步到本地

```bash
#我创建的github仓库地址是：github.com/liupc356/My-Blog

#由于github目前已经取消使用用户名和密码验证方式，所以需要配置SSH的私钥认证
root@eve-ng:~# ssh-keygen -t ed25519 -f ~/.ssh/Identity_ed25519_for_github
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ./ssh/Identity_ed25519_for_github
Your public key has been saved in ./ssh/Identity_ed25519_for_github.pub
The key fingerprint is:
SHA256:y6qazuapawJNMZxOGEDHVAXGKQgxQ9IDybhPiJOvOI0 root@eve-ng
The key's randomart image is:
+--[ED25519 256]--+
|^@++o++.         |
|==Xo.o           |
|.* +.            |
|* +              |
| B      S        |
|. +    . .       |
|o+      o        |
|Eooo   .         |
|=BB....          |
+----[SHA256]-----+
root@eve-ng:~# 

#编辑~/.ssh/config，配置当前用户到github远程仓库的SSH连接
root@eve-ng:~# cat ~/.ssh/config 
Host github.com
        Hostname ssh.github.com
        Port 443
        User git
        IdentityFile /root/.ssh/Identity_ed25519_for_github
        IdentitiesOnly yes
        PreferredAuthentications publickey
#该配置文件说明了访问ssh.github.com这台主机时应该使用什么样的连接参数，IdentityFile参数就是制定使用的私钥，前提是你需要把公钥信息拷贝到Github.com>右上角你的用户图标>"Settings">"SSH and GPG keys">"New SSH key">拷贝公钥信息后>"add SSH key"即可
root@eve-ng:~# ls ~/.ssh/
authorized_keys  Identity_ed25519_for_github      known_hosts
config           Identity_ed25519_for_github.pub  known_hosts.old
#测试SSH连接，显示下面的提示就表示连接成功
root@eve-ng:~# ssh -T git@github.com
Hi liupc356! You've successfully authenticated, but GitHub does not provide shell access.

#克隆远程仓库到本地，由于国内到github网络不稳定，建议使用SSH链接
root@eve-ng:~# git clone git@github.com:liupc356/Test.git
Cloning into 'Test'...
warning: You appear to have cloned an empty repository.
root@eve-ng:~# cd Test/
root@eve-ng:~/Test# ls

#创建文件并推送到远程仓库
root@eve-ng:~/Test# echo 123 > readme.md
root@eve-ng:~/Test# git add *
root@eve-ng:~/Test# git status
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   readme.md

root@eve-ng:~/Test# git commit -m "readme.md"
[main (root-commit) 6df0995] readme.md
 1 file changed, 1 insertion(+)
 create mode 100644 readme.md
root@eve-ng:~/Test# git push
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Writing objects: 100% (3/3), 209 bytes | 209.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To github.com:liupc356/Test.git
 * [new branch]      main -> main
```



## 三、下载hugo，构建新站点

```bash
#使用wget下载hugo到本地，一定要带有extended的包。如果网络不佳，可以使用浏览器或迅雷下载，然后使用WinSCP工具将软件包拷贝到Linux主机上
root@eve-ng:~/Test# wget https://github.com/gohugoio/hugo/releases/download/v0.154.4/hugo_extended_0.154.3_linux-amd64.deb 

#使用hugo new命令在当前目录下初始化一个站点
root@eve-ng:~/Test# dpkg -i hugo_extended_0.154.3_linux-amd64.deb
root@eve-ng:~/Test# hugo new site ./
ERROR /root/Test already exists and is not empty. See --force.
root@eve-ng:~/Test# ls
readme.md
root@eve-ng:~/Test# hugo new site ./ --force
Congratulations! Your new Hugo site was created in /root/Test.

Just a few more steps...

1. Change the current directory to /root/Test.
2. Create or install a theme:
   - Create a new theme with the command "hugo new theme <THEMENAME>"
   - Or, install a theme from https://themes.gohugo.io/
3. Edit hugo.toml, setting the "theme" property to the theme name.
4. Create new content with the command "hugo new content <SECTIONNAME>/<FILENAME>.<FORMAT>".
5. Start the embedded web server with the command "hugo server --buildDrafts".

See documentation at https://gohugo.io/.
root@eve-ng:~/Test# ls
archetypes  assets  content  data  hugo.toml  i18n  layouts  readme.md  static  themes

```

## 四、下载ananke主题

```bash
root@eve-ng:~/Test# git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
Cloning into '/root/Test/themes/ananke'...
remote: Enumerating objects: 4106, done.
remote: Counting objects: 100% (60/60), done.
remote: Compressing objects: 100% (37/37), done.
remote: Total 4106 (delta 46), reused 23 (delta 23), pack-reused 4046 (from 2)
Receiving objects: 100% (4106/4106), 6.20 MiB | 8.07 MiB/s, done.
Resolving deltas: 100% (1988/1988), done.
root@eve-ng:~/Test# ls
archetypes  assets  content  data  hugo.toml  i18n  layouts  readme.md  static  themes
root@eve-ng:~/Test# 
```

## 五、本地测试hugo

```bash
#编辑Hugo配置文件hugo.toml，使用下载的ananke主题
root@eve-ng:~/Test# cat hugo.toml 
baseURL = 'https://example.org/'
languageCode = 'en-us'
title = 'My New Hugo Site'
theme = 'ananke'
root@eve-ng:~/Test# 

#使用hugo模板创建md格式博客文章静态文件，并编辑文件内容
root@eve-ng:~/Test# hugo new content content/post/my-frist-post.md
Content "/root/Test/content/post/my-frist-post.md" created
root@eve-ng:~/Test# vim content/post/my-frist-post.md
...(编辑结果如下)...
root@eve-ng:~/Test# cat content/post/my-frist-post.md
+++
date = '2026-01-11T05:53:53+08:00'
draft = false	#true表示不显示在首页，想要显示需要改为false
title = 'My Frist Post'
+++
This is my frist post
root@eve-ng:~/Test# 

#创建用于本地测试的简单脚本
root@eve-ng:~/Test# cat server.sh 
#!/bin/bash

hugo server --bind 192.168.1.199 --port 1313 
root@eve-ng:~/Test# chmod +x ./server.sh

#在本地测试hugo能否正常显示
root@eve-ng:~/Test# ./server.sh 
Watching for changes in /root/Test/archetypes, /root/Test/assets, /root/Test/content/post, /root/Test/data, /root/Test/i18n, /root/Test/layouts, /root/Test/static, /root/Test/themes/ananke/archetypes, /root/Test/themes/ananke/assets/ananke, /root/Test/themes/ananke/i18n, ... and 4 more
Watching for config changes in /root/Test/hugo.toml, /root/Test/themes/ananke/config/_default
Start building sites … 
hugo v0.154.3-b1c1bd019f4d65d4ebc979e2157279bb229b457f+extended linux/amd64 BuildDate=2026-01-06T16:30:17Z VendorInfo=gohugoio


                  │ EN 
──────────────────┼────
 Pages            │ 11 
 Paginator pages  │  0 
 Non-page files   │  0 
 Static files     │  2 
 Processed images │  0 
 Aliases          │  1 
 Cleaned          │  0 

Built in 81 ms
Environment: "development"
Serving pages from disk
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 192.168.1.199) 
Press Ctrl+C to stop

#然后使用客户端通过浏览器访问主机URL：http://192.168.1.199:1313/
```

![image-20260111220537652](C:\Users\liupc\AppData\Roaming\Typora\typora-user-images\image-20260111220537652.png)



## 六、使用hugo生成静态文件并推送到Github仓库

```bash
#修改本地仓库分支并推送到github远程仓库
root@eve-ng:~/Test# git checkout origin
root@eve-ng:~/Test# git branch -m main
root@eve-ng:~/Test# git add *
root@eve-ng:~/Test# git commit -m "commit"
root@eve-ng:~/Test# ls
archetypes  content  data  hugo.toml  i18n  public  resources  server.sh  themes
root@eve-ng:~/111/Test# git push -u origin main


#设置.gitignore忽略静态文件目录，public目录为生成静态文件所在目录
root@eve-ng:~/Test# cat .gitignore 
/public

#使用hugo命令生成静态文件
root@eve-ng:~/Test# hugo 
Start building sites … 
hugo v0.154.3-b1c1bd019f4d65d4ebc979e2157279bb229b457f+extended linux/amd64 BuildDate=2026-01-06T16:30:17Z VendorInfo=gohugoio


                  │ EN 
──────────────────┼────
 Pages            │ 11 
 Paginator pages  │  0 
 Non-page files   │  0 
 Static files     │  2 
 Processed images │  0 
 Aliases          │  1 
 Cleaned          │  0 

Total in 121 ms

#修改配置文件hugo.toml,设置静态文件使用的baseURL，这样静态文件在放入github的workflow时能够正确访问到所需文件
root@eve-ng:~/111/Test# cat hugo.toml 
baseURL = 'https://liupc356.github.io/Test/'
languageCode = 'en-us'
title = 'My New Hugo Site'
theme = 'ananke'
root@eve-ng:~/111/Test# 

#将静态文件推送github远程仓库，并作为单独分支，这样在之后更新博客时，不会影响静态文件，分开管理
root@eve-ng:~/Test/public# ls
404.html  ananke  categories  images  index.html  index.xml  post  sitemap.xml  tags
root@eve-ng:~/Test/public# git init 
Initialized empty Git repository in /root/111/Test/public/.git/
root@eve-ng:~/Test/public# git remote add  origin git@github.com:liupc356/Test.git
root@eve-ng:~/Test/public# git pull
remote: Enumerating objects: 151, done.
remote: Counting objects: 100% (151/151), done.
remote: Compressing objects: 100% (86/86), done.
remote: Total 151 (delta 51), reused 127 (delta 27), pack-reused 0 (from 0)
Receiving objects: 100% (151/151), 325.87 KiB | 150.00 KiB/s, done.
Resolving deltas: 100% (51/51), done.
From github.com:liupc356/Test
 * [new branch]      main       -> origin/main
There is no tracking information for the current branch.
Please specify which branch you want to merge with.
See git-pull(1) for details.

    git pull <remote> <branch>

If you wish to set tracking information for this branch you can do so with:

    git branch --set-upstream-to=origin/<branch> hugo-pages

root@eve-ng:~/111/Test/public# git status
On branch hugo-pages

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        404.html
        ananke/
        categories/
        images/
        index.html
        index.xml
        post/
        sitemap.xml
        tags/

nothing added to commit but untracked files present (use "git add" to track)
root@eve-ng:~/111/Test/public# git add *
root@eve-ng:~/111/Test/public# git commit -m "hugo-pages"
[hugo-pages (root-commit) 7915f41] hugo-pages
 15 files changed, 865 insertions(+)
 create mode 100644 404.html
 create mode 100644 ananke/css/main.css.map
 create mode 100644 ananke/css/main.min.efe4d852f731d5d1fbb87718387202a97aafd768cdcdaed0662bbe6982e91824.css
 create mode 100644 categories/index.html
 create mode 100644 categories/index.xml
 create mode 100644 images/gohugo-default-sample-hero-image.jpg
 create mode 100644 index.html
 create mode 100644 index.xml
 create mode 100644 post/index.html
 create mode 100644 post/index.xml
 create mode 100644 post/my-frist-post/index.html
 create mode 100644 post/page/1/index.html
 create mode 100644 sitemap.xml
 create mode 100644 tags/index.html
 create mode 100644 tags/index.xml
root@eve-ng:~/Test/public#
root@eve-ng:~/Test/public# git push -u origin hugo-pages
Enumerating objects: 26, done.
Counting objects: 100% (26/26), done.
Delta compression using up to 56 threads
Compressing objects: 100% (22/22), done.
Writing objects: 100% (26/26), 314.29 KiB | 1.00 MiB/s, done.
Total 26 (delta 9), reused 3 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (9/9), done.
remote: 
remote: Create a pull request for 'hugo-pages' on GitHub by visiting:
remote:      https://github.com/liupc356/Test/pull/new/hugo-pages
remote: 
To github.com:liupc356/Test.git
 * [new branch]      hugo-pages -> hugo-pages
Branch 'hugo-pages' set up to track remote branch 'hugo-pages' from 'origin'.
root@eve-ng:~/Test/public# git branch 
* hugo-pages
root@eve-ng:~/Test/public# git branch -a
* hugo-pages
  remotes/origin/hugo-pages
  remotes/origin/main
root@eve-ng:~/Test/public# cd ..
root@eve-ng:~/Test# git branch 
* main
root@eve-ng:~/Test# 
```

## 七、使用Github的工作流功能，构建你的静态网页文件

```bash
#使用浏览器进入你的Github远程仓库：https://github.com/liupc356/Test，点击仓库菜单栏的"Settings">侧栏"General"的"Pages">在右边"Build and deployment"的"Branch">从下拉选项中选中"hugo-pages">点击"Save"。

#然后查看构建进度：点击仓库菜单栏的"Action"，可以看到"All workflows"下你的静态文件构建进度，显示"✅️"就表示构建成功。

#访问构建好的博客URL：https://liupc356.github.io/Test/


```

















