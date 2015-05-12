FROM          ubuntu:latest
MAINTAINER    Thiago Zilli <tzilli@corp.mediaresponse.com>

#RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#no interactive with frontend
ENV DEBIAN_FRONTEND noninteractive

#update system
RUN apt-get update
RUN apt-get upgrade -y

# Install dependencies
RUN apt-get install -y vim git curl wget imagemagick

# Make ssh dir
RUN mkdir /root/.ssh/

# Create known_hosts
RUN touch /root/.ssh/known_hosts

# Add github.com key to known
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

#variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION v0.12.0

RUN mkdir -p /usr/local/nvm

#Clone and install NVM 
RUN git clone https://github.com/creationix/nvm.git $NVM_DIR

#Clone the app
RUN git clone https://github.com/thiagozs/node-hello.git /node-hello

#variables
RUN echo "$NVM_DIR/nvm.sh" >> /etc/bash.bashrc
RUN echo "$NVM_DIR/nvm.sh" >> /root/.bashrc

#variables
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

# Install nvm with node and npm
RUN /bin/bash -c "source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default"

# Install node.js and run npm
RUN /bin/bash -c "source $NVM_DIR/nvm.sh \
	&& npm install forever -g \
	&& npm install sails@0.10.5 -g \
	&& cd /node-hello \
	&& npm install"

#setup port to external
EXPOSE 3001

#fire application
#CMD source $NVM_DIR/nvm.sh && forever start /node-hello/app.js
CMD /bin/bash -c "source $NVM_DIR/nvm.sh && node /node-hello/app.js"
