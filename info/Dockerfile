FROM centos:centos7

RUN yum install epel-release -y
RUN yum install python-pip -y

RUN pip install enum34
RUN pip install websocket-server==0.4
RUN pip install pytz
RUN pip install requests

RUN yum install git -y
RUN git clone https://github.com/g78101/BridgeApp.git
RUN yum remove git -y

CMD ["python","/BridgeApp/Server/Server.py"]