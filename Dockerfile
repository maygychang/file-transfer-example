FROM ubuntu:20.04

RUN apt-get update && apt-get install -y software-properties-common gcc && \
    add-apt-repository -y ppa:deadsnakes/ppa

RUN apt-get update && apt-get install -y python3.9 python3-distutils python3-pip python3-apt vim python3.9-venv

RUN apt-get install -y python-dev libopenblas-dev git openjdk-8-jdk vim curl

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates gnupg curl sudo

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y


RUN python3.9 -m venv /venv

ENV \
    PYTHONPATH=/file_test \
    PATH="/venv/bin:$PATH" \
    LANG=C.UTF-8

WORKDIR /file_test
COPY . .

RUN set -x \
    && pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

CMD ["sh", "init.sh"]
EXPOSE 8080
~                                                              