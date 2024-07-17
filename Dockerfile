FROM python:3.9

ARG PASSWORD=admin

ENV ASSETS_PATH=${ASSETS_PATH}

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN apt update -y
RUN apt install expect -y

RUN cat <<EOF > /update-password.sh
expect -c "
spawn jupyter notebook password 
expect \"Enter password:\"
send \"${PASSWORD}\r\"
expect \"Verify password:\"
send \"${PASSWORD}\r\"
expect eof
"
EOF

RUN bash /update-password.sh

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]