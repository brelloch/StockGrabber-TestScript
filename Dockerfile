FROM perl:5.34
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

RUN cpan -f LWP/Simple.pm
RUN cpan -f JSON.pm
RUN cpan -f LWP::Protocol::https

CMD [ "perl", "./StockGrabber_Working.pl" ]

