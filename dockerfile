FROM httpd


RUN apt-get clean && apt-get update && apt-get install -y locales
# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV BRAT_VERSION brat-1.3p1
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && apt-get update --fix-missing && \
    apt-get update && apt-get install -qq -y --no-install-recommends wget ca-certificates && rm -rf /var/lib/apt/lists/* && \
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
RUN apt-get update && apt-get install -y python

RUN /usr/local/apache2/htdocs/brat-1.3p1/install.sh $username $password $admin_email

#RUN FastCGI 
#RUN cd /usr/local/apache2/htdocs/brat-1.3p1/server/lib/ && tar xfz flup-1.0.2.tar.gz 


