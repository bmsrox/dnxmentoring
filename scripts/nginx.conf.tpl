upstream app {
    ${join("\n", formatlist("\t\tserver %s;", split(",", upstream_list)))}
}

server {
    listen       80;
    server_name  localhost;

    location / {
        proxy_pass         http://app;
    }
}