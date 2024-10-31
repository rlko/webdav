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

## Generating the `htpasswd` File

To create a `htpasswd` file for authentication, you need to have **htpasswd** installed on your host or you can call it from the container:

```bash
alias htpasswd="docker compose -f $PWD/docker-compose.yml run --rm webdav htpasswd"
```

You can now use the following command:

```bash
htpasswd -n username >> htpasswd
```

Make sure the htpasswd file is readable by www-data inside the container. (chown or chmod)


Or if you only need one entry you can set it up on the `HTPASSWD` environment variable:

```bash
user=foobar
echo "HTPASSWD='$(htpasswd -n $user)'" >> .env
```
**Note**: When generating the `HTPASSWD` variable for your `.env` file, be sure to use single quotes to ensure proper parsing.

## Running the WebDAV Server

To run the WebDAV server, you can use docker compose:

```bash
docker compose up
```

Or without docker compose:

- Build the image first:
```bash
(cd build && docker build -t my-apache-webdav-image . )
```

- Then run:
```bash
docker run -d \
  -e SERVER_NAME=example.domain.com \
  -p 443:4443 \
  -v ./dav:/var/www/dav \
  -v ./htpasswd:/etc/apache2/webdav.htpasswd \ # If mounting htpasswd file instead of adding the hash entry in the env.
  --name my-apache-webdav
  my-apache-webdav-image
```

## SSL Certificates

By default, the server will automatically generate self-signed SSL certificates if they are not present in the designated volume paths. You can also provide your own certificate files by mounting them as volumes. To do this, ensure you have the following files available:

- `server.crt`: The server's public certificate.
- `server.key`: The private key for the certificate.

Mount these files into the container at the appropriate paths for SSL configuration.
You can check the [docker compose](docker-compose.yml) file to see the paths

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.
