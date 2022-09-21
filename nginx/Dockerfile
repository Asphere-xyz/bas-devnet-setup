FROM nginx:latest
COPY ./nginx.conf /nginx.conf
COPY ./entrypoint.bash /entrypoint.bash
RUN chmod +x /entrypoint.bash
ENTRYPOINT ["/entrypoint.bash"]