FROM denoland/deno:1.42.1

WORKDIR /app

COPY . .
RUN deno task build
RUN deno cache main.ts

EXPOSE 8000

CMD ["deno", "run", "-A", "main.ts"]
