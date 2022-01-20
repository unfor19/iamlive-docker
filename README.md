# iamlive-docker

[![Push latest version to DockerHub](https://github.com/unfor19/iamlive-docker/actions/workflows/release.yml/badge.svg)](https://github.com/unfor19/iamlive-docker/actions/workflows/release.yml) [![Dockerhub pulls](https://img.shields.io/docker/pulls/unfor19/iamlive-docker)](https://hub.docker.com/r/unfor19/iamlive-docker)


Run [iamlive](https://github.com/iann0036/iamlive) as a Docker container.

To read more about how iamlive works, see [Determining AWS IAM Policies According To Terraform And AWS CLI
](https://meirg.co.il/2021/04/23/determining-aws-iam-policies-according-to-terraform-and-aws-cli/)

## Getting Started

1. Git clone this repo
2. Build the Docker image
   ```bash
   make build
   ```
3. **Terminal #1**: Run the Docker image for the first time
    ```bash
    make run
    # Runs in the background ...
    # Average Memory Usage: 88MB
    ```
4. **Terminal #2**: Copy CA certificate from the container to host; In any case, do not remove the `iamlive` container. This will keep the `ca.pem` valid for future runs, so this step will be skipped in future runs.
    ```bash
    make copy
    ```
5. **Terminal #2**: Set environment variables
   ```bash
    export AWS_ACCESS_KEY_ID="MY_AWS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="MY_AWS_SECRET_ACCESS_KEY"
    # export AWS_PROFILE="MY_AWS_PROFILE"
    export \
        HTTP_PROXY=http://127.0.0.1:80 \
        HTTPS_PROXY=http://127.0.0.1:443 \
        AWS_CA_BUNDLE="${HOME}/.iamlive/ca.pem"
   ```
6. **Terminal #2**: Test it by making calls to AWS, using the CLI is the easiest way
   ```bash
   aws s3 ls
   ```

   **Terminal #1**: iamlive output after `aws s3 ls`
   ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:ListAllMyBuckets"
                ],
                "Resource": "*"
            }
        ]
    }   
   ```
7. **Terminal #1**: Stop the iamlive container
   ```bash
   make stop
   ```
8. **Terminal #1**: Start iamlive container again (no need to invoke `make copy`)
   ```bash
   make start
   ```
9. **Terminal #2**: Do your thing ;)
## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)

## License

This project is licensed under the [DBAD](https://dbad-license.org/) License - see the [LICENSE](https://github.com/unfor19/iamlive-docker/blob/master/LICENSE) file for details
