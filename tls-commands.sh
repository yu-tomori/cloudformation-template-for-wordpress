#!/bin/bash
amazon-linux-extras install -y epel
yum install certbot python-certbot-apache
certbot certonly --webroot -w /var/www/html/wordpress -d shopify.ichyaku.com
# -> (email) incruten@gmail.com
# -> (agree to the term of use) Y
# -> (register to mailing list) N
ls -l /etc/letsencrypt/live/shopify.ichyaku.com/
# output:
#   合計 4
#   -rw-r--r-- 1 root root 692  4月 27 02:40 README
#   lrwxrwxrwx 1 root root  43  4月 27 02:40 cert.pem -> ../../archive/shopify.ichyaku.com/cert1.pem
#   lrwxrwxrwx 1 root root  44  4月 27 02:40 chain.pem -> ../../archive/shopify.ichyaku.com/chain1.pem
#   lrwxrwxrwx 1 root root  48  4月 27 02:40 fullchain.pem -> ../../archive/shopify.ichyaku.com/fullchain1.pem
#   lrwxrwxrwx 1 root root  46  4月 27 02:40 privkey.pem -> ../../archive/shopify.ichyaku.com/privkey1.pem
vim /etc/httpd/conf.d/ssl.conf
# https://qiita.com/JXnj8uVrUkiBh90/items/761545587cdb263c6479の記事にあるとおりに編集する

vim /etc/httpd/conf.d/rewrite.conf
# # 以下を書き込む
# <IfModule rewrite_module>
#     RewriteEngine On
#     LogLevel alert rewrite:trace3
#     RewriteCond %{HTTPS} off
#     RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [R,L]
# </IfModule>
systemctl restart httpd

vim /etc/letsencrypt/renew-tls-cert.sh
# # 以下を書き込む
# certbot renew -q --no-self-upgrade --post-hook "systemctl restart httpd"
chmod 0700 /etc/letsencrypt/renew-tls-cert.sh

crontab -e
# # 以下を書き込む。毎日UTC18時(Tokyo3時)に証明書の有効期限をチェックして、切れそうなら更新する。
# 0 18 * * * /etc/letsencrypt/renew-tls-cert.sh
