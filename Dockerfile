# First stage
FROM alpine:latest

ENV PSPDEV /usr/local/pspdev
ENV PATH $PATH:${PSPDEV}/bin
COPY . /src


RUN apk add build-base bash gcc git make flex bison texinfo gmp-dev mpfr-dev mpc1-dev readline-dev ncurses-dev
RUN mkdir $PSPDEV
RUN cd /src && ./toolchain.sh
RUN git log -1 --format="psptoolchain-allegrex %H %cs" >> $PSPDEV/versions.txt

# Second stage
FROM alpine:latest

ENV PSPDEV /usr/local/pspdev
ENV PATH $PATH:${PSPDEV}/bin

COPY --from=0 ${PSPDEV} ${PSPDEV}
