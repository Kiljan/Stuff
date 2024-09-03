# Proxy_set_header

Is a directive in Nginx that allows you to modify HTTP headers when acting as a reverse proxy or load balancer. It's an important configuration option that helps control how client requests are forwarded to upstream servers.

## Purpose of proxy_set_header

1. The main purpose of proxy_set_header is to customize the headers sent from the client to the upstream server. This can be useful in various scenarios:
   1. Modifying request headers based on specific conditions
   1. Setting default values for certain header
   1. Removing unwanted headers from the original request
   1. Adding new headers that weren't present in the original request

## Basic Syntax

The basic syntax of proxy_set_header is as follows:

```bash
proxy_set_header header_name value;
```

Where header_name is the name of the HTTP header, and value is the desired value for that header.

## Common Uses

1. Setting custom headers:

    ```bash
    proxy_set_header X-Custom-Header "My Value";
    ```

1. Modifying existing headers:

    ```bash
    proxy_set_header Host $host;
    ```

1. Removing unwanted headers:

    ```bash
    proxy_set_header Accept-Encoding "";
    ```

1. Forwarding original headers:

    ```bash
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    ```

1. Setting default values:

```bash
proxy_set_header Accept-Encoding gzip;
```

## Important Notes

1. Multiple __proxy_set_header__ directives can be used within a single location block.
1. The order of __proxy_set_header__ directives matters; __later directives override earlier ones__
1. Some headers, like __Host__, __Accept-Encoding__, and __User-Agent__, are automatically handled by Nginx and may need special handling.

## Performance Considerations

It's worth noting that excessive use of proxy_set_header can impact performance, especially if you're setting headers for every request. Always consider whether you really need to modify a particular header for every request.

## Conclusion

proxy_set_header is a powerful tool in Nginx configuration, allowing you to fine-tune how requests are forwarded to upstream servers. By carefully using this directive, you can customize HTTP headers, improve security, optimize performance, and enhance the overall functionality of your reverse proxy setup.
