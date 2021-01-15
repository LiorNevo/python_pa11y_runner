FROM node:14.15.4-buster-slim

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
ENV NODE_ENV production
ENV TERM xterm-color

WORKDIR /opt

RUN apt-get update \ 
	&& apt-get install -yq --no-install-recommends \
        wget \
        curl \
		vim \
		libasound2 \
		libatk1.0-0 \
		libc6 \
		libcairo2 \
		libcups2 \
		libdbus-1-3 \ 
		libexpat1 \
		libfontconfig1 \
		libgcc1 \
		libgconf-2-4 \
		libgdk-pixbuf2.0-0 \
		libglib2.0-0 \
		libgtk-3-0 \
		libnspr4 \ 
		libpango-1.0-0 \
		libpangocairo-1.0-0 \
		libstdc++6 \
		libx11-6 \
		libx11-xcb1 \
		libxcb1 \ 
		libxcursor1 \
		libxdamage1 \
		libxext6 \
		libxfixes3 \
		libxi6 \
		libxrandr2 \
		libxrender1 \
		libxss1 \
		libxtst6 \ 
		libnss3 

USER node
RUN npm install -g pa11y-ci \
	&& npm install -g pa11y

USER root
ADD init.sh /opt/init.sh
RUN chmod +x /opt/init.sh

ENTRYPOINT [ "/opt/init.sh" ]