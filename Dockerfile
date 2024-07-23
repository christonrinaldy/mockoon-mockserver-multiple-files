FROM node:18-alpine

WORKDIR /app

# Update package lists and install jq
RUN apk --no-cache add jq
RUN npm install -g @mockoon/cli@4.0.0

RUN mkdir -p scripts mock-responses app/data
COPY mock-responses/* app/mock-responses/
COPY scripts/* app/scripts/
COPY mock-response-configurations.json app/mock-response-configurations.json

# Make sure your script is executable
RUN chmod +x app/scripts app/data

# Run dos2unix to convert line endings
RUN apk add --no-cache dos2unix && \
    dos2unix app/scripts/entrypoint.sh && \
    chmod +x app/scripts/entrypoint.sh && \
    apk del dos2unix

CMD ["/bin/sh", "app/scripts/entrypoint.sh"]

# Usage: docker run -p <host_port>:<container_port> mockoon-test
