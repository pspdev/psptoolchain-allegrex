# First stage
# Please change the alpine version back to latest after 3.19 releases
FROM alpine:3.16

ENV PSPDEV /usr/local/pspdev
ENV PATH $PATH:${PSPDEV}/bin
COPY . /src


RUN apk add build-base bash gcc git make flex bison texinfo gmp-dev mpfr-dev mpc1-dev readline-dev ncurses-dev
RUN mkdir $PSPDEV
RUN cd /src && ./toolchain.sh

# Second stage
FROM alpine:latest

ENV PSPDEV /usr/local/pspdev
ENV PATH $PATH:${PSPDEV}/bin

COPY --from=0 ${PSPDEV} ${PSPDEV}
