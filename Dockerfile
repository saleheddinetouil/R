FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Install ngrok
WORKDIR /app
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip && \
    unzip ngrok-stable-windows-amd64.zip && \
    mv ngrok-stable-windows-amd64 ngrok && \
    chmod +x ./ngrok/ngrok.exe
