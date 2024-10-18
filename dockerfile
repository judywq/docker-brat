FROM httpd:2.4.62

# Install dependencies and set locale
RUN apt-get clean && apt-get update && apt-get install -y locales \
    wget \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev && \
    locale-gen en_US.UTF-8 && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && apt-get update --fix-missing

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV BRAT_VERSION brat-1.3p1

# Download and build Python 2.7 from source
RUN wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz && \
    tar xzf Python-2.7.18.tgz && \
    cd Python-2.7.18 && \
    ./configure --enable-optimizations && \
    make altinstall && \
    rm -f /Python-2.7.18.tgz

# Optionally set Python 2 as the default
RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python2.7 1

# Download and set up BRAT
RUN apt-get update && apt-get install -qq -y --no-install-recommends wget ca-certificates && \
    wget -qO /usr/local/apache2/htdocs/$BRAT_VERSION.tar.gz "https://github.com/nlplab/brat/archive/refs/tags/v1.3p1.tar.gz" && \
    tar -xvzf /usr/local/apache2/htdocs/$BRAT_VERSION.tar.gz && \
    mv /usr/local/apache2/brat-1.3p1/ /usr/local/apache2/htdocs/ && \
    rm /usr/local/apache2/htdocs/$BRAT_VERSION.tar.gz && \
    apt-get purge -y --auto-remove wget 

ARG username
ARG password
ARG admin_email

ADD httpd.conf /usr/local/apache2/conf/
ADD install.sh /usr/local/apache2/htdocs/brat-1.3p1/

# Run BRAT install script with provided arguments
RUN /usr/local/apache2/htdocs/brat-1.3p1/install.sh $username $password $admin_email

#RUN FastCGI 
#RUN cd /usr/local/apache2/htdocs/brat-1.3p1/server/lib/ && tar xfz flup-1.0.2.tar.gz 


