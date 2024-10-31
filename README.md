# webdav

This project sets up a WebDAV server using Apache2 on a Docker container.

## Prerequisites

- Docker
- Docker Compose (optional)

## Environment Variables

| Variable       | Description                                                                                  | Required |
|----------------|----------------------------------------------------------------------------------------------|----------|
| `SERVER_NAME`  | The fully qualified domain name (FQDN) of your server.                                     | Yes      |
| `HTPASSWD`     | The hash of the htpasswd entry for authentication. If you need more than one entry, you can mount the file as a volume instead. | No       |
| `SERVER_ADMIN` | The email address of the server administrator. This will be used in the `ServerAdmin` directive of the Apache configuration. | No       |
| `AUTH_NAME`    | The name of the authentication realm that will be displayed in the login prompt.           | No       |

## Running the WebDAV Server

To run the WebDAV server, you can use Docker. Refer to the documentation for specific commands to run the container.

```bash
(cd build && docker build -t my-apache-webdav-image . )
```

```bash
docker run -d \
  -e SERVER_NAME=example.domain.com \
  -p 443:4443 \
  -v ./dav:/var/www/dav \
  -v ./htpasswd:/etc/apache2/webdav.htpasswd \ # If mounting htpasswd file instead of adding the hash entry in the env.
  --name my-apache-webdav
  my-apache-webdav-image
```


